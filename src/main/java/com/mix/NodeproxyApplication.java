package com.mix;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.client.RestTemplate;

@EnableScheduling
@SpringBootApplication
public class NodeproxyApplication {

	public static void main(String[] args) {
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
