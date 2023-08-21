package com.mix.handler;

import io.netty.channel.ChannelDuplexHandler;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.timeout.IdleStateEvent;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by reeves on 2023/8/21.
 */
@Slf4j
public class IdleEventHandler extends ChannelDuplexHandler {

    @Override
    public void userEventTriggered(ChannelHandlerContext ctx, Object evt) throws Exception {
        if (evt instanceof IdleStateEvent) {
            evt = (IdleStateEvent) evt;

            // 若检测到长时间未读到请求事件，则清理客户端连接
            if (evt.equals(IdleStateEvent.READER_IDLE_STATE_EVENT)) {
                log.info("IdleEventHandler kill [{}]",ctx.channel().id());
                ctx.channel().close();
            }
        }
    }

}
