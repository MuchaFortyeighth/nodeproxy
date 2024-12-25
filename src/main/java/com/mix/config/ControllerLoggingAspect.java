package com.mix.aspect;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.UUID;

@Slf4j
@Aspect
@Component
public class ControllerLoggingAspect {

    private final HttpServletRequest request;
    private static final ThreadLocal<String> requestIdHolder = new ThreadLocal<>();

    public ControllerLoggingAspect(HttpServletRequest request) {
        this.request = request;
    }

    @Before("execution(* com.mix.controller..*(..))")
    public void logBefore(JoinPoint joinPoint) {
        // 生成唯一请求 ID
        String requestId = UUID.randomUUID().toString();
        requestIdHolder.set(requestId);

        String requestUri = request.getRequestURI();
        String clientIp = request.getRemoteAddr();
        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getTarget().getClass().getSimpleName();
        String args = Arrays.toString(joinPoint.getArgs());

        log.info("[Request ID: {}] [Request Path] URI: {}, Client IP: {}", requestId, requestUri, clientIp);
        log.info("[Request ID: {}] [Request] Class: {}, Method: {}, Args: {}",
                requestId, className, methodName, args);
    }

    @AfterReturning(pointcut = "execution(* com.mix.controller..*(..))", returning = "result")
    public void logAfterReturning(JoinPoint joinPoint, Object result) {
        String requestId = requestIdHolder.get();
        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getTarget().getClass().getSimpleName();

        log.info("[Request ID: {}] [Response] Class: {}, Method: {}, Response: {}",
                requestId, className, methodName, result);

        // 清除 ThreadLocal 中的请求 ID
        requestIdHolder.remove();
    }

    @AfterThrowing(pointcut = "execution(* com.mix.controller..*(..))", throwing = "exception")
    public void logAfterThrowing(JoinPoint joinPoint, Throwable exception) {
        String requestId = requestIdHolder.get();
        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getTarget().getClass().getSimpleName();

        log.error("[Request ID: {}] [Exception] Class: {}, Method: {}, Exception: {}",
                requestId, className, methodName, exception.getMessage(), exception);

        // 清除 ThreadLocal 中的请求 ID
        requestIdHolder.remove();
    }
}
