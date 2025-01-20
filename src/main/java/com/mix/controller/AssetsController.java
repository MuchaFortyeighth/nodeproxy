package com.mix.controller;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

@RestController
@RequestMapping("/asset")
public class AssetsController {

    @GetMapping("/tokenIcon/{tokenAddress}")
    public ResponseEntity<byte[]> getTokenLogo(@PathVariable String tokenAddress) {
        try {
            // 1. 格式化合约地址为小写
            String formattedAddress = tokenAddress.trim().toLowerCase();

            // 2. 拼接文件路径
            String logoPath = String.format("/root/java/assets/blockchains/ethereum/assets/%s/logo.png", formattedAddress);
            File logoFile = new File(logoPath);
            // 4. 读取文件内容
            byte[] imageBytes;
            // 3. 检查文件是否存在
            if (!logoFile.exists()) {
                String defaultLogoPath = "/root/java/assets/blockchains/ethereum/assets/default/logo.png";
                File defaultLogoFile = new File(defaultLogoPath);
                if (defaultLogoFile.exists()) {
                    imageBytes = readBytesFromFile(defaultLogoFile);
                } else {
                    return ResponseEntity.status(HttpStatus.NOT_FOUND)
                            .body(("Logo not found for address: " + tokenAddress).getBytes());
                }
            } else {
                imageBytes = readBytesFromFile(logoFile);
            }

            // 5. 返回图片内容
            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_TYPE, "image/png");
            return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(("Error retrieving logo: " + e.getMessage()).getBytes());
        }
    }


    public byte[] readBytesFromFile(File file) throws IOException {
        FileInputStream fis = new FileInputStream(file);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buffer = new byte[1024];
        int bytesRead;
        while ((bytesRead = fis.read(buffer)) != -1) {
            baos.write(buffer, 0, bytesRead);
        }
        fis.close();
        return baos.toByteArray();
    }

}
