package com.mix.entity;

public enum StepType {
    DEPLOY_CODE("部署合约代码"),
    CALL_CONTRACT("调用合约方法"),
    CALLBACK("回调函数触发"),
    TRANSFER_FUNDS("转账操作"),
    UPDATE_STATE("更新合约状态"),
    VALIDATE_REQUIREMENTS("校验条件或断言"),
    HALT_EXECUTION("停止递归或执行"),
    INITIALIZE("初始化合约或变量"),
    AUTHORIZE("授权操作"),
    MINT_ASSETS("生成资产"),
    BURN_ASSETS("销毁资产"),
    LOG_EVENT("日志记录或事件触发");

    private final String description;

    // 构造器
    StepType(String description) {
        this.description = description;
    }

    // 获取描述的方法
    public String getDescription() {
        return description;
    }
}
