package com.mix.handler;

import io.netty.buffer.ByteBuf;
import io.netty.channel.Channel;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.handler.codec.http.DefaultHttpHeaders;
import io.netty.handler.codec.http.FullHttpResponse;
import io.netty.util.CharsetUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by reeves on 2023/8/23.
 */
@Slf4j
public class ForwardResponseHandler extends ChannelInboundHandlerAdapter {
    private final Channel clientChannel;

    public ForwardResponseHandler(Channel clientChannel) {
        this.clientChannel = clientChannel;
    }

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
        if (msg instanceof FullHttpResponse) {
            FullHttpResponse response = (FullHttpResponse) msg;
            DefaultHttpHeaders headers = (DefaultHttpHeaders) response.headers();
//            headers.add("Transfer-Encoding","chunked");
            // 将目标服务器的响应发送给原始客户端
            if (clientChannel.isActive() && clientChannel.isWritable()) {
                ChannelFuture cf = clientChannel.writeAndFlush(response);
                if (cf.isDone() && cf.cause() != null) {
                    log.error("channelWrite error!", cf.cause());
                    ctx.close();
                }
            }
        }

    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        cause.printStackTrace();
        ctx.close();
    }
}
