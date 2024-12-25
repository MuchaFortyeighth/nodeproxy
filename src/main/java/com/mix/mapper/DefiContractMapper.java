package com.mix.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mix.entity.dto.DefiContract;
import com.mix.entity.dto.Vulnerability;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface DefiContractMapper extends BaseMapper<DefiContract> {

    @Select("SELECT source_code, source_code_tree, source_code_scan_result " +
            "FROM public.defi_contracts WHERE contract_address = #{contractAddress}")
    Vulnerability queryVulnerabilityDetails(@Param("contractAddress") String contractAddress);

    @Select("select contract_name  from defi_contracts where contract_address = #{contractAddress}")
    String getNameByAddress(@Param("contractAddress")String contractAddress);
}
