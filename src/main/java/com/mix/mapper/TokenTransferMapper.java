package com.mix.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface TokenTransferMapper {


    @Select("<script>" +
            "SELECT " +
            "    encode(tt.from_address_hash, 'hex') AS fromAddress, " +
            "    encode(tt.to_address_hash, 'hex') AS toAddress, " +
            "    encode(tt.transaction_hash, 'hex') AS transactionHash, " +
            "    tt.block_number AS blockNumber, " +
            "    b.timestamp AS transferTime, " +
            "    tt.amount / POWER(10, t.decimals) AS amount, " +
            "    t.symbol AS tokenSymbol, " +
            "    'historical' AS datasource " +
            "FROM " +
            "    token_transfers tt " +
            "LEFT JOIN " +
            "    tokens t ON tt.token_contract_address_hash = t.contract_address_hash " +
            "LEFT JOIN " +
            "    blocks b ON tt.block_number = b.number " +
            "WHERE " +
            "    tt.token_contract_address_hash = decode(#{contractAddress}, 'hex') " +
            "    <if test='startTime != null'> " +
            "        AND EXTRACT(EPOCH FROM b.timestamp) &gt;= #{startTime} " +
            "    </if> " +
            "    <if test='endTime != null'> " +
            "        AND EXTRACT(EPOCH FROM b.timestamp) &lt;= #{endTime} " +
            "    </if> " +
            "UNION ALL " +
            "SELECT " +
            "    encode(stt.from_address_hash, 'hex') AS fromAddress, " +
            "    encode(stt.to_address_hash, 'hex') AS toAddress, " +
            "    encode(stt.transaction_hash, 'hex') AS transactionHash, " +
            "    stt.block_number AS blockNumber, " +
            "    stt.timestamp AS transferTime, " +
            "    stt.amount AS amount, " +
            "    t.symbol AS tokenSymbol, " +
            "    'simulated' AS datasource " +
            "FROM " +
            "    simulated_token_transfers stt " +
            "LEFT JOIN " +
            "    tokens t ON stt.token_contract_address_hash = t.contract_address_hash " +
            "WHERE " +
            "    stt.token_contract_address_hash = decode(#{contractAddress}, 'hex') " +
            "    <if test='startTime != null'> " +
            "        AND EXTRACT(EPOCH FROM stt.timestamp) &gt;= #{startTime} " +
            "    </if> " +
            "    <if test='endTime != null'> " +
            "        AND EXTRACT(EPOCH FROM stt.timestamp) &lt;= #{endTime} " +
            "    </if>" +
            "ORDER BY transferTime DESC " +
            "</script>")
    IPage<Map<String, Object>> getTokenTransfers(Page<?> page,
                                                 @Param("contractAddress") String contractAddress,
                                                 @Param("startTime") Long startTime,
                                                 @Param("endTime") Long endTime);
}
