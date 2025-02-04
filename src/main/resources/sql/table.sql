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


CREATE TABLE public.market_parameters (
	contract_address varchar(255) NOT NULL,
	transaction_time int8 NULL,
	annualized_rate numeric NULL,
	pool_balance int8 NULL,
	slippage numeric NULL,
	collateral_volatility int4 NULL,
	debt_volatility int4 NULL,
	CONSTRAINT market_parameters_pkey PRIMARY KEY (contract_address)
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

CREATE TABLE public.wallet_token_balance (
    id serial4 NOT NULL,
    contract_address varchar(42) NOT NULL,
    balance numeric(36, 18) NOT NULL,
    "timestamp" timestamp NOT NULL,
    CONSTRAINT wallet_token_balance_pkey PRIMARY KEY (id),
    CONSTRAINT wallet_token_balance_token_time_key UNIQUE (contract_address, "timestamp")
);

CREATE INDEX idx_wallet_token_balance_time ON public.wallet_token_balance ("timestamp");

-- 初始化 USDT 余额 (1000 USDT)
INSERT INTO wallet_token_balance (contract_address, balance, timestamp)
VALUES (
    '0xdac17f958d2ee523a2206206994597c13d831ec7',
    1000.000000000000000000,
    NOW() - INTERVAL '180 days'
);

-- 初始化 Lido 余额 (10 Lido)
INSERT INTO wallet_token_balance (contract_address, balance, timestamp)
VALUES (
    '0x5a98fcbea516cf06857215779fd812ca3bef1b32',
    10.000000000000000000,
    NOW() - INTERVAL '180 days'
);