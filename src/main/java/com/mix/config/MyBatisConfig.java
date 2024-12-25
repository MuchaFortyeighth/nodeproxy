package com.mix.config;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.autoconfigure.ConfigurationCustomizer;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import com.mix.handler.JsonTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class MyBatisConfig {
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.POSTGRE_SQL));  // 这里选择 PostgreSQL
        return interceptor;
    }

    @Bean
    public ConfigurationCustomizer customTypeHandler() {
        return configuration -> {
            // 注册自定义 TypeHandler
            configuration.getTypeHandlerRegistry()
                    .register(List.class, JdbcType.OTHER, new JsonTypeHandler<>(List.class));
        };
    }
}

