package com.mix.service;

import com.alibaba.fastjson.JSONObject;
import com.mix.proxy.ChannelRegistry;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by reeves on 2023/7/19.
 */
@Slf4j
@Service
public class RpcService {

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    ChannelRegistry registry;

    public Integer getNodeBlockHeight(String remoteHost,String networkType){
        int retryTime = registry.getBadHostRetry().get(remoteHost)==null?0:registry.getBadHostRetry().get(remoteHost);
        if (retryTime >=2 ){
            return 0;
        }
        int height = 0;
        if ("ETH".equals(networkType)){
            height = ethBlockNumber(remoteHost);
        } else if ("BTC".equals(networkType)){
            height = getblockcount(remoteHost);
        } else if ("TRX".equals(networkType)){
            height = walletGetnowblock(remoteHost);
        }else if ("BEACON".equals(networkType)){
            height = beaconHeader(remoteHost);
        } else {
            log.error("!!!! unsupport networkType !!!!",networkType);
        }
        if (height == 0){
            registry.getBadHostRetry().put(remoteHost,retryTime+1);
        }
        return height;
    }

    private Integer ethBlockNumber(String remoteHost){
        HashMap<String, Object> param = new HashMap<>();
        param.put("method","eth_blockNumber");
        param.put("params",new ArrayList<>());
        param.put("id",1);
        param.put("jsonrpc","2.0");
        String url = "http://" + remoteHost;
        try{
            String result = restTemplate.postForObject(url, param, String.class);
            JSONObject jsonrst = JSONObject.parseObject(result);
            String hex = jsonrst.getString("result").replace("0x","");
            return Integer.parseInt(hex,16);
        }catch (Exception e){
            log.error("ethBlockNumber error,url = {}|{}", url, e.getMessage());
            return 0;
        }
    }

    private Integer getblockcount(String remoteHost){
        HashMap<String, Object> param = new HashMap<>();
        param.put("method","getblockcount");
        param.put("params",new ArrayList<>());
        param.put("id",1);
        param.put("jsonrpc","2.0");
        String url = "http://" + remoteHost;
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization","Basic bWl4bWluaW5nOm1peE1pbmluZzE=");
        HttpEntity httpEntity = new HttpEntity<>(param, headers);
        try{
            String result = restTemplate.postForObject(url, httpEntity, String.class);
            JSONObject jsonrst = JSONObject.parseObject(result);
            String hex = jsonrst.getString("result").replace("0x","");
            return Integer.parseInt(hex,10);
        }catch (Exception e){
            log.error("getblockcount error,url = "+ url + "|" + e.getMessage());
            return 0;
        }
    }

    private Integer walletGetnowblock(String remoteHost){
        String url = "http://" + remoteHost + "/wallet/getnowblock";
        HashMap<String, Object> param = new HashMap<>();
        HttpHeaders headers = new HttpHeaders();
        headers.add("accept","application/json");
        HttpEntity httpEntity = new HttpEntity<>(param, headers);
        try{
            String result = restTemplate.postForObject(url, httpEntity, String.class);
            JSONObject jsonrst = JSONObject.parseObject(result);
            String hex = jsonrst.getJSONObject("block_header").getJSONObject("raw_data").getString("number").replace("0x","");
            return Integer.parseInt(hex,10);
        }catch (Exception e){
            log.error("walletGetnowblock error,url = "+ url + "|" + e.getMessage());
            return 0;
        }
    }

    private Integer beaconHeader(String remoteHost){
        String url = "http://" + remoteHost + "/eth/v1/beacon/headers";
        try{
            String result = restTemplate.getForObject(url, String.class);
            JSONObject jsonrst = JSONObject.parseObject(result);
            String hex = jsonrst.getJSONArray("data").getJSONObject(0).getJSONObject("header").getJSONObject("message").getString("slot");
            return Integer.parseInt(hex,10);
        }catch (Exception e){
            log.error("walletGetnowblock error,url = {}|{}", url, e.getMessage());
            return 0;
        }
    }

    public JSONObject diskUsage(String remoteHost){
        String url = "http://" + remoteHost.split(":")[0] + ":9001/disk-usage";
        try{
            String result = restTemplate.getForObject(url, String.class);
            return JSONObject.parseObject(result);

        }catch (Exception e){
            log.error("diskUsage error,url = {}|{}", url, e.getMessage());
            return new JSONObject();
        }
    }
}
