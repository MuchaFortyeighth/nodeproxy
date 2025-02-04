package com.mix.entity.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class WalletValuePoint {
    private LocalDateTime timestamp;
    private BigDecimal valueUSD;
} 