package com.mix.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mix.entity.dto.SimulatedTokenTransfer;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
            " 'simulated'::character varying);\n")
    public int insertOne(@Param("transfer")SimulatedTokenTransfer transfer);
}
