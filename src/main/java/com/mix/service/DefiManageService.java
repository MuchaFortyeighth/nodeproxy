package com.mix.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mix.entity.PrimaryCategory;
import com.mix.entity.SecondaryCategory;
import com.mix.entity.TreeNode;
import com.mix.entity.dto.ContractRelationship;
import com.mix.entity.dto.DefiContract;
import com.mix.mapper.ContractRelationshipsMapper;
import com.mix.mapper.DefiContractMapper;
import com.mix.entity.req.ContractImportRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.io.IOException;

@Slf4j
@Service
public class DefiManageService {
    @Autowired
    private DefiContractMapper defiContractMapper;
    
    @Autowired
    private SolcCompilerService solcCompilerService;

    @Autowired
    private ContractRelationshipsMapper contractRelationshipsMapper;

    /**
     * 返回整体的树状结构，按一级分类和二级分类组织
     *
     * @return 树状结构的根节点列表
     */
    public List<TreeNode> getCategoryTree() {
        List<TreeNode> tree = new ArrayList<>();

        // 遍历一级分类，构建树结构
        for (PrimaryCategory primaryCategory : PrimaryCategory.values()) {
            List<TreeNode> children = new ArrayList<>();

            // 查找该一级分类下的所有二级分类
            for (SecondaryCategory secondaryCategory : SecondaryCategory.values()) {
                if (secondaryCategory.getPrimaryCategory() == primaryCategory) {
                    // 创建每个二级分类的树节点
                    children.add(new TreeNode(secondaryCategory.getCategory(), new ArrayList<>()));
                }
            }

            // 创建一级分类的树节点，包含二级分类节点
            tree.add(new TreeNode(primaryCategory.getCategory(), children));
        }

        return tree;
    }

    /**
     * 分页查询合约列表，并根据一级分类和二级分类进行过滤
     *
     * @param current         当前页码
     * @param size            每页显示数量
     * @param primaryCategory 一级分类
     * @param secondaryCategory 二级分类
     * @return 分页结果
     */
    public Page<DefiContract> getContractPageWithCategories(int current, int size, String primaryCategory, String secondaryCategory) {
        Page<DefiContract> page = new Page<>(current, size);
        QueryWrapper<DefiContract> queryWrapper = new QueryWrapper<>();
        
        // 排除大字段
        queryWrapper.select(DefiContract.class, info -> 
            !info.getColumn().equals("source_code") && 
            !info.getColumn().equals("source_code_tree"));
        
        if (primaryCategory != null && !primaryCategory.isEmpty() && !primaryCategory.equals("all")) {
            queryWrapper.eq("primary_category", primaryCategory);
        }
        if (secondaryCategory != null && !secondaryCategory.isEmpty() && !secondaryCategory.equals("all")) {
            queryWrapper.eq("secondary_category", secondaryCategory);
        }

        return defiContractMapper.selectPage(page, queryWrapper);
    }

    /**
     * 根据合约名称模糊查询合约列表
     *
     * @param contractName 合约名称
     * @return 合约列表
     */
    public List<DefiContract> getContractsByNameLike(String contractName) {
        QueryWrapper<DefiContract> queryWrapper = new QueryWrapper<>();
        
        // 排除大字段
        queryWrapper.select(DefiContract.class, info -> 
            !info.getColumn().equals("source_code") && 
            !info.getColumn().equals("source_code_tree"));
            
        queryWrapper.like("contract_name", contractName);
        
        return defiContractMapper.selectList(queryWrapper);
    }

    /**
     * 根据合约地址获取源代码信息
     *
     * @param contractAddress 合约地址
     * @return 包含源代码的合约信息
     */
    public DefiContract getContractSourceCode(String contractAddress) {
        QueryWrapper<DefiContract> queryWrapper = new QueryWrapper<>();
        queryWrapper.select("contract_address", "source_code", "source_code_tree")
                   .eq("contract_address", contractAddress);
                   
        return defiContractMapper.selectOne(queryWrapper);
    }

    public DefiContract importContract(ContractImportRequest request) {
        try {
            // 生成AST
//            String ast = solcCompilerService.generateLegacyAst(
//                request.getSourceCode(),
//                request.getCompilerVersion()
//            );
            String ast = "";

            // 创建合约实体
            DefiContract contract = new DefiContract();
            contract.setContractAddress(request.getContractAddress());
            contract.setContractName(request.getContractName());
            contract.setSourceCode(request.getSourceCode());
            contract.setSourceCodeTree(ast);
            contract.setPrimaryCategory(request.getPrimaryCategory());
            contract.setSecondaryCategory(request.getSecondaryCategory());
            
            // 保存到数据库
            defiContractMapper.insert(contract);
            log.info("import contract success");
            return contract;
        } catch (Exception e) {
            log.error("Failed to import contract", e);
            throw new RuntimeException("Contract import failed", e);
        }
    }

    public boolean deleteContract(String contractAddress) {
        log.info("Deleting contract with address: {}", contractAddress);

        // 检查合约是否存在
        DefiContract existingContract = defiContractMapper.selectOne(
                new QueryWrapper<DefiContract>()
                        .eq("contract_address", contractAddress)
        );

        if (existingContract == null) {
            log.warn("Contract not found with address: {}", contractAddress);
            return false;
        }

        // 执行删除操作
        int result = defiContractMapper.delete(
                new QueryWrapper<DefiContract>()
                        .eq("contract_address", contractAddress)
        );

        contractRelationshipsMapper.delete(
                new QueryWrapper<ContractRelationship>()
                        .eq("source_contract_address", contractAddress)
        );
        contractRelationshipsMapper.delete(
                new QueryWrapper<ContractRelationship>()
                        .eq("target_contract_address", contractAddress)
        );

        boolean success = result > 0;
        if (success) {
            log.info("Successfully deleted contract with address: {}", contractAddress);
        } else {
            log.error("Failed to delete contract with address: {}", contractAddress);
        }

        return success;
    }
}
