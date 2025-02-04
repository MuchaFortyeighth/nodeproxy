package com.mix.entity.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class TokenTransferDTO {
    private String tokensymbol;
    private BigDecimal amount;
    private LocalDateTime transfertime;
    private String toaddress;
    private String datasource;
    private Long blocknumber;
    private String transactionhash;
    private String fromaddress;
} 