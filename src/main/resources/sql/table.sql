CREATE TABLE public.defi_contracts (
    contract_name VARCHAR(255) NOT NULL,    -- 合约名称
    contract_address VARCHAR(42) UNIQUE NOT NULL, -- 合约地址（以0x开头的42字符地址）
    primary_category VARCHAR(255),         -- 一级分类
    secondary_category VARCHAR(255),       -- 二级分类
    source_code text,
    source_code_tree text,
    source_code_scan_result text
);

create table public.vulnerability_attack_log (
	contract_name VARCHAR(255) NOT NULL,    -- 合约名称
    contract_address VARCHAR(42)  NOT NULL, -- 合约地址（以0x开头的42字符地址）
    attacker_address VARCHAR(42)  NOT NULL, -- 攻击者地址（以0x开头的42字符地址）
    attack_time timestamp NOT NULL,
    vulnerability_type VARCHAR(32) NOT NULL -- 漏洞类型
);

create table public.vulnerability (
    contract_name VARCHAR(255) NOT NULL,    -- 合约名称
    contract_address VARCHAR(42) UNIQUE NOT NULL, -- 合约地址（以0x开头的42字符地址）
    contract_describe text,
    vulnerability_type VARCHAR(32) NOT null, -- 漏洞类型
    source_code text,
    source_code_tree text,
    source_code_scan_result text,
    attack_step json
);

CREATE TABLE simulated_token_transfers (
    id SERIAL PRIMARY KEY,
    from_address_hash BYTEA,
    to_address_hash BYTEA,
    transaction_hash BYTEA,
    block_number INT,
    timestamp TIMESTAMP,  -- 用于存储模拟交易的时间
    amount DECIMAL,
    token_contract_address_hash BYTEA,
    datasource VARCHAR(255) DEFAULT 'simulated'
);
CREATE INDEX idx_simulated_timestamp ON simulated_token_transfers (timestamp);
CREATE INDEX idx_simulated_token_contract_address_hash ON simulated_token_transfers (token_contract_address_hash);


CREATE TABLE market_parameters (
    contract_address VARCHAR(255) PRIMARY KEY,
    transaction_time BIGINT,
    annualized_rate DECIMAL,
    pool_balance BIGINT,
    market_volatility INT,
    slippage DECIMAL
);

CREATE TABLE risk_log (
    log_time TIMESTAMP NOT NULL, -- 时间戳，改为 TIMESTAMP 类型
    contract_address VARCHAR(255) NOT NULL, -- 合约地址
    contract_name VARCHAR(255) NOT NULL, -- 合约名称
    risk_name VARCHAR(255) NOT NULL -- 风险名称
);
create INDEX idx_risk_log_time on risk_log (log_time);

CREATE TABLE risk_assessment_result (
    contract_address VARCHAR(255) PRIMARY KEY, -- 合约地址作为主键
    risk_level VARCHAR(50) NOT NULL, -- 风险等级
    description TEXT NOT NULL, -- 总体风险描述
    details JSONB NOT NULL -- 细项描述，使用 JSONB 存储
);

CREATE TABLE contract_relationships (
    id SERIAL PRIMARY KEY,
    source_contract_address VARCHAR(42) NOT NULL,  -- 发起关联的合约地址
    target_contract_address VARCHAR(42) NOT NULL,  -- 被关联的合约地址
    token VARCHAR(20) NOT NULL,  -- 关联的代币（如 USDT、sETH）
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 记录创建时间
    UNIQUE (source_contract_address, target_contract_address, token)  -- 保证唯一性
);