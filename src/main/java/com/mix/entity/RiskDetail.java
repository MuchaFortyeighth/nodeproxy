package com.mix.entity;

import lombok.Data;

@Data
public class RiskDetail {
    private boolean dangers;
    private String riskName; // 风险名称
    private String riskDescription; // 风险描述

    public RiskDetail(boolean dangers,String riskName, String riskDescription) {
        this.dangers = dangers;
        this.riskName = riskName;
        this.riskDescription = riskDescription;
    }
}