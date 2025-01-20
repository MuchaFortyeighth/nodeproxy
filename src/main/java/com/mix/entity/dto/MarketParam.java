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
    private int collateralVolatility;    // 抵押资产波动
    private int debtVolatility;          // 借贷资产波动
    private double slippage;
}
