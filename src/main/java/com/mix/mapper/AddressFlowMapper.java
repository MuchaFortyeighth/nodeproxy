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
            "    SELECT MAX(number) - 10 as safe_block_number\n" +
            "    FROM blocks b\n" +
            "    WHERE number IS NOT NULL\n" +
            "),\n" +
            "recent_transfers AS (\n" +
            "    SELECT tt.from_address_hash, tt.to_address_hash, tt.amount, tt.token_contract_address_hash\n" +
            "    FROM token_transfers tt, block_height lt\n" +
            "    WHERE tt.from_address_hash = decode(#{address}, 'hex')\n" +
            "      AND tt.block_number IS NOT NULL\n" +
            "      AND tt.block_consensus = true\n" +
            "      AND tt.block_number >= (SELECT safe_block_number - 10000 FROM block_height)\n" +
            "    ORDER BY tt.block_number DESC, tt.log_index DESC\n" +
            "    LIMIT 100000\n" +
            ")\n" +
            "SELECT\n" +
            "    '0x' || encode(t.from_address_hash, 'hex') AS sender,\n" +
            "    '0x' || encode(t.to_address_hash, 'hex') AS recipient,\n" +
            "    COUNT(*) AS transaction_count,\n" +
            "    SUM(t.amount / POWER(10, tok.decimals)) AS total_amount_token,\n" +
            "    CASE WHEN a.contract_code IS NULL THEN 'No' ELSE 'Yes' END AS is_contract_address,\n" +
            "    tok.symbol AS token_symbol,\n" +
            "    '0x' || encode(t.token_contract_address_hash, 'hex') AS token_address\n" +
            "FROM recent_transfers t\n" +
            "LEFT JOIN addresses a ON t.to_address_hash = a.hash\n" +
            "LEFT JOIN tokens tok ON t.token_contract_address_hash = tok.contract_address_hash\n" +
            "GROUP BY t.to_address_hash, t.from_address_hash, a.contract_code, tok.symbol, tok.decimals, t.token_contract_address_hash\n" +
            "ORDER BY total_amount_token DESC\n" +
            "LIMIT 10")
    List<AddressFlowSummary> getOutflow(@Param("address") String address);

    // 流入查询
    @Select("WITH block_height AS (\n" +
            "    SELECT MAX(number) - 10 as safe_block_number\n" +
            "    FROM blocks b\n" +
            "    WHERE number IS NOT NULL\n" +
            "),\n" +
            "recent_transfers AS (\n" +
            "    SELECT tt.from_address_hash, tt.to_address_hash, tt.amount, tt.token_contract_address_hash\n" +
            "    FROM token_transfers tt, block_height lt\n" +
            "    WHERE tt.to_address_hash = decode(#{address}, 'hex')\n" +
            "      AND tt.block_number IS NOT NULL\n" +
            "      AND tt.block_consensus = true\n" +
            "      AND tt.block_number >= (SELECT safe_block_number - 10000 FROM block_height)\n" +
            "    ORDER BY tt.block_number DESC, tt.log_index DESC\n" +
            "    LIMIT 100000\n" +
            ")\n" +
            "SELECT\n" +
            "    '0x' || encode(t.from_address_hash, 'hex') AS sender,\n" +
            "    '0x' || encode(t.to_address_hash, 'hex') AS recipient,\n" +
            "    COUNT(*) AS transaction_count,\n" +
            "    SUM(t.amount / POWER(10, tok.decimals)) AS total_amount_token,\n" +
            "    CASE WHEN a.contract_code IS NULL THEN 'No' ELSE 'Yes' END AS is_contract_address,\n" +
            "    tok.symbol AS token_symbol,\n" +
            "    '0x' || encode(t.token_contract_address_hash, 'hex') AS token_address\n" +
            "FROM recent_transfers t\n" +
            "LEFT JOIN addresses a ON t.from_address_hash = a.hash\n" +
            "LEFT JOIN tokens tok ON t.token_contract_address_hash = tok.contract_address_hash\n" +
            "GROUP BY t.from_address_hash, t.to_address_hash, a.contract_code, tok.symbol, tok.decimals, t.token_contract_address_hash\n" +
            "ORDER BY total_amount_token DESC\n" +
            "LIMIT 10")
    List<AddressFlowSummary> getInflow(@Param("address") String address);
}

