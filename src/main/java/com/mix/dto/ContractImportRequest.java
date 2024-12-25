package com.mix.dto;

import lombok.Data;

@Data
public class ContractImportRequest {
    private String sourceCode;           // 合约源代码
    private String compilerVersion;      // 编译器版本
    private String contractName;         // 合约名称
    private String contractAddress;      // 合约地址
} 