package com.mix.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.FileSystemUtils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

@Slf4j
@Service
public class SolcCompilerService {
    
    private static final String SOLC_JS_PATH = "./solc-js";

    public String generateAst(String sourceCode, String compilerVersion) throws IOException {
        // 创建工作目录
        File workDir = new File(SOLC_JS_PATH);
        if (!workDir.exists()) {
            workDir.mkdirs();
        }

        // 创建package.json
        createPackageJson(workDir);
        
        // 创建临时合约文件
        File contractFile = new File(workDir, "Contract.sol");
        try (FileWriter writer = new FileWriter(contractFile)) {
            writer.write(sourceCode);
        }

        // 创建编译脚本
        createCompileScript(workDir, compilerVersion);

        // 执行编译
        Process process = Runtime.getRuntime().exec("node compile.js", null, workDir);
        
        try {
            process.waitFor();
            // 读取生成的AST文件
            String ast = Files.readString(Path.of(workDir.getPath(), "ast.json"));
            
            // 清理临时文件
            cleanupFiles(workDir);
            
            return ast;
        } catch (InterruptedException e) {
            throw new RuntimeException("Compilation interrupted", e);
        }
    }

    private void createPackageJson(File workDir) throws IOException {
        String packageJson = """
            {
              "dependencies": {
                "solc": "^0.6.12"
              }
            }
            """;
        
        try (FileWriter writer = new FileWriter(new File(workDir, "package.json"))) {
            writer.write(packageJson);
        }
        
        // 执行 npm install
        Process process = Runtime.getRuntime().exec("npm install", null, workDir);
        try {
            process.waitFor();
        } catch (InterruptedException e) {
            throw new RuntimeException("npm install failed", e);
        }
    }

    private void createCompileScript(File workDir, String compilerVersion) throws IOException {
        String script = """
            const solc = require('solc');
            const fs = require('fs');
            const path = require('path');
            
            // 读取合约文件
            const contractPath = path.resolve(__dirname, 'Contract.sol');
            const sourceCode = fs.readFileSync(contractPath, 'utf8');
            
            // 准备编译输入
            const input = {
                language: 'Solidity',
                sources: {
                    'Contract.sol': {
                        content: sourceCode
                    }
                },
                settings: {
                    outputSelection: {
                        '*': {
                            '*': ['ast']
                        }
                    }
                }
            };
            
            // 加载指定版本的编译器
            solc.loadRemoteVersion('%s', function(err, solcSnapshot) {
                if (err) {
                    console.error(err);
                    return;
                }
                
                // 编译合约
                const output = JSON.parse(solcSnapshot.compile(JSON.stringify(input)));
                
                // 保存AST
                fs.writeFileSync('ast.json', JSON.stringify(output, null, 2));
            });
            """.formatted(compilerVersion);

        try (FileWriter writer = new FileWriter(new File(workDir, "compile.js"))) {
            writer.write(script);
        }
    }

    private void cleanupFiles(File workDir) {
        try {
            FileSystemUtils.deleteRecursively(workDir);
        } catch (IOException e) {
            log.warn("Failed to cleanup temporary files", e);
        }
    }
} 