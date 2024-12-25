package com.mix.entity.dto;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("simulated_token_transfers")
public class SimulatedTokenTransfer {
    private String fromAddressHash;
    private String toAddressHash;
    private String transactionHash;
    private Long blockNumber;
    private LocalDateTime timestamp;
    private BigDecimal amount;
    private String tokenContractAddressHash;
    private String datasource;
}
