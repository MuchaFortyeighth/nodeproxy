package com.mix.controller;

import com.mix.entity.Result;
import com.mix.entity.SupportedTokens;
import com.mix.entity.dto.ContractRelationship;
import com.mix.entity.dto.MarketParam;
import com.mix.service.ContractRelationshipService;
import com.mix.service.MarketChartService;
import com.mix.service.SimulatedTransationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/market")
public class MarketController {

    @Autowired
    SimulatedTransationService simulatedTransationService;

    @Autowired
    MarketChartService marketChartService;

    @Autowired
    private ContractRelationshipService contractRelationshipService;

    @GetMapping("/getRisk/{contractAddress}")
    public Result getRisk(@PathVariable String contractAddress){
        return Result.success(simulatedTransationService.getRisk(contractAddress));
    }

    @GetMapping("/getParam/{timestamp}/{contractAddress}")
    public Result searchContractsByName(@PathVariable Long timestamp,@PathVariable String contractAddress) {
        return Result.success(simulatedTransationService.generateParameters(timestamp,contractAddress));
    }

    @PostMapping("/setParam/{contractAddress}")
    public Result setParameters(@PathVariable String contractAddress,@RequestBody MarketParam param) {
        param.setContractAddress(contractAddress);
        simulatedTransationService.saveOrUpdateContractParams(param);
        return Result.success();
    }

    @PostMapping("/reset/{contractAddress}")
    public Result reset(@PathVariable String contractAddress) {
        simulatedTransationService.resetRisk(contractAddress);
        return Result.success();
    }

    @GetMapping("/monthly/risk/percentages")
    public Result getMonthlyRiskPercentages() {
        return Result.success(marketChartService.getMonthlyRiskPercentages());
    }


    @GetMapping("/riskLog/page/{current}/{size}")
    public Result getRisk(@PathVariable Integer current,@PathVariable Integer size){
        return Result.success(marketChartService.getPagedRisks(current,size));
    }


    /**
     * 添加合约关联关系
     */
    @PostMapping("/relation/add/{sourceContract}/{targetContract}/{token}")
    public Result addRelationship(
            @PathVariable String sourceContract,
            @PathVariable String targetContract,
            @PathVariable String token) {
        contractRelationshipService.addRelationship(sourceContract, targetContract, token);
        return Result.success("Relationship added successfully.");
    }

    /**
     * 查询某个合约的所有关联关系
     */
    @GetMapping("/relation/get/{sourceContract}")
    public Result getRelationships(@PathVariable String sourceContract) {
        return Result.success( contractRelationshipService.getRelationships(sourceContract));
    }

    /**
     * 删除合约关联关系
     */
    @PostMapping("/relation/delete/{sourceContract}/{targetContract}/{token}")
    public Result deleteRelationship(
            @PathVariable String sourceContract,
            @PathVariable String targetContract,
            @PathVariable String token) {
        contractRelationshipService.deleteRelationship(sourceContract, targetContract, token);
        return Result.success("Relationship deleted successfully.");
    }

    @GetMapping("/relationTokens")
    public Result getAllSupportedTokens() {
        List<Map<String, String>> tokens = Arrays.stream(SupportedTokens.values())
                .map(token -> {
                    Map<String, String> map = new HashMap<>();
                    map.put("symbol", token.getSymbol());
                    map.put("name", token.getName());
                    map.put("type", token.getType());
                    return map;
                })
                .collect(Collectors.toList());
        return Result.success(tokens);
    }
}
