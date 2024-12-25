package com.mix.handler;


import com.mix.service.ChannelCounter;
import io.netty.buffer.ByteBuf;
import io.netty.channel.Channel;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.util.CharsetUtil;
import lombok.extern.slf4j.Slf4j;

import java.net.InetSocketAddress;

/**
 * Created by reeves on 2023/7/18.
 */
@Slf4j
//@ChannelHandler.Sharable
public class ClinetChannelDataHandler extends ChannelInboundHandlerAdapter  {
    Channel channel;

    public ClinetChannelDataHandler(Channel channel) {
        this.channel = channel;
    }

    /**
     * 业务处理逻辑
     * 用于处理读取数据请求的逻辑。
     * ctx - 上下文对象。其中包含于客户端建立连接的所有资源。 如： 对应的Channel
     * msg - 读取到的数据。 默认类型是ByteBuf，是Netty自定义的。是对ByteBuffer的封装。 因为要把读取到的数据写入另外一个通道所以必须要考虑缓冲区复位问题,不然会报错。
     */
    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
        // 获取读取的数据， 是一个缓冲。
        ByteBuf readBuffer = (ByteBuf) msg;
        String msgStr = readBuffer.toString(CharsetUtil.UTF_8);
//        log.info("client read times :" + ChannelCounter.clientReadTimes.addAndGet(1));
        //缓冲区复位
        readBuffer.retain();
        readBuffer.release();
        if (channel.isActive() && channel.isWritable()) {
            ChannelFuture cf = channel.writeAndFlush(readBuffer);
            if (cf.isDone() && cf.cause() != null) {
                log.error("channelWrite error!", cf.cause());
                ctx.close();
            }
        }
    }

    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) throws Exception {
        if (!ctx.channel().isWritable()) {
            Channel channel = ctx.channel();
            log.info("client channel is unwritable, turn off autoread, clientId:{}", channel.id().asShortText());
            channel.config().setAutoRead(false);
        }
    }

    @Override
    public void channelWritabilityChanged(ChannelHandlerContext ctx) throws Exception
    {
        Channel channel = ctx.channel();
        if (channel.isWritable()) {
            log.info("client channel is writable again, turn on autoread, clientId:{}", channel.id().asShortText());
            channel.config().setAutoRead(true);
        }
    }

    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        InetSocketAddress insocket = (InetSocketAddress) ctx.channel().remoteAddress();
        String clientIP = insocket.getAddress().getHostAddress();
        String clientPort = String.valueOf(insocket.getPort());
        log.debug("收到来自{}：{}的请求，成功创建Channel[{}],->>[{}]", clientIP, clientPort, ctx.channel().id(),channel.id());
        super.channelActive(ctx);
    }


    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        InetSocketAddress insocket = (InetSocketAddress) ctx.channel().remoteAddress();
        String clientIP = insocket.getAddress().getHostAddress();
        String clientPort = String.valueOf(insocket.getPort());
        log.info("client inactive times :" + ChannelCounter.clientReadTimes.addAndGet(1));
        log.debug("关闭来自{}：{}的请求，成功回收Channel[{}]",clientIP, clientPort, ctx.channel().id());
        super.channelInactive(ctx);
    }

    /**
     * 异常处理逻辑， 当客户端异常退出的时候，也会运行。
     * ChannelHandlerContext关闭，也代表当前与客户端连接的资源关闭。
     */
    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
//        channel.closeFuture().sync();
        ctx.close();
        log.error("channel close",cause);
    }
}

