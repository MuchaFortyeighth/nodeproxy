package com.mix.entity;

import lombok.Data;

import java.util.List;

/**
 * Created by reeves on 2023/7/15.
 */
@Data
public class NodeInfo {
    private String network;
    private String networkType;
    private Integer serverPort;
    private List<String> remoteHosts;
}
