package com.mix.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mix.entity.RiskAssessmentResult;
import org.apache.ibatis.annotations.*;

@Mapper
public interface RiskAssessmentResultMapper extends BaseMapper<RiskAssessmentResult> {

    /**
     * 插入或更新 RiskAssessmentResult。
     * 如果主键存在则更新，否则插入新记录。
     *
     * @param result RiskAssessmentResult 对象
     */
    @Update("<script>" +
            "INSERT INTO risk_assessment_result (contract_address, risk_level, description, details) " +
            "VALUES (#{result.contractAddress}, #{result.riskLevel}, #{result.description}, " +
            "#{result.details, typeHandler=com.mix.handler.JsonTypeHandler, jdbcType=OTHER}) " +
            "ON CONFLICT (contract_address) " +
            "DO UPDATE SET " +
            "risk_level = EXCLUDED.risk_level, " +
            "description = EXCLUDED.description, " +
            "details = EXCLUDED.details;" +
            "</script>")
    void saveOrUpdate(@Param("result") RiskAssessmentResult result);

    /**
     * 根据合约地址查询 RiskAssessmentResult
     * @param contractAddress 合约地址
     * @return RiskAssessmentResult 对象
     */
    @Select("SELECT contract_address, risk_level, description, details " +
            "FROM risk_assessment_result " +
            "WHERE contract_address = #{contractAddress}")
    @Results({
            @Result(column = "contract_address", property = "contractAddress"),
            @Result(column = "risk_level", property = "riskLevel"),
            @Result(column = "description", property = "description"),
            @Result(column = "details", property = "details", typeHandler = com.mix.handler.JsonTypeHandler.class)
    })
    RiskAssessmentResult findByContractAddress(String contractAddress);


}

