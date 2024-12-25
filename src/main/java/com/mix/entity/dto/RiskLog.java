package com.mix.entity.dto;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("risk_log")
public class RiskLog {
    private LocalDateTime logTime;
    private String contractAddress;
    private String contractName;
    private String riskName;
}
