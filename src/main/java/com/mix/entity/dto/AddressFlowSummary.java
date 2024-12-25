package com.mix.entity.dto;

import lombok.Data;

@Data
public class AddressFlowSummary {
    private String sender;              // 发送方地址
    private String recipient;           // 接收方地址
    private Long transactionCount;      // 交易次数
    private Double totalAmountEth;      // 总金额（单位 ETH）
    private String isContractAddress;   // 是否为合约地址
}

