package com.mix.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.FileSystemUtils;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import javax.annotation.PostConstruct;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mix.utils.AstConverter;

@Slf4j
@Service
public class SolcCompilerService {
    
    private static final String SOLC_JS_PATH = "./solc-js";
    private static final String SOLC_CACHE_PATH = "./solc-cache";
    private static boolean isInitialized = false;

    @PostConstruct
    public void init() {
        if (!isInitialized) {
            File cacheDir = new File(SOLC_CACHE_PATH);
            if (!cacheDir.exists()) {
                cacheDir.mkdirs();
            }

            File workDir = new File(SOLC_JS_PATH);
            if (!workDir.exists()) {
                workDir.mkdirs();
                try {
                    createPackageJson(workDir);
                    Process process = Runtime.getRuntime().exec("npm install", null, workDir);
                    process.waitFor();
                    isInitialized = true;
                } catch (Exception e) {
                    log.error("Failed to initialize solc compiler", e);
                }
            }
        }
    }

    private String readInputStream(InputStream inputStream) throws IOException {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))) {
            StringBuilder output = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }
            return output.toString();
        }
    }

    public String generateAst(String sourceCode, String compilerVersion) throws IOException {
        // 创建工作目录
        File workDir = new File(SOLC_JS_PATH);
        if (!workDir.exists()) {
            workDir.mkdirs();
        }

        log.info("Step 1: Creating temporary contract file");
        // 创建临时合约文件
        File contractFile = new File(workDir, "Contract.sol");
        try (FileWriter writer = new FileWriter(contractFile)) {
            writer.write(sourceCode);
        }

        log.info("Step 2: Creating compilation script");
        // 创建编译脚本
        createCompileScript(workDir, compilerVersion);
        boolean b = installDependencies(workDir);
        log.info("Step 3: Executing compilation script");
        // 执行编译
        Process process = Runtime.getRuntime().exec("node compile.js", null, workDir);

        // 创建日志读取线程
        Thread outputThread = new Thread(() -> {
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    log.info("Node output: {}", line);
                }
            } catch (IOException e) {
                log.error("Error reading process output", e);
            }
        });

        Thread errorThread = new Thread(() -> {
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getErrorStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    log.error("Node error: {}", line);
                }
            } catch (IOException e) {
                log.error("Error reading process error", e);
            }
        });

        // 启动日志读取线程
        outputThread.start();
        errorThread.start();

        try {
            log.info("Step 4: Waiting for compilation to complete");
            int exitCode = process.waitFor();

            // 等待日志线程完成
            outputThread.join();
            errorThread.join();

            if (exitCode != 0) {
                log.error("Compilation failed with exit code: {}", exitCode);
                throw new RuntimeException("Compilation failed with exit code: " + exitCode);
            }

            log.info("Step 5: Reading compilation result");
            // 读取生成的AST文件
            File astFile = new File(workDir, "ast.json");
            if (!astFile.exists()) {
                throw new RuntimeException("AST file not generated");
            }

            String ast = new String(Files.readAllBytes(Paths.get(workDir.getPath(), "ast.json")));

            log.info("Step 6: Cleaning up temporary files");
            // 清理临时文件
            cleanupFiles(workDir);

            return ast;
        } catch (InterruptedException e) {
            log.error("Compilation interrupted", e);
            throw new RuntimeException("Compilation interrupted", e);
        }
    }

    private boolean installDependencies(File workDir) {
        try {
            // 创建package.json
            createPackageJson(workDir);

            // 执行npm install
            log.info("Starting npm install in {}", workDir.getAbsolutePath());
            Process process = Runtime.getRuntime().exec("npm install", null, workDir);

            // 读取输出
            String output = readInputStream(process.getInputStream());
            String error = readInputStream(process.getErrorStream());

            int exitCode = process.waitFor();

            if (exitCode != 0) {
                log.error("npm install failed. Error: {}", error);
                return false;
            }

            log.info("npm install completed successfully. Output: {}", output);
            return true;

        } catch (Exception e) {
            log.error("Failed to install dependencies", e);
            return false;
        }
    }

    private void createPackageJson(File workDir) throws IOException {
        String packageJson = "{\n" +
            "  \"dependencies\": {\n" +
            "    \"solc\": \"^0.6.12\"\n" +
            "  }\n" +
            "}";

        try (FileWriter writer = new FileWriter(new File(workDir, "package.json"))) {
            writer.write(packageJson);
        }
    }

    private void createCompileScript(File workDir, String compilerVersion) throws IOException {
        String script = "const solc = require('solc');\n" +
            "const fs = require('fs');\n" +
            "const path = require('path');\n" +
            "\n" +
            "console.log('Debug: Starting compilation process');\n" +
            "\n" +
            "// 读取合约文件\n" +
            "const contractPath = path.resolve(__dirname, 'Contract.sol');\n" +
            "const sourceCode = fs.readFileSync(contractPath, 'utf8');\n" +
            "console.log('Debug: Contract source code:', sourceCode.substring(0, 100) + '...');\n" +
            "\n" +
            "// 准备编译输入\n" +
            "const input = {\n" +
            "    language: 'Solidity',\n" +
            "    sources: {\n" +
            "        'Contract.sol': {\n" +
            "            content: sourceCode\n" +
            "        }\n" +
            "    },\n" +
            "    settings: {\n" +
            "        outputSelection: {\n" +
            "            '*': {\n" +
            "                '': ['ast']\n" +
            "            }\n" +
            "        }\n" +
            "    }\n" +
            "};\n" +
            "\n" +
            "console.log('Debug: Compilation input:', JSON.stringify(input, null, 2));\n" +
            "\n" +
            "// 加载指定版本的编译器\n" +
            "console.log('Debug: Loading compiler version:', '" + compilerVersion + "');\n" +
            "\n" +
            "solc.loadRemoteVersion('" + compilerVersion + "', function(err, solcSnapshot) {\n" +
            "    if (err) {\n" +
            "        console.error('Error loading compiler:', err);\n" +
            "        process.exit(1);\n" +
            "    }\n" +
            "    \n" +
            "    try {\n" +
            "        console.log('Debug: Compiler loaded, starting compilation');\n" +
            "        const output = JSON.parse(solcSnapshot.compile(JSON.stringify(input)));\n" +
            "        console.log('Debug: Raw compilation output:', JSON.stringify(output, null, 2));\n" +
            "        \n" +
            "        if (output.errors) {\n" +
            "            console.log('Debug: Found compilation messages:', output.errors);\n" +
            "            const errors = output.errors.filter(error => error.severity === 'error');\n" +
            "            if (errors.length > 0) {\n" +
            "                console.error('Compilation errors:', errors);\n" +
            "                process.exit(1);\n" +
            "            }\n" +
            "        }\n" +
            "        \n" +
            "        if (output.sources && output.sources['Contract.sol'] && output.sources['Contract.sol'].ast) {\n" +
            "            console.log('Debug: AST generated successfully');\n" +
            "            fs.writeFileSync('ast.json', JSON.stringify(output.sources['Contract.sol'].ast, null, 2));\n" +
            "        } else {\n" +
            "            console.error('Debug: AST structure not found in output:', JSON.stringify(output.sources, null, 2));\n" +
            "            process.exit(1);\n" +
            "        }\n" +
            "    } catch (e) {\n" +
            "        console.error('Compilation error:', e);\n" +
            "        process.exit(1);\n" +
            "    }\n" +
            "});\n";

        try (FileWriter writer = new FileWriter(new File(workDir, "compile.js"))) {
            writer.write(script);
        }
    }

    private void cleanupFiles(File workDir) {
        FileSystemUtils.deleteRecursively(workDir);
    }

    public String generateLegacyAst(String sourceCode, String compilerVersion) throws IOException {
        // 获取现代AST
        String modernAst = generateAst(sourceCode, compilerVersion);
        
        try {
            ObjectMapper mapper = new ObjectMapper();
            // 解析现代AST
            JsonNode modernAstNode = mapper.readTree(modernAst);
            // 转换为legacy格式
            JsonNode legacyAstNode = AstConverter.convertToLegacyAst(modernAstNode);
            // 转回JSON字符串,使用漂亮打印
            return mapper.writerWithDefaultPrettyPrinter().writeValueAsString(legacyAstNode);
        } catch (JsonProcessingException e) {
            log.error("│ Failed to convert AST format", e);
            throw new RuntimeException("Failed to convert AST format", e);
        }
    }
} 