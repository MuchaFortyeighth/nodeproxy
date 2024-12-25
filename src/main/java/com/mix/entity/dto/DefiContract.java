package com.mix.entity.dto;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("defi_contracts")
public class DefiContract {

    private String contractName;        // 合约名称

    private String contractAddress;     // 合约地址（以0x开头的42字符地址）

    private String primaryCategory;     // 一级分类

    private String secondaryCategory;   // 二级分类

    private String sourceCode;          // 合约源代码

    private String sourceCodeTree;      // 合约源码树

    private String sourceCodeScanResult; // 合约源码扫描结果
}
