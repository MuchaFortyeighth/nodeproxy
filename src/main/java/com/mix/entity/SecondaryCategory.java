package com.mix.entity;

import lombok.Getter;

@Getter
public enum SecondaryCategory {
    // 交易功能类
    TRADING_DECENTRALIZED_EXCHANGE("去中心化交易平台", PrimaryCategory.TRADING),
    TRADING_PAYMENT("支付", PrimaryCategory.TRADING),

    // 基础设施类
    INFRASTRUCTURE_SERVICE("服务", PrimaryCategory.INFRASTRUCTURE),
    INFRASTRUCTURE_CROSS_CHAIN("跨链", PrimaryCategory.INFRASTRUCTURE),
    INFRASTRUCTURE_PRIVACY_PROTECTION("隐私保护", PrimaryCategory.INFRASTRUCTURE),

    // 资产管理类
    ASSET_MANAGEMENT_SYNTHETIC_ASSETS("合成资产", PrimaryCategory.ASSET_MANAGEMENT),
    ASSET_MANAGEMENT_YIELD("收益率", PrimaryCategory.ASSET_MANAGEMENT),
    ASSET_MANAGEMENT_LEVERAGE_FARM("杠杆农场", PrimaryCategory.ASSET_MANAGEMENT),
    ASSET_MANAGEMENT_INDEX("索引", PrimaryCategory.ASSET_MANAGEMENT),

    // 金融功能类
    FINANCIAL_INSURANCE("保险", PrimaryCategory.FINANCIAL),
    FINANCIAL_LENDING("借贷", PrimaryCategory.FINANCIAL),
    FINANCIAL_YIELD("收益率", PrimaryCategory.FINANCIAL),
    FINANCIAL_LIQUIDITY_MINING("流动性挖矿", PrimaryCategory.FINANCIAL),
    FINANCIAL_STAKING_MINING("质押挖矿", PrimaryCategory.FINANCIAL),

    //衍生品
    DERIVATIVES_PERPETUAL_CONTRACTS("永续合约",PrimaryCategory.DERIVATIVES),
    DERIVATIVES_OPTIONS_CONTRACTS("期权合约",PrimaryCategory.DERIVATIVES),
    DERIVATIVES_FUTURES_CONTRACTS("期货合约",PrimaryCategory.DERIVATIVES),
    DERIVATIVES_RATE_CONTRACTS("利率衍生品",PrimaryCategory.DERIVATIVES);

    private final String category;
    private final PrimaryCategory primaryCategory;

    SecondaryCategory(String category, PrimaryCategory primaryCategory) {
        this.category = category;
        this.primaryCategory = primaryCategory;
    }

    @Override
    public String toString() {
        return this.category;
    }
}

