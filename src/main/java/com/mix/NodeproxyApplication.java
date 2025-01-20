package com.mix;

import io.netty.util.ResourceLeakDetector;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.client.RestTemplate;

import java.io.File;
import java.util.Objects;

@EnableScheduling
@SpringBootApplication
@EnableCaching
public class NodeproxyApplication {

	public static void main(String[] args) {
		ResourceLeakDetector.setLevel(ResourceLeakDetector.Level.ADVANCED);
		String assetsPath = "/root/java/assets/blockchains/ethereum/assets";
		File assetsDir = new File(assetsPath);

		if (assetsDir.exists() && assetsDir.isDirectory()) {
			for (File dir : Objects.requireNonNull(assetsDir.listFiles())) {
				if (dir.isDirectory()) {
					String lowerCaseName = dir.getName().toLowerCase();
					File lowerCaseDir = new File(assetsDir, lowerCaseName);
					if (!lowerCaseDir.exists()) {
						boolean renamed = dir.renameTo(lowerCaseDir);
						if (renamed) {
							System.out.println("Renamed: " + dir.getName() + " -> " + lowerCaseName);
						} else {
							System.err.println("Failed to rename: " + dir.getName());
						}
					}
				}
			}
		} else {
			System.err.println("Assets directory not found.");
		}
		SpringApplication.run(NodeproxyApplication.class, args);
	}

	@Bean
	RestTemplate restTemplate(){
		SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
		// 设置超时时间
		requestFactory.setConnectTimeout(2 * 1000);
		requestFactory.setReadTimeout(2 * 1000);
		RestTemplate restTemplate = new RestTemplate();
		restTemplate.setRequestFactory(requestFactory);
		return restTemplate;
	}
}
