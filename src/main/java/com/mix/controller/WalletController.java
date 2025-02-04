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

@Slf4j
@RestController
@RequestMapping("/wallet")
public class WalletController {

    @Autowired
    private WalletBalanceService walletBalanceService;

    @Autowired
    private TokenTransferService tokenTransferService;

    @GetMapping("/value/daily")
    public Result getDailyValueCurve(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        LocalDateTime startTime = startDate.atStartOfDay();
        LocalDateTime endTime = endDate.atTime(23, 59, 59);
        List<WalletValuePoint> curve = walletBalanceService.getWalletValueCurve(startTime, endTime);
        curve.remove(curve.size()-1);
        return Result.success(curve);
    }

    @GetMapping("/value/hourly")
    public Result getHourlyValueCurve() {
        LocalDateTime startTime = LocalDate.now().atStartOfDay();
        LocalDateTime endTime = LocalDateTime.now();
        List<WalletValuePoint> curve = walletBalanceService.getWalletValueCurveByHour(startTime, endTime);
        curve.remove(curve.size()-1);
        return Result.success(curve);
    }

    @GetMapping("/value/current")
    public Result getCurrentTotalValue() {
        BigDecimal totalValue = walletBalanceService.getCurrentTotalValue();
        return Result.success(totalValue);
    }

    @GetMapping("/value/change")
    public Result getValueChangePercentage(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        LocalDateTime startTime = startDate.atStartOfDay();
        LocalDateTime endTime = endDate.atTime(23, 59, 59);
        BigDecimal percentage = walletBalanceService.calculateValueChangePercentage(startTime, endTime);
        return Result.success(percentage);
    }

    @PostMapping("/usdt/deposit")
    public Result depositUsdt(@RequestParam BigDecimal amount) {
        walletBalanceService.depositUsdt(amount);
        return Result.success();
    }

    @GetMapping("/transcation/list")
    public Result queryTransfers(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate,
            @RequestParam(defaultValue = "1") long pageNo,
            @RequestParam(defaultValue = "20") long pageSize) {

        LocalDateTime startTime = startDate != null ? startDate.atStartOfDay() : null;
        LocalDateTime endTime = endDate != null ? endDate.atTime(23, 59, 59) : null;

        IPage<TokenTransferDTO> page = tokenTransferService.queryTransfers(
                startTime, endTime, pageNo, pageSize);

        return Result.success(page);
    }
} 