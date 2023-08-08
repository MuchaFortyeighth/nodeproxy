package com.mix.handler;


import io.netty.buffer.ByteBuf;
import io.netty.channel.*;
import io.netty.util.CharsetUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by reeves on 2023/7/18.
 */
@Slf4j
@ChannelHandler.Sharable
public class ChannelDataHandler extends ChannelInboundHandlerAdapter  {
    Channel channel;

    public ChannelDataHandler(Channel channel) {
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
        // log.info("get data: " + readBuffer.toString(CharsetUtil.UTF_8));
        //缓冲区复位
        readBuffer.retain();
        channel.writeAndFlush(readBuffer);
    }

    /**
     * 异常处理逻辑， 当客户端异常退出的时候，也会运行。
     * ChannelHandlerContext关闭，也代表当前与客户端连接的资源关闭。
     */
    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        channel.closeFuture().sync();
        ctx.close();
        log.error("channel close",cause);
    }
}

