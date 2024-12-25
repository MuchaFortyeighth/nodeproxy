package com.mix.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mix.entity.Result;
import com.mix.entity.dto.DefiContract;
import com.mix.service.DefiManageService;
import com.mix.service.VulnerabilityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/defiContracts")
public class DefiManageController {
    @Autowired
    private DefiManageService defiManageService;

    @Autowired
    private VulnerabilityService vulnerabilityService;

    /**
     * 分页查询合约列表，并根据一级分类和二级分类进行过滤
     * 请求示例：/defiContracts/page/1/10/category1/category2
     *
     * @param current 当前页码
     * @param size 每页大小
     * @param primaryCategory 一级分类
     * @param secondaryCategory 二级分类
     * @return 分页结果
     */
    @GetMapping("/page/{current}/{size}/{primaryCategory}/{secondaryCategory}")
    public Result getContractPage(
            @PathVariable int current,
            @PathVariable int size,
            @PathVariable String primaryCategory,
            @PathVariable String secondaryCategory) {
        return Result.success(defiManageService
                .getContractPageWithCategories(current, size, primaryCategory, secondaryCategory));
    }

    /**
     * 根据合约名称模糊查询
     * @param input 合约名称
     * @return 查询到的合约列表
     */
    @GetMapping("/searchByName/{input}")
    public Result searchContractsByName(@PathVariable String input) {
        return Result.success(defiManageService.getContractsByNameLike(input));
    }

    /**
     * 返回整体的分类树状结构
     * 请求路径示例：GET /categories/tree
     *
     * @return 分类树状结构
     */
    @GetMapping("/categories/tree")
    public Result getCategoryTree() {
        return Result.success(defiManageService.getCategoryTree());
    }

    @GetMapping("/code-scan/{contractAddress}")
    public Result getVulnerabilityDetails(@PathVariable String contractAddress) {
        return Result.success(vulnerabilityService.getDefiContractVulnerabilityDetails(contractAddress));
    }
}
