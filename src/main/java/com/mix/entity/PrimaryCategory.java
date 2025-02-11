package com.mix.entity;

import lombok.Getter;

@Getter
public enum PrimaryCategory {
    TRADING("交易功能类"),
    INFRASTRUCTURE("基础设施类"),
    ASSET_MANAGEMENT("资产管理类"),
    FINANCIAL("金融功能类"),
    DERIVATIVES("衍生品");

    private final String category;

    PrimaryCategory(String category) {
        this.category = category;
    }

    @Override
    public String toString() {
        return this.category;
    }
}

