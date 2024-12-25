package com.mix.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AgentTransactionResponse {
    // 用户地址
    private String fromAddress;

    // 钱包余额
    private Double balance;

    private String toAddress;

    // 交易金额
    private Double transAmount;

    private String token;

    // 交易哈希
    private String txHash;

    // 交易时间
    private LocalDateTime time;
}
