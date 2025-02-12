package com.mix.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mix.entity.dto.WalletTokenBalance;
import com.mix.entity.dto.WalletValuePoint;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface WalletTokenBalanceMapper extends BaseMapper<WalletTokenBalance> {
    
    @Insert("INSERT INTO wallet_token_balance (contract_address, balance, timestamp) " +
            "VALUES (#{contractAddress}, #{balance}, #{timestamp}) " +
            "ON CONFLICT (contract_address, timestamp) " +
            "DO UPDATE SET balance = EXCLUDED.balance")
    void insertOrUpdateBalance(WalletTokenBalance balance);
    
    @Select("SELECT balance FROM wallet_token_balance " +
            "WHERE contract_address ILIKE #{contractAddress} " +
            "ORDER BY timestamp DESC LIMIT 1")
    BigDecimal getCurrentBalance(@Param("contractAddress") String contractAddress);
    
    @Select("SELECT balance FROM wallet_token_balance " +
            "WHERE contract_address ILIKE #{contractAddress} " +
            "AND timestamp <= #{timestamp} " +
            "ORDER BY timestamp DESC LIMIT 1")
    BigDecimal getLatestBalance(@Param("contractAddress") String contractAddress,
                               @Param("timestamp") LocalDateTime timestamp);

    @Select("WITH RECURSIVE dates AS ( " +
            "    SELECT date_trunc('day', #{startTime}::timestamp) as date " +
            "    UNION ALL " +
            "    SELECT date + interval '1 day' " +
            "    FROM dates " +
            "    WHERE date < #{endTime}::timestamp " +
            "), " +
            "distinct_tokens AS ( " +
            "    SELECT DISTINCT contract_address " +
            "    FROM wallet_token_balance " +
            "    WHERE #{contractAddress}::varchar IS NULL " +
            "          OR contract_address ILIKE #{contractAddress} " +
            "), " +
            "all_balances AS ( " +
            "    SELECT contract_address, balance, timestamp " +
            "    FROM wallet_token_balance " +
            "    WHERE contract_address IN (SELECT contract_address FROM distinct_tokens) " +
            "), " +
            "daily_balances AS ( " +
            "    SELECT d.date, " +
            "           dt.contract_address, " +
            "           COALESCE(( " +
            "               SELECT balance " +
            "               FROM all_balances ab " +
            "               WHERE ab.contract_address = dt.contract_address " +
            "                 AND ab.timestamp <= d.date + interval '1 day' - interval '1 second' " +
            "               ORDER BY ab.timestamp DESC " +
            "               LIMIT 1 " +
            "           ), 0) as balance " +
            "    FROM dates d " +
            "    CROSS JOIN distinct_tokens dt " +
            "), " +
            "base_prices AS ( " +
            "    SELECT db.date, " +
            "           db.contract_address, " +
            "           db.balance, " +
            "           COALESCE(( " +
            "               SELECT price_usd " +
            "               FROM token_price_history " +
            "               WHERE contract_address ILIKE db.contract_address " +
            "                 AND timestamp <= db.date + interval '1 day' - interval '1 second' " +
            "               ORDER BY timestamp DESC " +
            "               LIMIT 1 " +
            "           ), 1) as base_price_usd " +
            "    FROM daily_balances db " +
            "), " +
            "risk_adjusted_prices AS ( " +
            "    SELECT bp.date, " +
            "           bp.contract_address, " +
            "           bp.balance, " +
            "           CASE " +
            "               WHEN EXISTS ( " +
            "                   SELECT 1 " +
            "                   FROM risk_log r " +
            "                   WHERE r.contract_address ILIKE bp.contract_address " +
            "                   AND r.log_time::date = bp.date::date " +
            "               ) THEN bp.base_price_usd * (0.85 + random() * 0.10) " +
            "               ELSE bp.base_price_usd " +
            "           END as price_usd " +
            "    FROM base_prices bp " +
            ") " +
            "SELECT date as timestamp, " +
            "       SUM(balance * price_usd) as value_usd " +
            "FROM risk_adjusted_prices " +
            "GROUP BY date " +
            "ORDER BY date")
    List<WalletValuePoint> getWalletValueCurve(@Param("startTime") LocalDateTime startTime,
                                               @Param("endTime") LocalDateTime endTime,
                                               @Param("contractAddress") String contractAddress);

    @Select("WITH RECURSIVE hours AS ( " +
            "    SELECT date_trunc('hour', #{startTime}::timestamp) as hour " +
            "    UNION ALL " +
            "    SELECT hour + interval '1 hour' " +
            "    FROM hours " +
            "    WHERE hour < #{endTime}::timestamp " +
            "), " +
            "all_tokens AS ( " +
            "    SELECT DISTINCT contract_address " +
            "    FROM wallet_token_balance " +
            "    WHERE #{contractAddress}::varchar IS NULL " +  
            "          OR contract_address ILIKE #{contractAddress} " +
            "), " +
            "hourly_balances AS ( " +
            "    SELECT h.hour, " +
            "           t.contract_address, " +
            "           (SELECT balance " +
            "            FROM wallet_token_balance w " +
            "            WHERE w.contract_address ILIKE t.contract_address " +
            "            AND w.timestamp <= h.hour " +
            "            ORDER BY w.timestamp DESC " +
            "            LIMIT 1) as balance " +
            "    FROM hours h " +
            "    CROSS JOIN all_tokens t " +
            "), " +
            "base_prices AS ( " +
            "    SELECT hb.hour, " +
            "           hb.contract_address, " +
            "           hb.balance, " +
            "           (SELECT price_usd " +
            "            FROM token_price_history " +
            "            WHERE contract_address ILIKE hb.contract_address " +
            "            AND timestamp <= hb.hour " +
            "            ORDER BY timestamp DESC " +
            "            LIMIT 1) as base_price_usd " +
            "    FROM hourly_balances hb " +
            "    WHERE hb.balance IS NOT NULL " +
            "), " +
            "risk_adjusted_prices AS ( " +
            "    SELECT bp.hour, " +
            "           bp.contract_address, " +
            "           bp.balance, " +
            "           CASE " +
            "               WHEN EXISTS ( " +
            "                   SELECT 1 " +
            "                   FROM risk_log r " +
            "                   WHERE r.contract_address ILIKE bp.contract_address " +
            "                   AND r.log_time::date = bp.hour::date " +
            "               ) THEN bp.base_price_usd * (0.85 + random() * 0.10) " +
            "               ELSE bp.base_price_usd " +
            "           END as price_usd " +
            "    FROM base_prices bp " +
            ") " +
            "SELECT hour as timestamp, " +
            "       SUM(COALESCE(balance * COALESCE(price_usd, 1), 0)) as value_usd " +
            "FROM risk_adjusted_prices " +
            "GROUP BY hour " +
            "ORDER BY hour")
    List<WalletValuePoint> getWalletValueCurveByHour(@Param("startTime") LocalDateTime startTime, 
                                                    @Param("endTime") LocalDateTime endTime,
                                                    @Param("contractAddress") String contractAddress);

    @Select("WITH latest_balances AS ( " +
            "    SELECT DISTINCT ON (contract_address) " +
            "           contract_address, balance " +
            "    FROM wallet_token_balance " +
            "    WHERE #{contractAddress}::varchar IS NULL " +
            "          OR contract_address ILIKE #{contractAddress} " +
            "    ORDER BY contract_address, timestamp DESC " +
            "), " +
            "latest_prices AS ( " +
            "    SELECT lb.contract_address, lb.balance, " +
            "           COALESCE(( " +
            "               SELECT price_usd " +
            "               FROM token_price_history " +
            "               WHERE contract_address ILIKE lb.contract_address " +
            "               ORDER BY timestamp DESC " +
            "               LIMIT 1 " +
            "           ), 1) as price_usd " +
            "    FROM latest_balances lb " +
            ") " +
            "SELECT SUM(balance * price_usd) as total_value_usd " +
            "FROM latest_prices")
    BigDecimal getCurrentTotalValue(@Param("contractAddress") String contractAddress);
} 