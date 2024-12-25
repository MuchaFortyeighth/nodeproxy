package com.mix.entity;

import lombok.Getter;

@Getter
public enum RiskType {
    LIQUIDITY_LOW("流动性不足", "可能导致市场无法满足大额交易需求。"),
    LIQUIDITY_GOOD("流动性充足", "可以满足大额交易需求。"),

    MARKET_VOLATILITY_HIGH("市场动荡严重", "市场波动性较高，价格可能出现剧烈波动。"),
    MARKET_VOLATILITY_GOOD("市场波动性适中", "市场表现正常。"),
    MARKET_VOLATILITY_LOW("市场活跃度低", "市场波动性较低，可能缺乏交易机会。"),

    SLIPPAGE_HIGH("滑点过高", "可能导致交易成本显著增加。"),
    SLIPPAGE_LOW("滑点较低", "市场深度良好，适合大额交易。"),

    HIGH_YIELD("收益率过高", "可能吸引投机行为，存在风险隐患。"),
    LOW_YIELD("收益率过低", "市场吸引力不足，可能存在资本闲置。"),
    YIELD_GOOD("收益率适中", "市场表现稳定。");

    private final String name;
    private final String description;

    RiskType(String name, String description) {
        this.name = name;
        this.description = description;
    }

}

