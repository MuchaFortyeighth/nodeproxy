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
            "    SELECT MAX(number) - 10 as safe_block_number\n" +
            "    FROM blocks b\n" +
            "    WHERE number IS NOT NULL\n" +
            "),\n" +
            "recent_transfers AS (\n" +
            "    SELECT tt.from_address_hash, tt.amount, t.decimals\n" +
            "    FROM token_transfers tt\n" +
            "    JOIN tokens t ON tt.token_contract_address_hash = t.contract_address_hash, block_height lt\n" +
            "    WHERE tt.token_contract_address_hash = decode(#{contractAddress}, 'hex')\n" +
            "      AND tt.block_number IS NOT NULL\n" +
            "      AND tt.block_consensus = true\n" +
            "      AND tt.block_number >= (SELECT safe_block_number - 10000 FROM block_height)\n" +
            "    ORDER BY tt.block_number DESC, tt.log_index DESC\n" +
            "    LIMIT 100000\n" +
            ")\n" +
            "SELECT\n" +
            "    '0x' || encode(t.from_address_hash, 'hex') AS address,\n" +
            "    COUNT(*) AS transaction_count,\n" +
            "    SUM(t.amount / POWER(10, t.decimals)) AS total_amount_token,\n" +
            "    (COUNT(*) * 0.6 + COALESCE(SUM(t.amount / POWER(10, t.decimals)), 0) * 0.4) AS risk_score\n" +
            "FROM recent_transfers t\n" +
            "GROUP BY t.from_address_hash\n" +
            "ORDER BY risk_score DESC\n" +
            "LIMIT 100")
    List<RiskyAddressSummary> getRiskyAddresses(@Param("contractAddress") String contractAddress);

    @Select("WITH block_height AS (\n" +
            "    SELECT MAX(number) - 10 as safe_block_number\n" +
            "    FROM blocks b\n" +
            "    WHERE number IS NOT NULL\n" +
            "),\n" +
            "recent_transfers AS (\n" +
            "    SELECT tt.from_address_hash, tt.amount, t.decimals\n" +
            "    FROM token_transfers tt\n" +
            "    JOIN tokens t ON tt.token_contract_address_hash = t.contract_address_hash, block_height lt\n" +
            "    WHERE tt.token_contract_address_hash = decode(#{contractAddress}, 'hex')\n" +
            "      AND tt.block_number IS NOT NULL\n" +
            "      AND tt.block_consensus = true\n" +
            "      AND tt.block_number >= (SELECT safe_block_number - 10000 FROM block_height)\n" +
            "    ORDER BY tt.block_number DESC, tt.log_index DESC\n" +
            "    LIMIT 100000\n" +
            "),\n" +
            "risk_addresses AS (\n" +
            "    SELECT\n" +
            "        '0x' || encode(t.from_address_hash, 'hex') AS address,\n" +
            "        COUNT(*) AS transaction_count,\n" +
            "        SUM(t.amount / POWER(10, t.decimals)) AS total_amount_token,\n" +
            "        (COUNT(*) * 0.6 + COALESCE(SUM(t.amount / POWER(10, t.decimals)), 0) * 0.4) AS risk_score\n" +
            "    FROM recent_transfers t\n" +
            "    GROUP BY t.from_address_hash\n" +
            "    ORDER BY risk_score DESC\n" +
            "    LIMIT 10000\n" +
            ")\n" +
            "SELECT *\n" +
            "FROM risk_addresses\n" +
            "WHERE LOWER(address) LIKE LOWER(CONCAT('%', #{addressPattern}, '%'))\n" +
            "ORDER BY risk_score DESC")
    List<RiskyAddressSummary> getRiskyAddressesWithPattern(@Param("contractAddress") String contractAddress,
                                                          @Param("addressPattern") String addressPattern);

}

