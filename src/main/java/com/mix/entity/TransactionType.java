package com.mix.entity;

import lombok.Getter;

@Getter
public enum TransactionType {
    STAKE("质押"),
    COLLATERAL("抵押"),
    SWAP("交换"),
    WITHDRAW("提取"),
    DEPOSIT("存款");

    private final String description;

    TransactionType(String description) {
        this.description = description;
    }

}

