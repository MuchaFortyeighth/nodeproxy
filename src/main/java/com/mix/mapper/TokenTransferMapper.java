package com.mix.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mix.entity.dto.TokenTransferDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Mapper
public interface TokenTransferMapper {


    @Select("<script>" +
            "WITH filtered_transfers AS (\n" +
            "    SELECT tt.*\n" +
            "    FROM token_transfers tt\n" +
            "    WHERE tt.token_contract_address_hash = decode(#{contractAddress}, 'hex')\n" +
            "        AND tt.block_consensus = true\n" +
            "        <if test='startTime != null'>\n" +
            "            AND tt.inserted_at &gt;= to_timestamp(#{startTime})\n" +
            "        </if>\n" +
            "        <if test='endTime != null'>\n" +
            "            AND tt.inserted_at &lt;= to_timestamp(#{endTime})\n" +
            "        </if>\n" +
            "    ORDER BY tt.block_number DESC, tt.log_index DESC\n" +
            "    LIMIT 1000\n" +
            ")\n" +
            "SELECT\n" +
            "    '0x' || encode(tt.from_address_hash, 'hex') AS fromAddress,\n" +
            "    '0x' || encode(tt.to_address_hash, 'hex') AS toAddress,\n" +
            "    encode(tt.transaction_hash, 'hex') AS transactionHash,\n" +
            "    tt.block_number AS blockNumber,\n" +
            "    (b.timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Shanghai') AS transferTime,\n" +
            "    tt.amount / POWER(10, t.decimals) AS amount,\n" +
            "    t.symbol AS tokenSymbol,\n" +
            "    'historical' AS datasource\n" +
            "FROM filtered_transfers tt\n" +
            "LEFT JOIN tokens t ON tt.token_contract_address_hash = t.contract_address_hash\n" +
            "LEFT JOIN blocks b ON tt.block_number = b.number\n" +
            "UNION ALL\n" +
            "SELECT * FROM (\n" +
            "    SELECT\n" +
            "        encode(stt.from_address_hash, 'hex') AS fromAddress,\n" +
            "        encode(stt.to_address_hash, 'hex') AS toAddress,\n" +
            "        encode(stt.transaction_hash, 'hex') AS transactionHash,\n" +
            "        stt.block_number AS blockNumber,\n" +
            "        (stt.timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Shanghai') AS transferTime,\n" +
            "        stt.amount AS amount,\n" +
            "        t.symbol AS tokenSymbol,\n" +
            "        datasource\n" +
            "    FROM simulated_token_transfers stt\n" +
            "    LEFT JOIN tokens t ON stt.token_contract_address_hash = t.contract_address_hash\n" +
            "    WHERE stt.token_contract_address_hash = decode(#{contractAddress}, 'hex')\n" +
            "        <if test='startTime != null'>\n" +
            "            AND stt.timestamp &gt;= to_timestamp(#{startTime})\n" +
            "        </if>\n" +
            "        <if test='endTime != null'>\n" +
            "            AND stt.timestamp &lt;= to_timestamp(#{endTime})\n" +
            "        </if>\n" +
            "    ORDER BY stt.block_number DESC\n" +
            "    LIMIT 1000\n" +
            ") simulated\n" +
            "ORDER BY transferTime DESC, blockNumber DESC\n" +
            "</script>")
    IPage<Map<String, Object>> getTokenTransfers(Page<?> page,
                                               @Param("contractAddress") String contractAddress,
                                               @Param("startTime") Long startTime,
                                               @Param("endTime") Long endTime);

    @Select("SELECT " +
            "    COALESCE(t.symbol, 'UNKNOWN') as tokensymbol, " +
            "    stt.amount, " +
            "    stt.timestamp as transfertime, " +
            "    encode(stt.to_address_hash, 'hex') as toaddress, " +
            "    stt.datasource, " +
            "    stt.block_number as blocknumber, " +
            "    encode(stt.transaction_hash, 'hex') as transactionhash, " +
            "    encode(stt.from_address_hash, 'hex') as fromaddress " +
            "FROM simulated_token_transfers stt " +
            "LEFT JOIN tokens t ON t.contract_address_hash = stt.token_contract_address_hash " +
            "WHERE (#{startTime}::timestamp IS NULL OR stt.timestamp >= #{startTime}) " +
            "AND (#{endTime}::timestamp IS NULL OR stt.timestamp <= #{endTime}) " +
            "ORDER BY stt.timestamp DESC")
    IPage<TokenTransferDTO> queryTransfers(Page<TokenTransferDTO> page,
                                           @Param("startTime") LocalDateTime startTime,
                                           @Param("endTime") LocalDateTime endTime);
}
