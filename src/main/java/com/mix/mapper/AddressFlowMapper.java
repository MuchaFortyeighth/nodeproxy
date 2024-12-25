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
    @Select("SELECT\n" +
            "    '0x' || encode(t.from_address_hash, 'hex') AS sender,\n" +
            "    '0x' || encode(t.to_address_hash, 'hex') AS recipient,\n" +
            "    COUNT(*) AS transaction_count,\n" +
            "    SUM(t.value) / 1e18 AS total_amount_eth,\n" +
            "    CASE\n" +
            "        WHEN a.contract_code IS NULL THEN 'No'\n" +
            "        ELSE 'Yes'\n" +
            "    END AS is_contract_address\n" +
            "FROM (select* from transactions t \n" +
            "\tWHERE t.from_address_hash = decode(#{address}, 'hex')\n" +
            "\tlimit 2000) t\n" +
            "LEFT JOIN public.addresses a ON t.to_address_hash = a.hash\n" +
            "WHERE t.from_address_hash = decode(#{address}, 'hex')\n" +
            "GROUP BY t.to_address_hash, t.from_address_hash, a.contract_code\n" +
            "ORDER BY total_amount_eth DESC\n" +
            "limit 10;")
    List<AddressFlowSummary> getOutflow(@Param("address") String address);

    // 流入查询
    @Select("SELECT\n" +
            "    '0x' || encode(t.from_address_hash, 'hex') AS sender,\n" +
            "    '0x' || encode(t.to_address_hash, 'hex') AS recipient,\n" +
            "    COUNT(*) AS transaction_count,\n" +
            "    SUM(t.value) / 1e18 AS total_amount_eth,\n" +
            "    CASE\n" +
            "        WHEN a.contract_code IS NULL THEN 'No'\n" +
            "        ELSE 'Yes'\n" +
            "    END AS is_contract_address\n" +
            "FROM (select* from transactions t \n" +
            "\tWHERE t.to_address_hash = decode(#{address}, 'hex')\n" +
            "\tlimit 2000) t\n" +
            "LEFT JOIN addresses a ON t.from_address_hash = a.hash\n" +
            "WHERE t.to_address_hash = decode(#{address}, 'hex')\n" +
            "GROUP BY t.from_address_hash, t.to_address_hash, a.contract_code\n" +
            "ORDER BY total_amount_eth DESC\n" +
            "LIMIT 10")
    List<AddressFlowSummary> getInflow(@Param("address") String address);
}

