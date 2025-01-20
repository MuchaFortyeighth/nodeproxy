package com.mix.entity.dto;

import lombok.Data;

@Data
public class RiskyAddressSummary {
    private String address;            // 风险交易地址
    private Long transactionCount;     // 交易对应token的次数
    private Double totalAmountToken;     // 总交易金额
    private Double riskScore;          // 风险评分
}
