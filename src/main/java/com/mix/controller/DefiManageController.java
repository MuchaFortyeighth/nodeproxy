package com.mix.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mix.entity.Result;
import com.mix.entity.ResultCode;
import com.mix.entity.dto.DefiContract;
import com.mix.entity.req.ContractImportRequest;
import com.mix.service.DefiManageService;
import com.mix.service.VulnerabilityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Objects;

@RestController
@RequestMapping("/defiContracts")
public class DefiManageController {
    @Autowired
    private DefiManageService defiManageService;

    @Autowired
    private VulnerabilityService vulnerabilityService;

    @PostMapping("/import")
    @ResponseBody
    public Result importContract(
            @RequestParam("file") MultipartFile sourceFile,
            @RequestParam(value = "logo", required = false) MultipartFile logoFile,
            @RequestParam("compilerVersion") String compilerVersion,
            @RequestParam("contractName") String contractName,
            @RequestParam("contractAddress") String contractAddress,
            @RequestParam("primaryCategory") String primaryCategory,
            @RequestParam("secondaryCategory") String secondaryCategory) throws IOException {


        // 验证合约文件
        if (!Objects.requireNonNull(sourceFile.getOriginalFilename()).endsWith(".sol")) {
            return Result.failed(ResultCode.INVALID_PARAM);
        }

        // 验证logo文件
        if (logoFile != null && !logoFile.isEmpty()) {
            if (!isValidLogoFile(logoFile)) {
                return Result.failed(ResultCode.INVALID_PARAM);
            }
            // 保存logo文件
            saveLogo(logoFile, contractAddress);
        }

        // 处理合约文件
        String sourceCode = new String(sourceFile.getBytes(), StandardCharsets.UTF_8);
        ContractImportRequest request = new ContractImportRequest();
        request.setSourceCode(sourceCode);
        request.setCompilerVersion(compilerVersion);
        request.setContractName(contractName);
        request.setContractAddress(contractAddress);
        request.setPrimaryCategory(primaryCategory);
        request.setSecondaryCategory(secondaryCategory);

        DefiContract contract = defiManageService.importContract(request);
        return Result.success();
    }

    @PostMapping("/delete/{contractAddress}")
    public Result delete(@PathVariable String contractAddress){
        return Result.success(defiManageService.deleteContract(contractAddress));
    }

    private boolean isValidLogoFile(MultipartFile file) {
        String contentType = file.getContentType();
        return contentType != null && contentType.equals("image/webp");
    }

    private void saveLogo(MultipartFile file, String contractAddress) throws IOException {
        File uploadDir = new File("contract-logos");
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String fileName = contractAddress + ".webp";
        Path destinationPath = Paths.get(uploadDir.getPath(), fileName);
        file.transferTo(destinationPath);
    }

    private boolean isValidCompilerVersion(String version) {
        return version.matches("v\\d+\\.\\d+\\.\\d+\\+commit\\.[a-f0-9]+");
    }


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

    @GetMapping(
        value = "/code-scan/{contractAddress}",
        produces = "application/json;charset=UTF-8"
    )
    @ResponseBody
    public Result getVulnerabilityDetails(@PathVariable String contractAddress) {
        return Result.success(vulnerabilityService.getDefiContractVulnerabilityDetails(contractAddress));
    }
}
