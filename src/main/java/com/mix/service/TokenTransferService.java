package com.mix.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mix.entity.dto.TokenTransferDTO;
import com.mix.entity.req.TransactionReq;
import com.mix.entity.TransactionType;
import com.mix.entity.dto.Block;
import com.mix.entity.dto.SimulatedTokenTransfer;
import com.mix.mapper.BlocksMapper;
import com.mix.mapper.SimulatedTokenTransferMapper;
import com.mix.mapper.TokenTransferMapper;
import com.mix.mapper.WalletTokenBalanceMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;

import java.math.BigDecimal;
import java.math.RoundingMode;
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
import java.util.Random;

@Service
@Slf4j
public class TokenTransferService {

    @Autowired
    private TokenTransferMapper tokenTransferMapper;

    @Autowired
    private SimulatedTokenTransferMapper simulatedTokenTransferMapper;

    @Autowired
    private BlocksMapper blocksMapper;

    @Autowired
    private WalletBalanceService walletBalanceService;

    @Autowired
    private WalletTokenBalanceMapper walletTokenBalanceMapper;

    private static final String USDT_ADDRESS = "0xdac17f958d2ee523a2206206994597c13d831ec7";
    private static final Random random = new Random();
    private static final String ZERO_ADDRESS = "0000000000000000000000000000000000000000";
    private static final String BURN_ADDRESS = "000000000000000000000000000000000000dead";
    private static final String STAKE_ADDRESS = "0000000000000000000000000000000000000888";
    private static final String COLLATERAL_ADDRESS = "0000000000000000000000000000000000000999";

    private BigDecimal calculateTransactionFee() {
        // 生成15-20之间的随机手续费
        return BigDecimal.valueOf(15 + random.nextDouble() * 5)
                .setScale(6, RoundingMode.HALF_UP);
    }

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

    public IPage<TokenTransferDTO> queryTransfers(LocalDateTime startTime,
                                                LocalDateTime endTime,
                                                String contractAddress,
                                                long pageNo,
                                                long pageSize) {
        Page<TokenTransferDTO> page = new Page<>(pageNo, pageSize);
        return simulatedTokenTransferMapper.queryTransfers(page, startTime, endTime, contractAddress);
    }

    private boolean checkBalance(String contractAddress, BigDecimal requiredAmount, LocalDateTime timestamp) {
        BigDecimal currentBalance = walletTokenBalanceMapper.getLatestBalance(contractAddress, timestamp);
        return currentBalance != null && currentBalance.compareTo(requiredAmount) >= 0;
    }

    /**
     * 根据交易类型生成交易地址
     */
    private String[] generateAddresses(TransactionType type, String walletAddress, String contractAddress) {
        String fromAddress;
        String toAddress;
        
        switch (type) {
            case DEPOSIT:
                // 存款：从0地址转入
                fromAddress = ZERO_ADDRESS;
                toAddress = walletAddress;
                break;
                
            case WITHDRAW:
                // 提取：转到销毁地址
                fromAddress = walletAddress;
                toAddress = BURN_ADDRESS;
                break;
                
            case STAKE:
                // 质押：转到质押合约
                fromAddress = STAKE_ADDRESS;
                toAddress = walletAddress;
                break;
                
            case COLLATERAL:
                // 抵押：转到抵押合约
                fromAddress = walletAddress;
                toAddress = COLLATERAL_ADDRESS;
                break;
                
            case SWAP:
                // 交换：用户地址之间转账
                fromAddress = walletAddress;
                toAddress = generateRandomAddress();
                break;
                
            default:
                throw new IllegalArgumentException("未支持的交易类型: " + type.name());
        }
        
        return new String[]{fromAddress, toAddress};
    }

    /**
     * 生成随机地址
     */
    private String generateRandomAddress() {
        StringBuilder sb = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < 40; i++) {
            sb.append(String.format("%x", random.nextInt(16)));
        }
        return sb.toString();
    }

    public void createTransferRecord(TransactionReq transactionReq) {
        // 获取最接近的区块信息
        Block nearestBlock = getNearestBlock(transactionReq.getTimestamp());

        // 根据交易类型生成地址
        String[] addresses = generateAddresses(
            transactionReq.getTransactionType(),
            transactionReq.getWalletAddress(),
            transactionReq.getTokenContractAddressHash()
        );
        String fromAddress = addresses[0];
        String toAddress = addresses[1];

        // 模拟生成交易哈希
        String transactionHash = generateTransactionHash();

        // 创建交易记录
        SimulatedTokenTransfer transaction = new SimulatedTokenTransfer();
        transaction.setFromAddressHash(fromAddress.replace("0x",""));
        transaction.setToAddressHash(toAddress.replace("0x",""));
        transaction.setTransactionHash(transactionHash.replace("0x",""));
        transaction.setBlockNumber(nearestBlock.getNumber());  // 使用最接近区块的 block_number
        LocalDateTime localDateTime = LocalDateTime.ofInstant(Instant.ofEpochSecond(transactionReq.getTimestamp()), ZoneId.systemDefault());
        transaction.setTimestamp(localDateTime); // 使用提供的交易时间戳
        transaction.setAmount(transactionReq.getAmount());  // 设置交易金额
        transaction.setTokenContractAddressHash(transactionReq.getTokenContractAddressHash().replace("0x",""));
        transaction.setDatasource("simulated");  // 设置数据来源

        // 更新钱包余额
        BigDecimal amount = transactionReq.getAmount();
        String tokenAddress = transactionReq.getTokenContractAddressHash();

        // 计算手续费
        BigDecimal transactionFee = calculateTransactionFee();
        BigDecimal tokenPrice = walletBalanceService.getTokenPrice(tokenAddress);
        BigDecimal divide = transactionFee.divide(tokenPrice, RoundingMode.CEILING);

        if (fromAddress.equals(transactionReq.getWalletAddress())) {
            // 如果钱包是发送方，检查余额
            // 检查代币余额是否足够
            boolean b = checkBalance(tokenAddress, amount.add(divide), localDateTime);
            if(b){
                // 余额充足，执行转账
                walletBalanceService.updateBalance(tokenAddress, amount.negate(), localDateTime);

                // 扣除交易手续费
                walletBalanceService.updateBalance(tokenAddress, divide.negate(), localDateTime);
            }

        } else {
            // 如果钱包是接收方，直接更新余额
            walletBalanceService.updateBalance(
                transactionReq.getTokenContractAddressHash(),
                amount,
                localDateTime
            );
        }

        // 插入交易记录
        simulatedTokenTransferMapper.insertOne(transaction);
    }

    /**
     * 充值代币
     * @param contractAddress 目标代币合约地址
     * @param usdtAmount USDT金额
     */
    public void depositToken(String contractAddress, BigDecimal usdtAmount) {
        LocalDateTime now = LocalDateTime.now();

        // 获取目标代币当前价格
        BigDecimal tokenPrice = walletBalanceService.getTokenPrice(contractAddress);
        if (tokenPrice == null || tokenPrice.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("无法获取代币价格");
        }

        // 计算可以购买的代币数量：USDT金额 / 代币单价
        BigDecimal tokenAmount = usdtAmount.divide(tokenPrice, 18, RoundingMode.HALF_DOWN);

        // 构造交易请求
        TransactionReq transactionReq = new TransactionReq();
        transactionReq.setWalletAddress("0xbD91c50fA38B515009C11B1f3e900a75A2C025a9");
        transactionReq.setTokenContractAddressHash(contractAddress);
        transactionReq.setAmount(tokenAmount);
        transactionReq.setTimestamp(Instant.now().getEpochSecond());
        transactionReq.setTransactionType(TransactionType.DEPOSIT);

        // 1. 创建交易记录
        createTransferRecord(transactionReq);
    }

    public Block getNearestBlock(long timestamp) {
        // 将时间戳转换为 "yyyy-MM-dd HH:mm:ss" 格式的字符串
        String timestampStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(timestamp * 1000));
        return blocksMapper.getNearestBlock(timestampStr);  // 查询最接近的区块
    }

    private String generateTransactionHash() {
        // 生成模拟的交易哈希
        return UUID.randomUUID().toString().replace("-", "");
    }
}