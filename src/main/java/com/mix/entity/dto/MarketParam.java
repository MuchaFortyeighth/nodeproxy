package com.mix.entity.dto;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("market_parameters")
public class MarketParam {
    @TableId
    private String contractAddress;
    private long transactionTime;
    private double annualizedRate;
    private long poolBalance;
    private int marketVolatility;
    private double slippage;
}
