package com.mix.service;

import com.mix.entity.dto.WalletTokenBalance;
import com.mix.entity.dto.WalletValuePoint;
import com.mix.mapper.WalletTokenBalanceMapper;
import com.mix.mapper.TokenPriceHistoryMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import java.math.RoundingMode;

@Slf4j
@Service
public class WalletBalanceService {
    
    private static final String USDT_ADDRESS = "0xdac17f958d2ee523a2206206994597c13d831ec7";
    private static final String LIDO_ADDRESS = "0x5a98fcbea516cf06857215779fd812ca3bef1b32";
    
    @Autowired
    private WalletTokenBalanceMapper walletTokenBalanceMapper;
    
    @Autowired
    private TokenPriceHistoryMapper tokenPriceHistoryMapper;
    
    /**
     * 初始化钱包余额
     */
    public void initializeWalletBalance() {
        LocalDateTime startTime = LocalDateTime.now().minusDays(180);
        // 初始化USDT余额
        updateBalance(USDT_ADDRESS, new BigDecimal("1000"), startTime);
        // 初始化Lido余额
        updateBalance(LIDO_ADDRESS, new BigDecimal("10"), startTime);
    }
    
    /**
     * 更新钱包余额
     */
    public void updateBalance(String tokenAddress, BigDecimal amount, LocalDateTime timestamp) {
        BigDecimal currentBalance = getCurrentBalance(tokenAddress);
        BigDecimal newBalance = currentBalance.add(amount);
        
        WalletTokenBalance balance = new WalletTokenBalance();
        balance.setContractAddress(tokenAddress);
        balance.setBalance(newBalance);
        balance.setTimestamp(timestamp);
        
        walletTokenBalanceMapper.insertOrUpdateBalance(balance);
    }
    
    /**
     * 获取当前余额
     */
    private BigDecimal getCurrentBalance(String tokenAddress) {
        BigDecimal balance = walletTokenBalanceMapper.getCurrentBalance(tokenAddress);
        return balance != null ? balance : BigDecimal.ZERO;
    }
    
    /**
     * 获取钱包资产价值曲线
     */
    public List<WalletValuePoint> getWalletValueCurve(LocalDateTime startTime, LocalDateTime endTime) {
        return walletTokenBalanceMapper.getWalletValueCurve(startTime, endTime);
    }

    /**
     * 获取钱包按小时统计的资产价值曲线
     */
    public List<WalletValuePoint> getWalletValueCurveByHour(LocalDateTime startTime, LocalDateTime endTime) {
        return walletTokenBalanceMapper.getWalletValueCurveByHour(startTime, endTime);
    }

    /**
     * 获取当前总资产估值
     */
    public BigDecimal getCurrentTotalValue() {
        return walletTokenBalanceMapper.getCurrentTotalValue();
    }

    /**
     * 计算资产变动百分比
     */
    public BigDecimal calculateValueChangePercentage(LocalDateTime startTime, LocalDateTime endTime) {
        List<WalletValuePoint> valueCurve = getWalletValueCurve(startTime, endTime);
        if (valueCurve.isEmpty()) {
            return BigDecimal.ZERO;
        }

        BigDecimal startValue = valueCurve.get(0).getValueUSD();
        BigDecimal endValue = valueCurve.get(valueCurve.size() - 1).getValueUSD();

        if (startValue.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }

        return endValue.subtract(startValue)
                .multiply(new BigDecimal("100"))
                .divide(startValue, 2, RoundingMode.HALF_UP);
    }

    /**
     * 获取代币当前价格（考虑风险因素）
     */
    public BigDecimal getTokenPrice(String tokenAddress) {
        BigDecimal price = tokenPriceHistoryMapper.getTokenPrice(tokenAddress, LocalDateTime.now());
        return price != null ? price : BigDecimal.ONE;
    }

    /**
     * 获取指定时间的代币价格（考虑风险因素）
     */
    public BigDecimal getTokenPrice(String tokenAddress, LocalDateTime queryTime) {
        BigDecimal price = tokenPriceHistoryMapper.getTokenPrice(tokenAddress, queryTime);
        return price != null ? price : BigDecimal.ONE;
    }

    /**
     * USDT充值
     */
    public void depositUsdt(BigDecimal amount) {
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("充值金额必须大于0");
        }
        updateBalance(USDT_ADDRESS, amount, LocalDateTime.now());
    }
} 