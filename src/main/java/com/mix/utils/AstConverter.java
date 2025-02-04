package com.mix.utils;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.util.Iterator;

public class AstConverter {
    
    /**
     * 将现代Solidity AST转换为legacy格式
     */
    public static JsonNode convertToLegacyAst(JsonNode modernAst) {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode legacyNode = mapper.createObjectNode();
        
        // 从根节点开始递归转换
        return mapNode(modernAst);
    }

    private static JsonNode mapNode(JsonNode node) {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode legacyNode = mapper.createObjectNode();

        // 设置基本结构
        legacyNode.put("name", node.path("nodeType").asText(""));
        
        // 创建attributes对象
        ObjectNode attributes = mapper.createObjectNode();
        Iterator<String> fieldNames = node.fieldNames();
        while (fieldNames.hasNext()) {
            String key = fieldNames.next();
            // 跳过特殊字段
            if (!key.equals("nodeType") && !key.equals("nodes") && !key.equals("children")) {
                JsonNode value = node.get(key);
                // 如果值是对象,转换为字符串
                if (value.isObject()) {
                    attributes.put(key, value.toString());
                } else {
                    attributes.set(key, value);
                }
            }
        }
        legacyNode.set("attributes", attributes);

        // 处理子节点
        ArrayNode children = mapper.createArrayNode();
        // 处理 "nodes" 字段
        if (node.has("nodes")) {
            node.get("nodes").forEach(child -> children.add(mapNode(child)));
        }
        // 处理 "children" 字段
        if (node.has("children")) {
            node.get("children").forEach(child -> children.add(mapNode(child)));
        }
        legacyNode.set("children", children);

        return legacyNode;
    }
} 