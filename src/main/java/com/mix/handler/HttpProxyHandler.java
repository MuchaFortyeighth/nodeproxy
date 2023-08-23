package com.mix.handler;

import io.netty.bootstrap.Bootstrap;
import io.netty.buffer.Unpooled;
import io.netty.channel.*;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioSocketChannel;
import io.netty.handler.codec.http.*;
import io.netty.util.CharsetUtil;
import io.netty.util.ReferenceCountUtil;
import io.netty.util.internal.StringUtil;

/**
 * Created by reeves on 2023/8/23.
 */
public class HttpProxyHandler extends SimpleChannelInboundHandler<FullHttpRequest> {

    private final String remoteHost;
    private final int remotePort;

    public HttpProxyHandler(String remoteHost, int remotePort) {
        this.remoteHost = remoteHost;
        this.remotePort = remotePort;
    }

    @Override
    protected void channelRead0(ChannelHandlerContext ctx, FullHttpRequest request) throws Exception {

        //修改目标地址
        request.headers().set(HttpHeaderNames.HOST, remoteHost);

        ReferenceCountUtil.retain(request);

        //创建客户端连接目标机器
        connectToRemote(ctx, remoteHost, remotePort, 1000).addListener(new ChannelFutureListener() {
            @Override
            public void operationComplete(ChannelFuture channelFuture) throws Exception {
                if (channelFuture.isSuccess()) {
                    //代理服务器连接目标服务器成功
                    //发送消息到目标服务器
                    //关闭长连接
                    request.headers().set(HttpHeaderNames.CONNECTION, "close");

                    //转发请求到目标服务器
                    channelFuture.channel().writeAndFlush(request).addListener(new ChannelFutureListener() {
                        @Override
                        public void operationComplete(ChannelFuture channelFuture) throws Exception {
                            if (channelFuture.isSuccess()) {
                                //移除客户端的http编译码器
                                channelFuture.channel().pipeline().remove("HTTP_CLIENT_CODEC");
                                //移除代理服务和请求端 通道之间的http编译码器和集合器
                                ctx.channel().pipeline().remove("HTTP_CODEC");
                                ctx.channel().pipeline().remove("HTTP_AGGREGATOR");
                                //移除后，让通道直接直接变成单纯的ByteBuf传输
                            }
                        }
                    });
                } else {
                    ReferenceCountUtil.retain(request);
                    ctx.writeAndFlush(getResponse(HttpResponseStatus.BAD_REQUEST, "代理服务连接远程服务失败"))
                            .addListener(ChannelFutureListener.CLOSE);
                }
            }
        });
    }

    private DefaultFullHttpResponse getResponse(HttpResponseStatus statusCode, String message) {
        return new DefaultFullHttpResponse(HttpVersion.HTTP_1_1, statusCode, Unpooled.copiedBuffer(message, CharsetUtil.UTF_8));
    }

    private ChannelFuture connectToRemote(ChannelHandlerContext ctx, String targetHost, int targetPort, int timeout) {
        return new Bootstrap().group(ctx.channel().eventLoop())
                .channel(NioSocketChannel.class)
                .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, timeout)
                .handler(new ChannelInitializer<SocketChannel>() {
                    @Override
                    protected void initChannel(SocketChannel socketChannel) throws Exception {
                        ChannelPipeline pipeline = socketChannel.pipeline();
                        //增加http编码器
                        pipeline.addLast("HTTP_CLIENT_CODEC", new HttpClientCodec());
                        //增加一个传输数据的通道
                        pipeline.addLast(new DataTransHandler(ctx.channel()));
                    }
                })
                .connect(targetHost, targetPort);
    }
}

