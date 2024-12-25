package com.mix.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class GlobalCorsConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")  // 允许跨域访问的路径，/** 表示所有路径
                .allowedOrigins("*")  // 允许的源，多个源用逗号分隔
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")  // 允许的 HTTP 方法
                .allowedHeaders("*")  // 允许的请求头
//                .allowCredentials(true)  // 是否允许发送 Cookie
                .maxAge(3600);  // 预检请求的缓存时间，单位秒
    }
}

