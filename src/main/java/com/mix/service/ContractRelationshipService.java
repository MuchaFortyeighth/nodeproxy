package com.mix.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.mix.entity.dto.ContractRelationship;
import com.mix.mapper.ContractRelationshipsMapper;
import com.mix.mapper.DefiContractMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ContractRelationshipService {

    @Autowired
    private ContractRelationshipsMapper contractRelationshipsMapper;

    @Autowired
    private DefiContractMapper defiContractMapper;

    /**
     * 添加风险关联
     */
    public void addRelationship(String sourceContract, String targetContract, String token) {
        ContractRelationship relationship = new ContractRelationship();
        relationship.setSourceContractAddress(sourceContract);
        relationship.setTargetContractAddress(targetContract);
        relationship.setToken(token);
        int rows = contractRelationshipsMapper.insert(relationship);
        if (rows == 0) {
            throw new RuntimeException("Failed to add relationship.");
        }
    }

    /**
     * 查询某个合约的所有风险关联
     */
    public Map<String,List<ContractRelationship>> getRelationships(String sourceContract) {
        HashMap<String, List<ContractRelationship>> result = new HashMap<>();
        List<ContractRelationship> contractRelationships = contractRelationshipsMapper.getContractRelationships(sourceContract);
        for (ContractRelationship contractRelationship : contractRelationships) {
            contractRelationship.setSourceContractName(defiContractMapper.getNameByAddress(
                    contractRelationship.getSourceContractAddress()
            ));
            contractRelationship.setTargetContractName(defiContractMapper.getNameByAddress(
                    contractRelationship.getTargetContractAddress()
            ));
        }
        List<ContractRelationship> contractPassiveRelationships = contractRelationshipsMapper.getContractPassiveRelationships(sourceContract);
        for (ContractRelationship contractRelationship : contractPassiveRelationships) {
            contractRelationship.setSourceContractName(defiContractMapper.getNameByAddress(
                    contractRelationship.getSourceContractAddress()
            ));
            contractRelationship.setTargetContractName(defiContractMapper.getNameByAddress(
                    contractRelationship.getTargetContractAddress()
            ));
        }
        result.put("relatedTo",contractRelationships);
        result.put("relatedBy",contractPassiveRelationships);
        return result;
    }

    /**
     * 删除风险关联
     */
    public void deleteRelationship(String sourceContract, String targetContract, String token) {
        QueryWrapper<ContractRelationship> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("source_contract_address", sourceContract)
                .eq("target_contract_address", targetContract)
                .eq("token", token);
        int rows = contractRelationshipsMapper.delete(queryWrapper);
        if (rows == 0) {
            throw new RuntimeException("Failed to delete relationship: No matching record found.");
        }
    }
}

