package com.mix.entity.dto;

import lombok.Data;

@Data
public class RiskyAddressSummary {
    private String address;            // 风险交易地址
    private Long transactionCount;     // 与合约交互的交易次数
    private Double totalAmountEth;     // 总交易金额（ETH）
    private Double riskScore;          // 风险评分
}
