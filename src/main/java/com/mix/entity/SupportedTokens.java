package com.mix.entity;

import lombok.Getter;

@Getter
public enum SupportedTokens {
    USDT("USDT", "Tether", "ERC20"),
    USDC("USDC", "USD Coin", "ERC20"),
    DAI("DAI", "Dai Stablecoin", "ERC20"),
    WETH("WETH", "Wrapped Ether", "ERC20"),
    WBTC("WBTC", "Wrapped Bitcoin", "ERC20"),
    SETH("sETH", "Staked Ether", "ERC20"),
    AAVE("AAVE", "AAVE Token", "ERC20"),
    COMP("COMP", "Compound Token", "ERC20"),
    UNI("UNI", "Uniswap Token", "ERC20"),
    CRV("CRV", "Curve DAO Token", "ERC20"),
    LINK("LINK", "Chainlink Token", "ERC20"),
    MATIC("MATIC", "Polygon Token", "ERC20"),
    LDO("LDO", "Lido DAO Token", "ERC20"),
    SUSHI("SUSHI", "SushiSwap Token", "ERC20"),
    YFI("YFI", "Yearn Finance Token", "ERC20");

    private final String symbol;       // Token 符号
    private final String name;         // Token 名称
    private final String type;         // Token 类型

    SupportedTokens(String symbol, String name, String type) {
        this.symbol = symbol;
        this.name = name;
        this.type = type;
    }

    public static SupportedTokens getBySymbol(String symbol) {
        for (SupportedTokens token : values()) {
            if (token.symbol.equalsIgnoreCase(symbol)) {
                return token;
            }
        }
        throw new IllegalArgumentException("Unsupported token: " + symbol);
    }
}

