package com.mix.entity.dto;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("wallet_token_balance")
public class WalletTokenBalance {
    @TableId(type = IdType.AUTO)
    private Integer id;
    private String contractAddress;
    private BigDecimal balance;
    private LocalDateTime timestamp;
} 