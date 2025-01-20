package com.mix.entity.dto;

import lombok.Data;

@Data
public class AddressFlowSummary {
    private String sender;              // 发送方地址
    private String recipient;           // 接收方地址
    private Long transactionCount;      // 交易次数
    private Double totalAmountToken;    // 总代币金额
    private String isContractAddress;   // 是否为合约地址
    private String tokenSymbol;         // 代币符号
    private String tokenAddress;        // 代币合约地址
}

