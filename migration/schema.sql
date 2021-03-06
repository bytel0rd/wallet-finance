CREATE TABLE banking_kyc (

    id varchar primary key,
    name varchar(144) NOT NULL,

    bank_account_name varchar(144),
    bank_account_number varchar(10),
    bvn varchar(11),
    bank_code varchar,
    
    owner_id varchar NOT NULL,
    verified boolean NOT NULL,
    
    created_by varchar(144),
    updated_by varchar(144),

    created_at timestamp with time zone NOT NULL DEFAULT current_timestamp,
    updated_at timestamp with time zone NOT NULL DEFAULT current_timestamp

);


CREATE TABLE virtual_accounts (

    id varchar primary key,

    account_name varchar(144) NOT NULL,
    account_number varchar(10) NOT NULL,
    bank_name varchar(144) NOT NULL,
    
    provider varchar(144) NOT NULL,
    reference varchar(144) NOT NULL,

    owner_id varchar NOT NULL,
    
    created_by varchar(144),
    updated_by varchar(144),

    created_at timestamp with time zone NOT NULL DEFAULT current_timestamp,
    updated_at timestamp with time zone NOT NULL DEFAULT current_timestamp

);

CREATE TABLE wallets (
	id varchar(144) primary key,
	
	total_balance bigInt NOT NULL default 0,
	available_balance bigInt NOT NULL default 0,

	version int NOT NULL default 0,
	owner_id varchar(144) NOT NULL,
	
	created_by varchar(144) NOT NULL,
	updated_by varchar(144) NOT NULL,
	
	created_at timestamp with time zone NOT NULL DEFAULT current_timestamp,
	updated_at timestamp with time zone NOT NULL DEFAULT current_timestamp
)

CREATE TABLE wallet_transactions (
    id varchar(144) UNIQUE primary key,

    transaction_type varchar(144) NOT NULL,
	transaction_reference varchar(144) UNIQUE NOT NULL,
	source varchar(144) NOT NULL,
	status varchar(144) NOT NULL,

	amount bigInt NOT NULL,
	opening_balance bigInt NOT NULL,
    
	platform varchar(144) NOT NULL,
	owner_id varchar(144) NOT NULL,
	comment varchar(144),
	
	created_by varchar(144) NOT NULL,
	updated_by varchar(144) NOT NULL,
	
	created_at timestamp with time zone NOT NULL DEFAULT current_timestamp,
	updated_at timestamp with time zone NOT NULL DEFAULT current_timestamp
) 


CREATE TABLE payments (
    id varchar(144) UNIQUE primary key,

    processed_by varchar(144) NOT NULL,
	amount bigInt NOT NULL,
	opening_balance bigInt,

	status varchar(144) NOT NULL,
	transaction_reference varchar(144) UNIQUE NOT NULL,

	transaction_source varchar(144) NOT NULL,
	source_reference varchar(144) UNIQUE NOT NULL,
    
	platform varchar(144) NOT NULL,
	comments varchar(144),

	owner_id varchar(144) NOT NULL,
	
	created_by varchar(144) NOT NULL,
	updated_by varchar(144) NOT NULL,
	
	created_at timestamp with time zone NOT NULL DEFAULT current_timestamp,
	updated_at timestamp with time zone NOT NULL DEFAULT current_timestamp
) 


CREATE TABLE withdrawals (
    id varchar(144) UNIQUE primary key,

	amount bigInt NOT NULL,
	opening_balance bigInt NOT NULL,

	transaction_reference varchar(144) UNIQUE NOT NULL,
	transaction_source varchar(144)  NOT NULL,
	source_reference varchar(144) UNIQUE NOT NULL,
    
    processed_by varchar(144) NOT NULL,
	platform varchar(144) NOT NULL,
    
	approved_by varchar(144),
	status varchar(144) NOT NULL,
	comments varchar(144),

	owner_id varchar(144) NOT NULL,
	
	created_by varchar(144) NOT NULL,
	updated_by varchar(144) NOT NULL,
	
	created_at timestamp with time zone NOT NULL DEFAULT current_timestamp,
	updated_at timestamp with time zone NOT NULL DEFAULT current_timestamp
) 