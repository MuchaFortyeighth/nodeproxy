package com.mix.proxy;

import com.mix.entity.NodeInfo;
import io.netty.channel.ChannelFuture;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.concurrent.ConcurrentHashMap;

/**
 * Created by reeves on 2023/7/19.
 * 端口代理的注册表
 */
@Slf4j
@Component
public class ChannelRegistry {
    private static ConcurrentHashMap<Integer, ProxyServer> portRegistry = new ConcurrentHashMap<>();
    private static ConcurrentHashMap<String, NodeInfo> nodeInfoRegistry = new ConcurrentHashMap<>();
    private static ConcurrentHashMap<String, Integer> badHostRetry =  new ConcurrentHashMap<>();

    public ConcurrentHashMap<Integer, ProxyServer> getAllRegistry(){
        return portRegistry;
    }
    public ConcurrentHashMap<String, NodeInfo> getAllnodeInfoRegistry(){return nodeInfoRegistry;}
    public ConcurrentHashMap<String, Integer> getBadHostRetry(){return badHostRetry;}

    public void insertOrUpdateRemote(int serverPort,String remoteaddr,int remotePort,String network) throws InterruptedException {
        ProxyServer proxyServer = portRegistry.get(serverPort);
        if (proxyServer == null){
            proxyServer = new ProxyServer(serverPort,remoteaddr,remotePort,network);
            bind(proxyServer);
        } else {
           proxyServer.getCurrentChannel().channel().close();
           proxyServer.getCurrentChannel().channel().closeFuture().sync();
           proxyServer.setRemoteaddr(remoteaddr);
           proxyServer.setRemotePort(remotePort);
           bind(proxyServer);
        }
    }

    private void bind(ProxyServer proxyServer) throws InterruptedException {
        ChannelFuture init = proxyServer.init();
        init.sync();
        portRegistry.put(proxyServer.getServerPort(),proxyServer);
    }
}
