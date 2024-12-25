package com.mix.entity.dto;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@TableName("contract_relationships") // 显式指定表名
public class ContractRelationship {

    @TableId
    private Integer id;

    private String sourceContractAddress; // 发起关联的合约地址

    private String sourceContractName; // 发起关联的合约地址

    private String targetContractAddress; // 被关联的合约地址

    private String targetContractName; // 被关联的合约地址

    private String token; // 关联的代币（如 USDT、sETH）

    private String createdAt; // 记录创建时间
}

