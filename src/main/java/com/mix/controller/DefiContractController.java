package com.mix.controller;

import com.mix.dto.ContractImportRequest;
import com.mix.model.DefiContract;
import com.mix.service.DefiManageService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;

@Slf4j
@RestController
@RequestMapping("/api/contracts")
public class DefiContractController {

    @Autowired
    private DefiManageService defiManageService;

    @PostMapping("/import")
    public ResponseEntity<DefiContract> importContract(
            @RequestParam("file") MultipartFile sourceFile,
            @RequestParam(value = "logo", required = false) MultipartFile logoFile,
            @RequestParam("compilerVersion") String compilerVersion,
            @RequestParam("contractName") String contractName,
            @RequestParam("contractAddress") String contractAddress) {
        
        try {
            // 验证合约文件
            if (!sourceFile.getOriginalFilename().endsWith(".sol")) {
                return ResponseEntity.badRequest().body(null);
            }

            // 验证logo文件
            if (logoFile != null && !logoFile.isEmpty()) {
                if (!isValidLogoFile(logoFile)) {
                    return ResponseEntity.badRequest().body(null);
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

            DefiContract contract = defiManageService.importContract(request);
            return ResponseEntity.ok(contract);
            
        } catch (IOException e) {
            log.error("Failed to process uploaded files", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
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
        Path destinationPath = Path.of(uploadDir.getPath(), fileName);
        file.transferTo(destinationPath);
    }

    private boolean isValidCompilerVersion(String version) {
        return version.matches("v\\d+\\.\\d+\\.\\d+\\+commit\\.[a-f0-9]+");
    }
} 