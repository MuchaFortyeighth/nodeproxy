package com.mix.controller;

import com.alibaba.fastjson.JSONObject;
import com.mix.entity.NodeInfo;
import com.mix.entity.Result;
import com.mix.proxy.ChannelRegistry;
import com.mix.proxy.ProxyServer;
import com.mix.service.RpcService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Created by reeves on 2023/7/15.
 */
@RestController
public class RegistryController {

    @Autowired
    ChannelRegistry registry;

    @Autowired
    RpcService rpcService;

    @GetMapping("/registry/all")
    public Result getAllproxy(){
        ConcurrentHashMap<Integer, ProxyServer> allRegistry = registry.getAllRegistry();
        ArrayList<ProxyServer> result = new ArrayList<>();
        for (Integer port : allRegistry.keySet()) {
            result.add(allRegistry.get(port));
        }
        Collections.sort(result);
        return Result.success(result);
    }

    @GetMapping("/registry/nodeinfos")
    public Result getAllNodeInfo(){
        ConcurrentHashMap<String, NodeInfo> allnodeInfoRegistry = registry.getAllnodeInfoRegistry();
        ArrayList<NodeInfo> result = new ArrayList<>();
        for (String network : allnodeInfoRegistry.keySet()) {
            result.add(allnodeInfoRegistry.get(network));
        }
        return Result.success(result);
    }

    @GetMapping(value = "/node/blocknumber/{host}/{type}")
    public Result query(@PathVariable(value = "host") String host,
                        @PathVariable(value = "type")String type) {
        Integer retryTime = registry.getBadHostRetry().get(host)==null?0:registry.getBadHostRetry().get(host);
        if (retryTime >0 ){
            registry.getBadHostRetry().put(host,1);
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("host",host);
        jsonObject.put("height",rpcService.getNodeBlockHeight(host,type));

        return Result.success(jsonObject);
    }
}
