package com.mix.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.mix.entity.Result;
import com.mix.entity.dto.TokenTransferDTO;
import com.mix.entity.dto.WalletValuePoint;
import com.mix.service.TokenTransferService;
import com.mix.service.WalletBalanceService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.List;
import java.math.RoundingMode;

@Slf4j
@RestController
@RequestMapping("/wallet")
public class WalletController {

    @Autowired
    private WalletBalanceService walletBalanceService;

    @Autowired
    private TokenTransferService tokenTransferService;

    @GetMapping("/valueChart/daily")
    public Result getDailyValueCurve(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate,
            @RequestParam(required = false) String contractAddress) {
        LocalDateTime startTime = startDate.atStartOfDay();
        LocalDateTime endTime = endDate.atStartOfDay();
        List<WalletValuePoint> curve = walletBalanceService.getWalletValueCurve(startTime, endTime, contractAddress);

        // 格式化每个 WalletValuePoint 的 valueUSD 为两位小数
        curve.forEach(point -> point.setValueUSD(point.getValueUSD().setScale(2, RoundingMode.HALF_UP)));

//        curve.remove(curve.size()-1);
        return Result.success(curve);
    }

    @GetMapping("/valueChart/hourly")
    public Result getHourlyValueCurve(
            @RequestParam(required = false) String contractAddress) {
        LocalDateTime startTime = LocalDate.now().atStartOfDay();
        LocalDateTime endTime = LocalDateTime.now();
        List<WalletValuePoint> curve = walletBalanceService.getWalletValueCurveByHour(startTime, endTime, contractAddress);

        // 格式化每个 WalletValuePoint 的 valueUSD 为两位小数
        curve.forEach(point -> point.setValueUSD(point.getValueUSD().setScale(2, RoundingMode.HALF_UP)));

        curve.remove(curve.size()-1);
        return Result.success(curve);
    }

    @GetMapping("/valueChart/current")
    public Result getCurrentTotalValue(
            @RequestParam(required = false) String contractAddress) {
        BigDecimal totalValue = walletBalanceService.getCurrentTotalValue(contractAddress);
        if (totalValue == null){
            return Result.success(0);
        }
        // 限制为两位小数
        totalValue = totalValue.setScale(2, RoundingMode.HALF_UP);
        return Result.success(totalValue);
    }

    @GetMapping("/valueChart/change")
    public Result getValueChangePercentage(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate,
            @RequestParam(required = false) String contractAddress) {
        LocalDateTime startTime = startDate.atStartOfDay();
        LocalDateTime endTime = endDate.atTime(23, 59, 59);
        BigDecimal percentage = walletBalanceService.calculateValueChangePercentage(startTime, endTime, contractAddress);
        // 限制为两位小数
        percentage = percentage.setScale(2, RoundingMode.HALF_UP);
        return Result.success(percentage);
    }

    @PostMapping("/usdt/deposit")
    public Result depositUsdt(@RequestParam BigDecimal amount) {
        walletBalanceService.depositUsdt(amount);
        return Result.success();
    }

    @PostMapping("/token/deposit")
    public Result depositToken(
            @RequestParam String contractAddress,
            @RequestParam BigDecimal usdtAmount) {
        if (usdtAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return Result.failed("充值金额必须大于0");
        }
        tokenTransferService.depositToken(contractAddress, usdtAmount);
        return Result.success();
    }

    @GetMapping("/transcation/list")
    public Result queryTransfers(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate,
            @RequestParam(required = false) String contractAddress,
            @RequestParam(defaultValue = "1") long pageNo,
            @RequestParam(defaultValue = "20") long pageSize) {

        LocalDateTime startTime = startDate != null ? startDate.atStartOfDay() : null;
        LocalDateTime endTime = endDate != null ? endDate.atTime(23, 59, 59) : null;

        IPage<TokenTransferDTO> page = tokenTransferService.queryTransfers(
                startTime, endTime, contractAddress, pageNo, pageSize);

        return Result.success(page);
    }
}
