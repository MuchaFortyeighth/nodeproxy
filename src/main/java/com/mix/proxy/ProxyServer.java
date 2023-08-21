package com.mix.proxy;

import io.netty.bootstrap.Bootstrap;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.*;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.channel.socket.nio.NioSocketChannel;

import com.mix.handler.ChannelDataHandler;
import io.netty.util.concurrent.DefaultEventExecutor;
import io.netty.util.concurrent.DefaultEventExecutorGroup;
import io.netty.util.concurrent.EventExecutorGroup;
import lombok.extern.slf4j.Slf4j;


/**
 * Created by reeves on 2023/7/13.
 */
@Slf4j
public class ProxyServer implements Comparable<ProxyServer>{

    static final EventExecutorGroup executor = new DefaultEventExecutorGroup(64);

    private ServerBootstrap serverBootstrap;
    private Bootstrap bootstrap;
    private EventLoopGroup bossgroup;
    private EventLoopGroup workgroup;
    private int serverPort;              //占用端口
    private String remoteaddr;           //代理目标ip
    private int remotePort;              //代理目标port
    private ChannelFuture currentChannel;
    private String network;

    public ProxyServer(int serverPort,String remoteaddr,int remotePort,String network) {
        this.serverPort = serverPort;
        this.remoteaddr = remoteaddr;
        this.remotePort = remotePort;
        this.network = network;
    }

    public ChannelFuture init() {
        serverBootstrap = new ServerBootstrap();
        bootstrap = new Bootstrap();
        if (bossgroup == null){bossgroup = new NioEventLoopGroup(32);}
        if (workgroup == null){workgroup = new NioEventLoopGroup(32);}
        serverBootstrap.group(bossgroup, workgroup);
        serverBootstrap.channel(NioServerSocketChannel.class);
        bootstrap.channel(NioSocketChannel.class);
        bootstrap.group(bossgroup);
        //缓冲区设置
        serverBootstrap.option(ChannelOption.SO_BACKLOG, 1024);
        // SO_SNDBUF发送缓冲区，SO_RCVBUF接收缓冲区，SO_KEEPALIVE开启心跳监测（保证连接有效）
        serverBootstrap.option(ChannelOption.SO_SNDBUF, 16 * 1024)
                .option(ChannelOption.SO_RCVBUF, 16 * 1024)
                .option(ChannelOption.SO_KEEPALIVE, true);
        serverBootstrap.childHandler(new ChannelInitializer<SocketChannel>() {
            @Override
            protected void initChannel(final SocketChannel ch) throws Exception {
                bootstrap.handler(new ChannelInitializer<SocketChannel>() {
                    @Override
                    protected void initChannel(SocketChannel cliCh) throws Exception {
                        cliCh.pipeline().addLast(executor,new ChannelDataHandler(ch));
                    }
                });
                ChannelFuture sync = bootstrap.connect(remoteaddr, remotePort).sync();
                ch.pipeline().addLast(executor,new ChannelDataHandler(sync.channel()));
            }
        });
        ChannelFuture future = serverBootstrap.bind(serverPort);
        future.channel().closeFuture().addListener((ChannelFutureListener) channelFuture -> {
            log.info("channel close:" + channelFuture.channel());
//            bossgroup.shutdownGracefully();
//            workgroup.shutdownGracefully();
        });
        log.info("init proxy channel ->>" + future.channel().id() + "|" + serverPort+ "|" +remoteaddr+ "|" +remotePort);
        this.currentChannel = future;
        return future;
    }

    public int getServerPort() {
        return serverPort;
    }

    public void setServerPort(int serverPort) {
        this.serverPort = serverPort;
    }

    public String getRemoteaddr() {
        return remoteaddr;
    }

    public void setRemoteaddr(String remoteaddr) {
        this.remoteaddr = remoteaddr;
    }

    public int getRemotePort() {
        return remotePort;
    }

    public void setRemotePort(int remotePort) {
        this.remotePort = remotePort;
    }

    public ChannelFuture getCurrentChannel() {
        return currentChannel;
    }

    public void setCurrentChannel(ChannelFuture currentChannel) {
        this.currentChannel = currentChannel;
    }

    public String getNetwork() {
        return network;
    }

    public void setNetwork(String network) {
        this.network = network;
    }

    @Override
    public String toString() {
        return "{" +
                "serverPort=" + serverPort +
                ", remoteaddr='" + remoteaddr + '\'' +
                ", remotePort=" + remotePort +
                ", network=" + network +
                '}';
    }

    @Override
    public int compareTo(ProxyServer o) {
        int result1=this.getServerPort()-o.getServerPort();
        return result1;
    }
}
