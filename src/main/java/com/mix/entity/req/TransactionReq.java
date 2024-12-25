package com.mix.entity.req;

import com.mix.entity.TransactionType;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class TransactionReq {
    private String walletAddress;  // 钱包地址
    private String tokenContractAddressHash;  // Token 合约地址
    private long timestamp;  // 时间戳（秒）
    private BigDecimal amount; // 交易金额
    private TransactionType transactionType; // 交易类型
}
