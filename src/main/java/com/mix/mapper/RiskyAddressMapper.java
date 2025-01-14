package com.mix.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mix.entity.dto.RiskyAddressSummary;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface RiskyAddressMapper extends BaseMapper<RiskyAddressSummary> {

    @Select("WITH block_height AS (\n" +
            "    SELECT MAX(number) - 500 as safe_block_number\n" +
            "    FROM blocks b\n" +
            "    WHERE number IS NOT NULL\n" +
            "),\n" +
            "recent_txs AS (\n" +
            "    SELECT t.from_address_hash, t.value\n" +
            "    FROM transactions t, block_height lt\n" +
            "    WHERE t.to_address_hash = decode(#{contractAddress}, 'hex')\n" +
            "      AND t.block_number IS NOT NULL\n" +
            "      AND t.block_number >= (SELECT safe_block_number - 300000 FROM block_height)\n" +
            "    ORDER BY t.block_number DESC, t.index DESC\n" +
            "    LIMIT 300000\n" +
            ")\n" +
            "SELECT\n" +
            "    '0x' || encode(t.from_address_hash, 'hex') AS address,\n" +
            "    COUNT(*) AS transaction_count,\n" +
            "    SUM(t.value) / 1e18 AS total_amount_eth,\n" +
            "    (COUNT(*) * 0.6 + SUM(t.value) / 1e18 * 0.4) AS risk_score\n" +
            "FROM recent_txs t\n" +
            "GROUP BY t.from_address_hash\n" +
            "ORDER BY risk_score DESC\n" +
            "LIMIT 10")
    List<RiskyAddressSummary> getRiskyAddresses(@Param("contractAddress") String contractAddress);
}

