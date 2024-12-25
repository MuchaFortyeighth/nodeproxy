package com.mix.entity;

import lombok.Getter;

@Getter
public enum RiskLevel {
    LOW("风险较低，市场表现稳定，适合参与投资。"),
    MEDIUM("风险中等，市场略有波动，请注意监控。"),
    HIGH("风险较高，市场存在明显问题，需要谨慎投资。"),
    CRITICAL("风险极高，市场存在严重问题，建议暂停投资。");

    private final String description;

    RiskLevel(String description) {
        this.description = description;
    }

}

