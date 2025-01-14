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
import lombok.extern.slf4j.Slf4j;

import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

@Service
@Slf4j
public class TokenTransferService {

    @Autowired
    private TokenTransferMapper tokenTransferMapper;

    @Autowired
    private SimulatedTokenTransferMapper simulatedTokenTransferMapper;

    @Autowired
    private BlocksMapper blocksMapper;

    public IPage<Map<String, Object>> getTokenTransfers(Page<?> page, String contractAddress, Long startTime, Long endTime) {
        // 转换时间戳为区块高度
        Long startBlock = null;
        Long endBlock = null;
        
        if (startTime != null) {
            String startTimeStr = Instant.ofEpochSecond(startTime)
                .atZone(ZoneId.systemDefault())
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            Block startBlockObj = blocksMapper.getNearestBlock(startTimeStr);
            startBlock = startBlockObj != null ? startBlockObj.getNumber() : null;
        }
        
        if (endTime != null) {
            String endTimeStr = Instant.ofEpochSecond(endTime)
                .atZone(ZoneId.systemDefault())
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            Block endBlockObj = blocksMapper.getNearestBlock(endTimeStr);
            endBlock = endBlockObj != null ? endBlockObj.getNumber() : null;
        }

        return tokenTransferMapper.getTokenTransfers(page, contractAddress, startBlock, endBlock);
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
//        LocalDateTime localDateTime = Instant.ofEpochMilli(nearestBlock.getTimestamp().getTime()).atZone(ZoneId.systemDefault()).toLocalDateTime();
        LocalDateTime localDateTime = LocalDateTime.ofInstant(Instant.ofEpochSecond(transactionReq.getTimestamp()), ZoneId.systemDefault());
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