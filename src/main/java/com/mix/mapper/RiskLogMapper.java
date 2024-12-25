package com.mix.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mix.entity.dto.RiskLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface RiskLogMapper extends BaseMapper<RiskLog> {

    @Select("WITH monthly_counts AS (\n" +
            "            SELECT \n" +
            "                DATE_TRUNC('month', log_time) AS month, \n" +
            "                risk_name, \n" +
            "                COUNT(*) AS risk_count\n" +
            "            FROM \n" +
            "                risk_log\n" +
            "            WHERE \n" +
            "                log_time >= (SELECT MAX(log_time) FROM risk_log) - INTERVAL '6 months'\n" +
            "            GROUP BY \n" +
            "                DATE_TRUNC('month', log_time), risk_name\n" +
            "        ),\n" +
            "        total_counts AS (\n" +
            "            SELECT \n" +
            "                month, \n" +
            "                SUM(risk_count) AS total_count\n" +
            "            FROM \n" +
            "                monthly_counts\n" +
            "            GROUP BY \n" +
            "                month\n" +
            "        )\n" +
            "        SELECT \n" +
            "            mc.month, \n" +
            "            mc.risk_name, \n" +
            "            mc.risk_count, \n" +
            "            ROUND((mc.risk_count::NUMERIC / tc.total_count) * 100, 2) AS risk_percentage\n" +
            "        FROM \n" +
            "            monthly_counts mc\n" +
            "        JOIN \n" +
            "            total_counts tc\n" +
            "        ON \n" +
            "            mc.month = tc.month\n" +
            "        ORDER BY \n" +
            "            mc.month DESC, mc.risk_name;")
    List<Map<String, Object>> getMonthlyRiskPercentages();

    /**
     * 分页查询风险日志
     *
     * @param page 分页参数对象（包含页码和每页大小）
     * @return 分页结果
     */
    @Select("SELECT * FROM risk_log ORDER BY log_time DESC")
    IPage<RiskLog> getPagedRisks(Page<RiskLog> page);
}
