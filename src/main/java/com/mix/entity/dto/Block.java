package com.mix.entity.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
public class Block {
    private byte[] hash;
    private boolean consensus;
    private BigDecimal difficulty;
    private BigDecimal gasLimit;
    private BigDecimal gasUsed;
    private byte[] minerHash;
    private byte[] nonce;
    private Long number;
    private byte[] parentHash;
    private Integer size;
    private Timestamp timestamp;
    private BigDecimal totalDifficulty;
    private Timestamp insertedAt;
    private Timestamp updatedAt;
    private boolean refetchNeeded;
    private BigDecimal baseFeePerGas;
    private Boolean isEmpty;
}
