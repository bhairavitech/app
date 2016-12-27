BEGIN;

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    tax DECIMAL(10,2) NOT NULL,
    ACTIVE CHAR(1) DEFAULT 'Y'
) WITHOUT OIDS;

INSERT INTO products VALUES (1, 'Turmeric', 20.00, 0.00, 'Y');
INSERT INTO products VALUES (2, 'Kumkum', 35.00, 0.00, 'Y');
INSERT INTO products VALUES (3, 'Sugar 1 Kgms', 65.00, 0.00, 'Y');
INSERT INTO products VALUES (4, 'Rock Salt 1 Kgms', 20.00, 0.00, 'Y');
INSERT INTO products VALUES (5, 'Patanjali Toilet Soap 100gms', 24.00, 14.50, 'Y');

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    num_register_entries INTEGER DEFAULT 50 NOT NULL
) WITHOUT OIDS;

CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    company_name TEXT UNIQUE NOT NULL,
    contact_person_name TEXT DEFAULT NULL,
    address TEXT DEFAULT NULL,
    city TEXT DEFAULT NULL,
    pincode TEXT DEFAULT NULL,
    mobile_number TEXT DEFAULT NULL,
    ACTIVE CHAR(1) DEFAULT 'Y'
) WITHOUT OIDS;

INSERT INTO customer VALUES (1, 'Bharath Trading Corporation', 'Shiva', 'Kailayam', 'Mount Kailash', '100001', '99999 10000', 'Y');
INSERT INTO customer VALUES (2, 'Linga Bhairavi Naturals', 'Bhairavi Devi', 'Linga Bhairavi', 'Velliyangiri Foot Hills', '100002', '99999 10001', 'Y');
INSERT INTO customer VALUES (3, 'Palani Andavar Mills', 'Murugan', 'Subramanya', 'Kumaraparvatham', '100003', '99999 10002', 'Y');
INSERT INTO customer VALUES (4, 'Ganapathi Yarns', 'Ganapathi', 'Madurai', 'Madurai', '100004', '99999 10003', 'Y');

CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    date DATE DEFAULT CURRENT_DATE,
    customer_id INTEGER REFERENCES customers NOT NULL,
    user_id INTEGER REFERENCES users NOT NULL,
    sub_total DECIMAL(10,2) DEFAULT 0 NOT NULL,
    dis_amount DECIMAL(10,2) DEFAULT 0 NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0 NOT NULL,    
    balance DECIMAL(10,2) DEFAULT 0 NOT NULL,
    nett_amount DECIMAL(10,2) DEFAULT 0 NOT NULL,
    is_day_closed BOOLEAN DEFAULT FALSE
) WITHOUT OIDS;

CREATE TABLE sales_items (
    id SERIAL PRIMARY KEY,
    sales_id INTEGER REFERENCES sales NOT NULL,
    product_id INTEGER REFERENCES products NOT NULL,
    qty DECIMAL(10,2) DEFAULT 1 NOT NULL,
    price DECIMAL(10,2) DEFAULT 0 NOT NULL,
    tax_percentage DECIMAL(10,2) DEFAULT 0 NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0 NOT NULL,    
    nett_amount DECIMAL(10,2) DEFAULT 0 NOT NULL
) WITHOUT OIDS;

COMMIT;