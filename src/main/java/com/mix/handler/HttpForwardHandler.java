package com.mix.handler;

import io.netty.bootstrap.Bootstrap;
import io.netty.buffer.ByteBuf;
import io.netty.channel.*;
import io.netty.channel.socket.SocketChannel;
import io.netty.handler.codec.http.FullHttpRequest;
import io.netty.handler.codec.http.HttpClientCodec;
import io.netty.handler.codec.http.HttpObjectAggregator;
import io.netty.util.CharsetUtil;

/**
 * Created by reeves on 2023/8/23.
 */
public class HttpForwardHandler extends ChannelInboundHandlerAdapter {
    private final String remoteHost;
    private final int remotePort;

    public HttpForwardHandler(String remoteHost, int remotePort) {
        this.remoteHost = remoteHost;
        this.remotePort = remotePort;
    }

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
        // 获取读取的数据， 是一个缓冲。
        ByteBuf readBuffer = (ByteBuf) msg;
        String msgStr = readBuffer.toString(CharsetUtil.UTF_8);

//        log.info("server read times :" + ChannelCounter.serverReadTimes.addAndGet(1));
        //缓冲区复位
        readBuffer.retain();
        readBuffer.release();

        // 创建与目标服务器的连接
        Bootstrap bootstrap = new Bootstrap();
        int maxContentLength = 10485760;
        bootstrap.group(ctx.channel().eventLoop())
                .channel(ctx.channel().getClass())
                .handler(new ChannelInitializer<SocketChannel>() {
                    @Override
                    protected void initChannel(SocketChannel ch) throws Exception {
                        ChannelPipeline pipeline = ch.pipeline();
//                        pipeline.addLast(new HttpClientCodec(4096, 8192, maxContentLength));
                        pipeline.addLast(new HttpObjectAggregator(maxContentLength));
                        pipeline.addLast(new ForwardResponseHandler(ctx.channel()));
                        pipeline.addLast("responseAggregator", new HttpObjectAggregator(maxContentLength));
                    }
                });

        ChannelFuture future = bootstrap.connect(remoteHost, remotePort).sync();
        Channel remoteChannel = future.channel();

        // 将请求发送给目标服务器
        remoteChannel.writeAndFlush(readBuffer);

        // 关闭与目标服务器的连接
        remoteChannel.closeFuture().addListener((ChannelFutureListener) future1 -> ctx.channel().close());

    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        cause.printStackTrace();
        ctx.close();
    }
}
