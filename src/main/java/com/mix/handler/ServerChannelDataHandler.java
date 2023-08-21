package com.mix.handler;


import io.netty.buffer.ByteBuf;
import io.netty.channel.*;
import io.netty.util.CharsetUtil;
import lombok.extern.slf4j.Slf4j;

import java.net.InetSocketAddress;

/**
 * Created by reeves on 2023/7/18.
 */
@Slf4j
//@ChannelHandler.Sharable
public class ServerChannelDataHandler extends ChannelInboundHandlerAdapter  {
    Channel channel;

    public ServerChannelDataHandler(Channel channel) {
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
//        log.info("get data: " + readBuffer.toString(CharsetUtil.UTF_8));
        //缓冲区复位
        readBuffer.retain();
        channel.writeAndFlush(readBuffer);
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
        log.debug("关闭来自{}：{}的请求，成功回收Channel[{}]",clientIP, clientPort, ctx.channel().id());
        channel.close();
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

