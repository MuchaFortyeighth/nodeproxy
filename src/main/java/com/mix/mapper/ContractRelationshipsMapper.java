package com.mix.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mix.entity.dto.ContractRelationship;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ContractRelationshipsMapper extends BaseMapper<ContractRelationship> {

    /**
     * 查询某个合约的所有风险关联
     */
    @Select("SELECT * " +
            "FROM contract_relationships " +
            "WHERE source_contract_address = #{sourceContractAddress}")
    List<ContractRelationship> getContractRelationships(@Param("sourceContractAddress") String sourceContractAddress);

    /**
     * 查询某个合约的所有风险被关联
     */
    @Select("SELECT * " +
            "FROM contract_relationships " +
            "WHERE target_contract_address = #{targetContractAddress}")
    List<ContractRelationship> getContractPassiveRelationships(@Param("targetContractAddress") String targetContractAddress);
}
