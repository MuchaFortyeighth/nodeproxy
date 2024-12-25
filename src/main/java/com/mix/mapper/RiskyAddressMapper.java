package com.mix.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mix.entity.dto.RiskyAddressSummary;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface RiskyAddressMapper extends BaseMapper<RiskyAddressSummary> {

    @Select("SELECT\n" +
            "    '0x' || encode(t.from_address_hash, 'hex') AS address,\n" +
            "    COUNT(*) AS transaction_count,\n" +
            "    SUM(t.value) / 1e18 AS total_amount_eth,\n" +
            "    -- 风险评分逻辑：基于交易次数、金额等\n" +
            "    (COUNT(*) * 0.6 + SUM(t.value) / 1e18 * 0.4) AS risk_score\n" +
            "FROM\n" +
            "    transactions t\n" +
            "WHERE\n" +
            "    t.to_address_hash = decode(#{contractAddress}, 'hex')\n" +
            "GROUP BY\n" +
            "    t.from_address_hash\n" +
            "ORDER BY\n" +
            "    risk_score DESC\n" +
            "LIMIT 10;")
    List<RiskyAddressSummary> getRiskyAddresses(@Param("contractAddress") String contractAddress);
}

