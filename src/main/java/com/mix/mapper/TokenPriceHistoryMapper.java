package com.mix.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Mapper
public interface TokenPriceHistoryMapper {
    
    @Select("WITH base_price AS ( " +
            "    SELECT price_usd, timestamp::date as price_date " +
            "    FROM token_price_history " +
            "    WHERE contract_address ILIKE #{tokenAddress} " +
            "    AND timestamp <= #{queryTime} " +
            "    ORDER BY timestamp DESC LIMIT 1 " +
            "), " +
            "risk_check AS ( " +
            "    SELECT DISTINCT log_time::date as risk_date, " +
            "           (0.85 + random() * 0.10)::decimal(10,4) as risk_factor " +  // 生成0.85-0.95之间的随机数
            "    FROM risk_log " +
            "    WHERE contract_address ILIKE #{tokenAddress} " +
            "    AND log_time::date = (SELECT price_date FROM base_price) " +
            ") " +
            "SELECT CASE " +
            "    WHEN r.risk_date IS NOT NULL THEN bp.price_usd * r.risk_factor " +
            "    ELSE bp.price_usd " +
            "END as price_usd " +
            "FROM base_price bp " +
            "LEFT JOIN risk_check r ON bp.price_date = r.risk_date")
    BigDecimal getTokenPrice(@Param("tokenAddress") String tokenAddress, 
                           @Param("queryTime") LocalDateTime queryTime);
} 