package com.mix.entity;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Setter
@Getter
public class TreeNode {
    // Getter 和 Setter
    private String category; // 分类名称
    private List<TreeNode> children; // 子分类节点

    public TreeNode(String category, List<TreeNode> children) {
        this.category = category;
        this.children = children;
    }

}
