CREATE TABLE USERS (ID SERIAL PRIMARY KEY, 
NAME VARCHAR(255) NOT NULL, EMAIL VARCHAR(255) NOT NULL,                           
PASSWORD_HASH VARCHAR(255) NOT NULL);




CREATE TABLE PRODUCT (ID SERIAL PRIMARY KEY, 
NAME VARCHAR(255) NOT NULL, PRICE FLOAT NOT NULL);


CREATE TABLE sale_details (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES PRODUCT NOT NULL,
    qty DECIMAL(10,2) DEFAULT 0 NOT NULL,
    rate DECIMAL(10,2) DEFAULT 0 NOT NULL,
    total DECIMAL(10,2) DEFAULT 0 NOT NULL
)
