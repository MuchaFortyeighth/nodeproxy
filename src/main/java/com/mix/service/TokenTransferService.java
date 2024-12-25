package com.mix.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mix.entity.req.TransactionReq;
import com.mix.entity.TransactionType;
import com.mix.entity.dto.Block;
import com.mix.entity.dto.SimulatedTokenTransfer;
import com.mix.mapper.BlocksMapper;
import com.mix.mapper.SimulatedTokenTransferMapper;
import com.mix.mapper.TokenTransferMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

@Service
public class TokenTransferService {

    @Autowired
    private TokenTransferMapper tokenTransferMapper;

    @Autowired
    private SimulatedTokenTransferMapper simulatedTokenTransferMapper;

    @Autowired
    private BlocksMapper blocksMapper;

    public IPage<Map<String, Object>> getTokenTransfers(String contractAddress, Long startTime, Long endTime, int current, int size) {
        // 创建分页对象
        Page<Map<String, Object>> page = new Page<>(current, size);

        // 调用 Mapper 方法
        IPage<Map<String, Object>> result = tokenTransferMapper.getTokenTransfers(page, contractAddress, startTime, endTime);

        // 转换 timestamp 为 LocalDateTime
        result.getRecords().forEach(record -> {
            Object transfertime = record.get("transfertime");
            if (transfertime instanceof java.sql.Timestamp) {
                record.put("transfertime", ((java.sql.Timestamp) transfertime).toLocalDateTime());
            }
        });

        return result;
    }



    public void createTransaction(TransactionReq transactionReq) {
        // 获取最接近的区块信息
        Block nearestBlock = getNearestBlock(transactionReq.getTimestamp());

        // 根据交易类型生成 from/to 地址
        String fromAddress = transactionReq.getWalletAddress();
        String toAddress = generateToAddress(transactionReq.getTransactionType(), transactionReq.getTokenContractAddressHash());

        // 模拟生成交易哈希
        String transactionHash = generateTransactionHash();

        // 创建交易记录
        SimulatedTokenTransfer transaction = new SimulatedTokenTransfer();
        transaction.setFromAddressHash(fromAddress.replace("0x",""));
        transaction.setToAddressHash(toAddress.replace("0x",""));
        transaction.setTransactionHash(transactionHash.replace("0x",""));
        transaction.setBlockNumber(nearestBlock.getNumber());  // 使用最接近区块的 block_number
        LocalDateTime localDateTime = Instant.ofEpochMilli(nearestBlock.getTimestamp().getTime()).atZone(ZoneId.systemDefault()).toLocalDateTime();
        transaction.setTimestamp(localDateTime); // 使用提供的交易时间戳
        transaction.setAmount(transactionReq.getAmount());  // 设置交易金额
        transaction.setTokenContractAddressHash(transactionReq.getTokenContractAddressHash().replace("0x",""));
        transaction.setDatasource("simulated");  // 设置数据来源

        // 插入交易记录
        simulatedTokenTransferMapper.insertOne(transaction);
    }

    public Block getNearestBlock(long timestamp) {
        // 将时间戳转换为 "yyyy-MM-dd HH:mm:ss" 格式的字符串
        String timestampStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(timestamp * 1000));
        return blocksMapper.getNearestBlock(timestampStr);  // 查询最接近的区块
    }

    private String generateToAddress(TransactionType transactionType, String tokenContractAddressHash) {
        if (transactionType == TransactionType.SWAP) {
            // 对于 swap 类型，生成一个随机地址
            return generateRandomAddress();
        } else {
            // 对于其他类型，toAddress 为 Token 合约地址
            return tokenContractAddressHash;
        }
    }

    private String generateRandomAddress() {
        // 生成一个类似真实以太坊地址的随机地址
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder("0x");

        // 生成 40 个随机十六进制字符
        for (int i = 0; i < 40; i++) {
            int hexValue = random.nextInt(16); // 获取一个 0-15 的随机整数
            sb.append(Integer.toHexString(hexValue)); // 将整数转换为对应的十六进制字符
        }

        return sb.toString();
    }

    private String generateTransactionHash() {
        // 生成模拟的交易哈希
        return UUID.randomUUID().toString().replace("-", "");
    }
}