package com.mix.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mix.entity.dto.AddressFlowSummary;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface AddressFlowMapper extends BaseMapper<AddressFlowSummary> {

    // 流出查询
    @Select("WITH block_height AS (\n" +
            "    SELECT MAX(number) - 500 as safe_block_number\n" +
            "    FROM blocks b\n" +
            "    WHERE number IS NOT NULL\n" +
            "),\n" +
            "recent_txs AS (\n" +
            "    SELECT t.from_address_hash, t.to_address_hash, t.value\n" +
            "    FROM transactions t, block_height lt\n" +
            "    WHERE t.from_address_hash = decode(#{address}, 'hex')\n" +
            "      AND t.block_number IS NOT NULL\n" +
            "      AND t.block_number >= (SELECT safe_block_number - 100000 FROM block_height)\n" +
            "    ORDER BY t.block_number DESC, t.index DESC\n" +
            "    LIMIT 100000\n" +
            ")\n" +
            "SELECT\n" +
            "    '0x' || encode(t.from_address_hash, 'hex') AS sender,\n" +
            "    '0x' || encode(t.to_address_hash, 'hex') AS recipient,\n" +
            "    COUNT(*) AS transaction_count,\n" +
            "    SUM(t.value) / 1e18 AS total_amount_eth,\n" +
            "    CASE WHEN a.contract_code IS NULL THEN 'No' ELSE 'Yes' END AS is_contract_address\n" +
            "FROM recent_txs t\n" +
            "LEFT JOIN addresses a ON t.to_address_hash = a.hash\n" +
            "GROUP BY t.to_address_hash, t.from_address_hash, a.contract_code\n" +
            "ORDER BY transaction_count DESC\n" +
            "LIMIT 10")
    List<AddressFlowSummary> getOutflow(@Param("address") String address);

    // 流入查询
    @Select("WITH block_height AS (\n" +
            "    SELECT MAX(number) - 500 as safe_block_number\n" +
            "    FROM blocks b\n" +
            "    WHERE number IS NOT NULL\n" +
            "),\n" +
            "recent_txs AS (\n" +
            "    SELECT t.from_address_hash, t.to_address_hash, t.value\n" +
            "    FROM transactions t, block_height lt\n" +
            "    WHERE t.to_address_hash = decode(#{address}, 'hex')\n" +
            "      AND t.block_number IS NOT NULL\n" +
            "      AND t.block_number >= (SELECT safe_block_number - 100000 FROM block_height)\n" +
            "    ORDER BY t.block_number DESC, t.index DESC\n" +
            "    LIMIT 100000\n" +
            ")\n" +
            "SELECT\n" +
            "    '0x' || encode(t.from_address_hash, 'hex') AS sender,\n" +
            "    '0x' || encode(t.to_address_hash, 'hex') AS recipient,\n" +
            "    COUNT(*) AS transaction_count,\n" +
            "    SUM(t.value) / 1e18 AS total_amount_eth,\n" +
            "    CASE WHEN a.contract_code IS NULL THEN 'No' ELSE 'Yes' END AS is_contract_address\n" +
            "FROM recent_txs t\n" +
            "LEFT JOIN addresses a ON t.from_address_hash = a.hash\n" +
            "GROUP BY t.from_address_hash, t.to_address_hash, a.contract_code\n" +
            "ORDER BY transaction_count DESC\n" +
            "LIMIT 10")
    List<AddressFlowSummary> getInflow(@Param("address") String address);
}

