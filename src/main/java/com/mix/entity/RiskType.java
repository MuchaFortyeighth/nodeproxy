package com.mix.entity;

import lombok.Getter;

@Getter
public enum RiskType {
    LIQUIDITY_LOW("流动性不足", "可能导致市场无法满足大额交易需求。"),
    LIQUIDITY_GOOD("流动性充足", "可以满足大额交易需求。"),

    ASSET_VOLATILITY_HIGH("资产波动过高", "市场波动性较高，存在较大风险。"),
    ASSET_VOLATILITY_GOOD("资产波动性正常", "市场表现稳定。"),

    SLIPPAGE_HIGH("滑点过高", "可能导致交易成本显著增加。"),
    SLIPPAGE_LOW("滑点较低", "市场深度良好，适合大额交易。");

    private final String name;
    private final String description;

    RiskType(String name, String description) {
        this.name = name;
        this.description = description;
    }

}

