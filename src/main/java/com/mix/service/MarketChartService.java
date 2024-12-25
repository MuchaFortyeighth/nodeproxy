package com.mix.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mix.entity.dto.RiskLog;
import com.mix.mapper.RiskLogMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class MarketChartService {

    @Autowired
    RiskLogMapper riskLogMapper;

    public List<Map<String, Object>> getMonthlyRiskPercentages() {
        List<Map<String, Object>> rawData = riskLogMapper.getMonthlyRiskPercentages();
        Map<String, Map<String, Object>> groupedData = new LinkedHashMap<>();

        for (Map<String, Object> row : rawData) {
            String month = row.get("month").toString();
            String riskName = row.get("risk_name").toString();
            int count = ((Number) row.get("risk_count")).intValue();
            double percentage = ((Number) row.get("risk_percentage")).doubleValue();

            // 确保 month 对应的 Map 已初始化
            groupedData.computeIfAbsent(month, k -> {
                Map<String, Object> newMonthEntry = new LinkedHashMap<>();
                newMonthEntry.put("month", month);
                newMonthEntry.put("risks", new ArrayList<Map<String, Object>>());
                return newMonthEntry;
            });

            // 获取 risks 列表，并安全地添加数据
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> risks = (List<Map<String, Object>>) groupedData.get(month).get("risks");

            Map<String, Object> riskData = new LinkedHashMap<>();
            riskData.put("risk_name", riskName);
            riskData.put("count", count);
            riskData.put("percentage", percentage);

            risks.add(riskData);
        }

        return new ArrayList<>(groupedData.values());
    }


    // 分页查询风险日志
    public IPage<RiskLog> getPagedRisks(int pageNumber, int pageSize) {
        Page<RiskLog> page = new Page<>(pageNumber, pageSize); // 创建分页对象
        return riskLogMapper.getPagedRisks(page);
    }

}
