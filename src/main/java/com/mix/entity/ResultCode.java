package com.mix.entity;

/**
 * 响应结果枚举类
 *
 * @author ZH
 */
public enum ResultCode {
    /**
     * 请求成功
     */
    SUCCESS(0, "success"),

    /**
     * 系统异常
     */
    SYSTEM_ERROR(40001, "server is busy"),

    /**
     * 非法参数
     */
    INVALID_PARAM(10001, "invalid parameter"),
    /**
     * rpc调用异常
     */
    RPC_ERROR(10002, "rpc request error"),

    /**
     * 登录状态异常
     */
    LOGIN_ERROR(10003, "login status error"),

    /**
     * 数据已存在
     */
    DATA_ALREADY_EXIST(10004, "data already exists"),

    /**
     * 订阅个数超出限制
     */
    SUB_NUMBER_EXCEED_LIMIT(10005, "exceed the limit"),

    /**
     * 已经有一笔未支付订单了
     */
    UNPAID_BILL_EXIST(20001, "you already had an unpaid bill"),

    /**
     * 没有未支付订单
     */
    UNPAID_BILL_NOT_EXIST(20002, "you do not have an unpaid bill"),

    /**
     * 当前套餐剩余时长不足
     */
    CURRENT_PLAN_REMAINING_TIME_IS_NOT_ENOUGHT(20003, "remaining time of the current plan is not enought"),

    /**
     * 当前支付的金额小于账单所需金额
     */
    PAYMENT_AMOUNT_IS_LESS_THAN_THE_BILL_AMOUNT(20004, "The payment amount is less than the bill amount"),

    ;

    ResultCode(int code, String message) {
        this.code = code;
        this.message = message;
    }

    /**
     * 响应码
     */
    private final int code;

    /**
     * 响应消息
     */
    private final String message;

    public Integer getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}
