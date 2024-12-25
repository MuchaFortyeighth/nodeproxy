package com.mix.entity;


import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Data;
import org.apache.ibatis.type.EnumTypeHandler;

import java.util.List;

@Data
public class RiskAssessmentResult {
    @TableId
    private String contractAddress;
    @TableField(typeHandler = EnumTypeHandler.class)
    private RiskLevel riskLevel;
    private String description; // 总体风险描述
    @JsonSerialize
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private List<RiskDetail> details; // 每项指标的细项描述

    public RiskAssessmentResult(String contractAddress,RiskLevel riskLevel, String description, List<RiskDetail> details) {
        this.contractAddress = contractAddress;
        this.riskLevel = riskLevel;
        this.description = description;
        this.details = details;
    }


}

