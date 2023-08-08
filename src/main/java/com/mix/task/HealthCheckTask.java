package com.mix.task;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.mix.entity.NodeInfo;
import com.mix.proxy.ChannelRegistry;
import com.mix.proxy.ProxyServer;
import com.mix.service.RpcService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.*;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;


/**
 * Created by reeves on 2023/7/19.
 */
@Slf4j
@Component
public class HealthCheckTask {

    @Autowired
    ChannelRegistry channelRegistry;

    @Autowired
    RpcService rpcService;

    @Value("${proxy.config.path}")
    String configFilePath;

    private static Integer BLOCK_DELAY_LIMIT = 5; //最大允许延迟块高，如果出现了比当前绑定节点高5个以上的 再做切换,作用是缓冲区，防止频繁切换节点

    @Scheduled(fixedDelay = 30000, initialDelay = 1000)
    void checkAndUpdateProxy() throws InterruptedException {
//        log.info("-------------start checkAndUpdateProxy------------");
        JSONArray config;
        try {
            configFilePath = URLDecoder.decode(configFilePath, "UTF-8");
            File configFile = new File(configFilePath);
            FileReader fileReader = new FileReader(configFile);
            Reader reader = new InputStreamReader(new FileInputStream(configFile),"utf-8");
            int ch = 0;
            StringBuffer sb = new StringBuffer();
            while ((ch = reader.read()) != -1) {
                sb.append((char) ch);
            }
            fileReader.close();
            reader.close();
            config = JSONObject.parseArray(sb.toString());
            HashSet<String> networks = new HashSet<>();
            HashSet<Integer> serverPorts = new HashSet<>();
            config.parallelStream().forEach(o -> {
                JSONObject nodeJson = (JSONObject)o;
                NodeInfo nodeInfo = nodeJson.toJavaObject(NodeInfo.class);
                channelRegistry.getAllnodeInfoRegistry().put(nodeInfo.getNetwork(),nodeInfo);
                serverPorts.add(nodeInfo.getServerPort());
                networks.add(nodeInfo.getNetwork());
                bindPort(nodeInfo);
            });
            //del
            for (String network : channelRegistry.getAllnodeInfoRegistry().keySet()) {
                if (!networks.contains(network)){
                    channelRegistry.getAllnodeInfoRegistry().remove(network);
                }
            }
            for (Integer port : channelRegistry.getAllRegistry().keySet()) {
                if (!serverPorts.contains(port)){
                    ProxyServer proxyServer = channelRegistry.getAllRegistry().get(port);
                    proxyServer.getCurrentChannel().channel().close();
                    proxyServer.getCurrentChannel().channel().closeFuture().sync();
                    channelRegistry.getAllRegistry().remove(port);
                }
            }
        } catch (UnsupportedEncodingException e) {
            log.error("bad config path",e);
        } catch (FileNotFoundException e) {
            log.error("config not found",e);
        } catch (IOException e) {
            log.error("read config error",e);
        } catch (Exception e ){
            log.error("error",e);
        }
    }

    private void bindPort(NodeInfo nodeInfo){
        List<String> remoteHosts = nodeInfo.getRemoteHosts();
        if (remoteHosts.size() == 0){return;}
        String bestHost = remoteHosts.get(0);
        Integer bestHeight = 0;
        HashMap<String, Integer> heightMap = new HashMap<>(remoteHosts.size());
        for (String remoteHost : remoteHosts) {//查出每个节点的当前块高
            Integer height = rpcService.getNodeBlockHeight(remoteHost,nodeInfo.getNetworkType());
            if (height > bestHeight){
                bestHost = remoteHost;
                bestHeight = height;
            }
            heightMap.put(remoteHost,height);
        }
        ConcurrentHashMap<Integer, ProxyServer> allRegistry = channelRegistry.getAllRegistry();
        ProxyServer proxyServer = allRegistry.get(nodeInfo.getServerPort());
        if(proxyServer != null){//not first bind
            String bindingHost = proxyServer.getRemoteaddr()+":"+proxyServer.getRemotePort();
            if(heightMap.get(bindingHost) != null){
                if(bindingHost.equals(bestHost) || (bestHeight - heightMap.get(bindingHost)) <= BLOCK_DELAY_LIMIT){
                    //当前绑定的就是最优节点
                    //或当前绑定节点只延迟了少量块高
                    //这两种情况 不做切换
                    return;
                }
            }
        }
        String[] host = bestHost.split(":");
        String remoteaddr = host[0];
        String remotePort = host[1];
        try {
            channelRegistry.insertOrUpdateRemote(nodeInfo.getServerPort(),remoteaddr,Integer.valueOf(remotePort),nodeInfo.getNetwork());
        } catch (InterruptedException e) {
            log.error("bindPort error:" + nodeInfo.toString(),e);
        }
    }

}
