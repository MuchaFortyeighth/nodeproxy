package com.mix.service;

import com.baomidou.mybatisplus.core.toolkit.IdWorker;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.mix.entity.*;
import com.mix.entity.dto.Block;
import com.mix.entity.dto.MarketParam;
import com.mix.entity.dto.RiskLog;
import com.mix.entity.dto.SimulatedTokenTransfer;
import com.mix.mapper.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.concurrent.*;
import java.util.stream.Collectors;

@Slf4j
@Service
public class SimulatedTransationService extends ServiceImpl<MarketParamMapper, MarketParam> {
    private static final long BASE_TIME = 1640995200L; // 2022-01-01 00:00:00 UTC
    private final Random random = new Random();

    @Autowired
    DefiContractMapper defiContractMapper;

    @Autowired
    RiskLogMapper riskLogMapper;

    @Autowired
    MarketParamMapper marketParamMapper;

    @Autowired
    RiskAssessmentResultMapper assessmentResultMapper;

    @Autowired
    private SimulatedTokenTransferMapper simulatedTokenTransferMapper;

    @Autowired
    private TokenTransferService tokenTransferService;

    private final ScheduledExecutorService executorService = Executors.newSingleThreadScheduledExecutor();
    private final ConcurrentHashMap<String, MarketParam> paramCache = new ConcurrentHashMap<>();
    private ScheduledFuture<?> scheduledTask;


    @Autowired
    private CacheManager cacheManager;

    /**
     * 生成随机交易数据并缓存
     *
     * @param startTimestamp 秒时间戳
     * @param contractAddress Token 合约地址
     * @return UUID（缓存 Key）
     */
    public Map<String,Object> generateSimulatedTransactions(long startTimestamp, String contractAddress) {
        HashMap<String, Object> result = new HashMap<>();
        String uuid = IdWorker.get32UUID(); // 生成 UUID
        result.put("uuid",uuid);
        List<SimulatedTokenTransfer> transactions = generateRandomTransactions(startTimestamp, contractAddress);
        List<AgentTransactionResponse> responseList = new ArrayList<>(transactions.size());
        for (SimulatedTokenTransfer transaction : transactions) {
            AgentTransactionResponse response = AgentTransactionResponse.builder()
                    .token(defiContractMapper.getNameByAddress("0x"+transaction.getTokenContractAddressHash()))
                    .balance(transaction.getAmount().doubleValue() * random.nextDouble() * 100)
                    .fromAddress("0x" + transaction.getFromAddressHash())
                    .toAddress("0x" + transaction.getToAddressHash())
                    .txHash("0x" + transaction.getTransactionHash())
                    .transAmount(transaction.getAmount().doubleValue())
                    .time(transaction.getTimestamp()).build();
            responseList.add(response);
        }
        result.put("list",responseList);
        // 获取缓存实例并保存数据
        Cache cache = cacheManager.getCache("simulatedTransactions");
        if (cache != null) {
            cache.put(uuid, transactions);
        } else {
            log.warn("Cache 'simulatedTransactions' not found.");
        }

        return result;
    }

    /**
     * 从缓存中获取交易数据
     *
     * @param uuid 缓存 Key
     * @return 交易数据列表
     */
    public List<SimulatedTokenTransfer> getTransactionsFromCache(String uuid) {
        Cache cache = cacheManager.getCache("simulatedTransactions");
        if (cache != null) {
            Cache.ValueWrapper wrapper = cache.get(uuid);
            if (wrapper != null) {
                return (List<SimulatedTokenTransfer>) wrapper.get();
            }
        } else {
            log.warn("Cache 'simulatedTransactions' not found.");
        }
        return null;
    }

    /**
     * 确认交易并存储到数据库中
     *
     * @param uuid 缓存 Key
     * @return 成功存储的记录数
     */
    public int confirmTransactions(String uuid) {
        List<SimulatedTokenTransfer> transactions = getTransactionsFromCache(uuid);
        if (transactions == null || transactions.isEmpty()) {
            throw new RuntimeException("Transaction data expired or invalid UUID.");
        }

        for (SimulatedTokenTransfer transaction : transactions) {
            simulatedTokenTransferMapper.insertOne(transaction);
        }

        // 清除缓存
        clearTransactionCache(uuid);
        return transactions.size();
    }

    /**
     * 清除缓存
     *
     * @param uuid 缓存 Key
     */
    public void clearTransactionCache(String uuid) {
        Cache cache = cacheManager.getCache("simulatedTransactions");
        if (cache != null) {
            cache.evict(uuid);
        } else {
            log.warn("Cache 'simulatedTransactions' not found.");
        }
    }

    /**
     * 生成随机交易数据并缓存
     *
     * @param startTimestamp 秒时间戳
     * @param contractAddress Token 合约地址
     * @return UUID（缓存 Key）
     */
    @CachePut(value = "simulatedTransactions", key = "#uuid")
    public List<SimulatedTokenTransfer> generateRandomTransactions(long startTimestamp, String contractAddress) {
        // 生成随机交易数据
        List<SimulatedTokenTransfer> transactions = new ArrayList<>();
        LocalDateTime startTime = LocalDateTime.ofInstant(Instant.ofEpochSecond(startTimestamp), ZoneId.systemDefault());
        MarketParam marketParam = generateParameters(startTimestamp, contractAddress);
        for (int i = 0; i < random.nextInt(7) + 3; i++) { // 随机生成 1~10 条数据
            SimulatedTokenTransfer transaction = new SimulatedTokenTransfer();
            transaction.setFromAddressHash(generateRandomAddress().replace("0x",""));
            transaction.setToAddressHash(generateRandomAddress().replace("0x",""));
            transaction.setTransactionHash(IdWorker.get32UUID().replace("0x",""));
            LocalDateTime localDateTime = startTime.plusSeconds(random.nextInt(600));//时间随机分布在 10 分钟内
            Block nearestBlock = tokenTransferService.getNearestBlock(localDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli());
            transaction.setBlockNumber(nearestBlock.getNumber());
            transaction.setTimestamp(LocalDateTime.ofInstant(Instant.ofEpochMilli(nearestBlock.getTimestamp().getTime()), ZoneId.systemDefault()));
            transaction.setAmount(BigDecimal.valueOf(random.nextDouble() * marketParam.getPoolBalance()/1000000));
            transaction.setTokenContractAddressHash(contractAddress.replace("0x",""));
            transaction.setDatasource("agent");
            transactions.add(transaction);
        }

        // 缓存数据
        return transactions;
    }


    /**
     * 生成随机地址（42 位的以太坊地址）
     */
    private String generateRandomAddress() {
        StringBuilder address = new StringBuilder("0x");
        for (int i = 0; i < 40; i++) {
            address.append(Integer.toHexString(random.nextInt(16)));
        }
        return address.toString();
    }

    public RiskAssessmentResult getRisk(String contractAddress) {
        return assessmentResultMapper.findByContractAddress(contractAddress);
    }

    public RiskAssessmentResult assessRisk(MarketParam marketParam) {
        log.info("Assessing risk for MarketParam: {}", marketParam);
        ArrayList<String> desList = new ArrayList<>();
        int riskScore = 0;
        List<RiskDetail> details = new ArrayList<>();
        long poolBalance = generateParameters(marketParam.getTransactionTime(), marketParam.getContractAddress()).getPoolBalance();

        log.info("Generated pool balance: {} for contract address: {}", poolBalance, marketParam.getContractAddress());

        if (marketParam.getPoolBalance() < poolBalance * 0.4) {
            riskScore += 3;
            desList.add(RiskType.LIQUIDITY_LOW.getName());
            details.add(new RiskDetail(true, RiskType.LIQUIDITY_LOW.getName(), RiskType.LIQUIDITY_LOW.getDescription()));
        } else {
            details.add(new RiskDetail(false, RiskType.LIQUIDITY_GOOD.getName(), RiskType.LIQUIDITY_GOOD.getDescription()));
        }

        if (marketParam.getMarketVolatility() > 60) {
            riskScore += 4;
            desList.add(RiskType.MARKET_VOLATILITY_HIGH.getName());
            details.add(new RiskDetail(true, RiskType.MARKET_VOLATILITY_HIGH.getName(), RiskType.MARKET_VOLATILITY_HIGH.getDescription()));
        } else if (marketParam.getMarketVolatility() < 20) {
            riskScore += 2;
            desList.add(RiskType.MARKET_VOLATILITY_LOW.getName());
            details.add(new RiskDetail(true, RiskType.MARKET_VOLATILITY_LOW.getName(), RiskType.MARKET_VOLATILITY_LOW.getDescription()));
        } else {
            details.add(new RiskDetail(false, RiskType.MARKET_VOLATILITY_GOOD.getName(), RiskType.MARKET_VOLATILITY_GOOD.getDescription()));
        }

        if (marketParam.getSlippage() > 5.0) {
            riskScore += 3;
            desList.add(RiskType.SLIPPAGE_HIGH.getName());
            details.add(new RiskDetail(true, RiskType.SLIPPAGE_HIGH.getName(), RiskType.SLIPPAGE_HIGH.getDescription()));
        } else {
            details.add(new RiskDetail(false, RiskType.SLIPPAGE_LOW.getName(), RiskType.SLIPPAGE_LOW.getDescription()));
        }

        if (marketParam.getAnnualizedRate() > 20.0) {
            riskScore += 2;
            desList.add(RiskType.HIGH_YIELD.getName());
            details.add(new RiskDetail(true, RiskType.HIGH_YIELD.getName(), RiskType.HIGH_YIELD.getDescription()));
        } else if (marketParam.getAnnualizedRate() < 2.0) {
            riskScore += 1;
            desList.add(RiskType.LOW_YIELD.getName());
            details.add(new RiskDetail(true, RiskType.LOW_YIELD.getName(), RiskType.LOW_YIELD.getDescription()));
        } else {
            details.add(new RiskDetail(false, RiskType.YIELD_GOOD.getName(), RiskType.YIELD_GOOD.getDescription()));
        }

        RiskLevel riskLevel;
        if (riskScore >= 10) {
            riskLevel = RiskLevel.CRITICAL;
        } else if (riskScore >= 6) {
            riskLevel = RiskLevel.HIGH;
        } else if (riskScore >= 3) {
            riskLevel = RiskLevel.MEDIUM;
        } else {
            riskLevel = RiskLevel.LOW;
        }

        log.info("Risk assessment complete. Level: {}, Score: {}, Details: {}", riskLevel, riskScore, details);
        return new RiskAssessmentResult(
                marketParam.getContractAddress()
                ,riskLevel
                ,String.join(",", desList)
                ,details);
    }

    public void saveOrUpdateContractParams(MarketParam param) {
        log.info("Received request to save or update MarketParam: {}", param);
        String contractAddress = param.getContractAddress();

        paramCache.put(contractAddress, param);

        if (scheduledTask != null && !scheduledTask.isDone()) {
            scheduledTask.cancel(false);
        }

        scheduledTask = executorService.schedule(() -> {
            MarketParam cachedParam = paramCache.remove(contractAddress);
            if (cachedParam != null) {
                try {
                    executeSaveOrUpdate(cachedParam);
                } catch (Exception e) {
                    log.error("saveOrUpdateContractParams error",e);
                }

            }
        }, 10, TimeUnit.SECONDS);

        log.info("Scheduled task to save or update MarketParam: {}", param);
    }

    public void executeSaveOrUpdate(MarketParam param) {
        log.info("Executing save or update for MarketParam: {}", param);
        RiskAssessmentResult riskAssessmentResult = assessRisk(param);
        assessmentResultMapper.saveOrUpdate(riskAssessmentResult);
        this.saveOrUpdate(param);
        for (RiskDetail detail : riskAssessmentResult.getDetails()) {
            if (detail.isDangers()) {
                RiskLog riskLog = new RiskLog();
                riskLog.setRiskName(detail.getRiskName());
                riskLog.setContractAddress(param.getContractAddress());
                riskLog.setLogTime(LocalDateTime.ofInstant(
                        Instant.ofEpochSecond(param.getTransactionTime()),
                        ZoneId.systemDefault()
                ));
                riskLog.setContractName(defiContractMapper.getNameByAddress(
                        param.getContractAddress()
                ));
                riskLogMapper.insert(riskLog);
                log.info("Inserted RiskLog: {}", riskLog);
            }
        }
    }

    public void resetRisk(String contractAddress) {
        log.info("Resetting risk data for contract address: {}", contractAddress);
        marketParamMapper.deleteById(contractAddress);
        assessmentResultMapper.deleteById(contractAddress);
        log.info("Risk data reset complete for contract address: {}", contractAddress);
    }

    public MarketParam generateParameters(long timeInput, String contractAddress) {
        log.info("Generating parameters for contractAddress: {}, timeInput: {}", contractAddress, timeInput);
        MarketParam marketParam = marketParamMapper.selectById(contractAddress);
        if (marketParam != null) {
            log.info("MarketParam found in database: {}", marketParam);
            return marketParam;
        }

        String seedString = timeInput + contractAddress;
        long seed = generateSeed(seedString);
        Random random = new Random(seed);

        long timeDiff = Math.abs(timeInput - BASE_TIME);
        double volatilityFactor = (timeDiff % 10) / 100.0;

        MarketParam params = new MarketParam();
        params.setAnnualizedRate(random.nextDouble() * 15);
        params.setPoolBalance(generateBalance(contractAddress, timeDiff));
        params.setMarketVolatility(10 + random.nextInt(31));
        params.setSlippage(random.nextDouble());

        log.info("Generated parameters: {}", params);
        return params;
    }

    private long generateBalance(String contractAddress, long timeDiff) {
        long contractHash = generateContractHash(contractAddress);
        long poolBalance = (contractHash % (7000000 - 10000)) + 10000;
        long timeAdjustedBalance = (timeDiff % 10000);
        poolBalance = poolBalance + timeAdjustedBalance;
        log.info("Generated balance: {} for contractAddress: {}", poolBalance, contractAddress);
        return poolBalance;
    }

    private static long generateSeed(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(input.getBytes());
            long seed = 0;
            for (int i = 0; i < Math.min(hash.length, 8); i++) {
                seed = (seed << 8) | (hash[i] & 0xFF);
            }
            return seed;
        } catch (NoSuchAlgorithmException e) {
            log.error("Error generating seed: {}", e.getMessage());
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }

    private static long generateContractHash(String contractAddress) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(contractAddress.getBytes());
            long hashValue = 0;
            for (int i = 0; i < Math.min(hash.length, 8); i++) {
                hashValue = (hashValue << 8) | (hash[i] & 0xFF);
            }
            return hashValue;
        } catch (NoSuchAlgorithmException e) {
            log.error("Error generating contract hash: {}", e.getMessage());
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }
}
