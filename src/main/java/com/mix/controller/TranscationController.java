package com.mix.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mix.entity.Result;
import com.mix.entity.req.TransactionReq;
import com.mix.service.SimulatedTransationService;
import com.mix.service.TokenTransferService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;


@RestController
@RequestMapping("/transcation")
public class TranscationController {

    @Autowired
    private TokenTransferService tokenTransferService;

    @Autowired
    private SimulatedTransationService simulatedTransationService;

    @GetMapping("/page/{contractAddress}/{current}/{size}")
    public Result getTokenTransfers(
            @PathVariable String contractAddress,
            @PathVariable int current,
            @PathVariable int size,
            @RequestParam(required = false) Long startTime,
            @RequestParam(required = false) Long endTime) {

        // 处理传入合约地址
        if (contractAddress.startsWith("0x")) {
            contractAddress = contractAddress.substring(2).toLowerCase();
        }
        Page<Map<String, Object>> page = new Page<>(current, size);
        // 调用 Service 获取分页结果
        return Result.success(tokenTransferService.getTokenTransfers(page,contractAddress, startTime, endTime));
    }

    @PostMapping({"/create"})
    public Result setParameters(@RequestBody TransactionReq transactionReq) {
        tokenTransferService.createTransaction(transactionReq);
        return Result.success();
    }

    @GetMapping({"/agent/generate/{timestamp}/{contractAddress}"})
    public Result generateTransactions(@PathVariable long timestamp, @PathVariable String contractAddress) {
        return Result.success(simulatedTransationService.generateSimulatedTransactions(timestamp, contractAddress));
    }

    @PostMapping({"/agent/confirm/{uuid}"})
    public Result confirm(@PathVariable String uuid) {
        return Result.success(simulatedTransationService.confirmTransactions(uuid));
    }

}

