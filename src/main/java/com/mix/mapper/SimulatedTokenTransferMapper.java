package com.mix.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mix.entity.dto.SimulatedTokenTransfer;
import com.mix.entity.dto.TokenTransferDTO;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDateTime;

@Mapper
public interface SimulatedTokenTransferMapper extends BaseMapper<SimulatedTokenTransfer> {

    @Insert("INSERT INTO public.simulated_token_transfers\n" +
            "(from_address_hash, to_address_hash, transaction_hash, block_number, \"timestamp\", amount, token_contract_address_hash, datasource)\n" +
            "VALUES(" +
            " decode(#{transfer.fromAddressHash},'hex')," +
            " decode(#{transfer.toAddressHash},'hex')," +
            " decode(#{transfer.transactionHash},'hex')," +
            " #{transfer.blockNumber}," +
            " #{transfer.timestamp}," +
            " #{transfer.amount}," +
            " decode(#{transfer.tokenContractAddressHash},'hex')," +
            " #{transfer.datasource});\n")
    public int insertOne(@Param("transfer")SimulatedTokenTransfer transfer);

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
            "AND (#{contractAddress}::varchar IS NULL " +
            "     OR encode(stt.token_contract_address_hash, 'hex') ILIKE " +
            "         CASE " +
            "             WHEN #{contractAddress} LIKE '0x%' THEN substring(#{contractAddress} from 3) " +
            "             ELSE #{contractAddress} " +
            "         END) " +
            "ORDER BY stt.timestamp DESC")
    IPage<TokenTransferDTO> queryTransfers(Page<TokenTransferDTO> page,
                                         @Param("startTime") LocalDateTime startTime,
                                         @Param("endTime") LocalDateTime endTime,
                                         @Param("contractAddress") String contractAddress);
}
