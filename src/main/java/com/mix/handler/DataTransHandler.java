package com.mix.handler;

import io.netty.buffer.PooledByteBufAllocator;
import io.netty.channel.Channel;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.util.ReferenceCountUtil;

/**
 * Created by reeves on 2023/8/23.
 */
public class DataTransHandler extends ChannelInboundHandlerAdapter {

    private Channel channel;

    public DataTransHandler(Channel channel) {
        this.channel = channel;
    }

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
        if (!channel.isOpen()) {
            ReferenceCountUtil.release(msg);
            return;
        }
        channel.writeAndFlush(msg);
    }

    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        //目标服务器和代理服务器断开连接
        //代理服务器和原始服务器也断开连接
        if (channel != null) {
            //发送一个空的buf,通过listener监听的方式，关闭channel，确保通道中的数据传输完毕
            channel.writeAndFlush(PooledByteBufAllocator.DEFAULT.buffer()).addListener(ChannelFutureListener.CLOSE);
        }
        super.channelInactive(ctx);
    }
}

