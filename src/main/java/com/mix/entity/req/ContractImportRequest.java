package com.mix.entity.req;

import lombok.Data;

@Data
public class ContractImportRequest {
    private String sourceCode;           // 合约源代码
    private String compilerVersion;      // 编译器版本
    private String contractName;         // 合约名称
    private String contractAddress;      // 合约地址
    private String primaryCategory;      // 一级分类
    private String secondaryCategory;    // 二级分类
} 