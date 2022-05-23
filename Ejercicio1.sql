
-- Creación de la base de Datos
-- CREATE DATABASE pec2;

-- Creación de esquema
CREATE SCHEMA erp;
SET search_path TO erp,"$user",public;
------------------------------------------------------------------------------------------------

-- Creación de tablas
CREATE TABLE erp.tb_company
(
    co_code CHAR(3) NOT NULL,
    co_name VARCHAR(50) NOT NULL,
    co_address VARCHAR(150) NOT NULL,
    co_city VARCHAR(50) NOT NULL,
    co_country VARCHAR(30) NOT NULL DEFAULT 'España',
    last_updated_by VARCHAR(20) NOT NULL DEFAULT 'SYSTEM',
    last_update_date DATE NOT NULL,
    PRIMARY KEY (co_code)
);

CREATE TABLE erp.tb_customer
(
    cust_no CHAR(5) NOT NULL,
    cust_name VARCHAR(50) NOT NULL,
    cust_cif VARCHAR(15) NOT NULL,
    last_updated_by VARCHAR(20) NOT NULL DEFAULT 'SYSTEM',
    last_update_date DATE NOT NULL,
    PRIMARY KEY (cust_no)
);

CREATE TABLE erp.tb_site
(
    cust_no CHAR(5) NOT NULL,
    site_id INTEGER NOT NULL,
    site_code CHAR(5) NOT NULL,
    site_name VARCHAR(50) NOT NULL,
    site_address VARCHAR(150) NOT NULL,
    site_city VARCHAR(50) NOT NULL,
    site_country VARCHAR(30) NOT NULL DEFAULT 'España',
    site_phone CHAR(13), --INTEGER
    co_code CHAR(3) NOT NULL,
    last_updated_by VARCHAR(20) NOT NULL DEFAULT 'SYSTEM',
    last_update_date DATE NOT NULL,
    PRIMARY KEY (site_id),
    FOREIGN KEY (cust_no) REFERENCES erp.tb_customer(cust_no),
    FOREIGN KEY (co_code) REFERENCES erp.tb_company(co_code)
);

CREATE TABLE erp.tb_iva
(
    co_code CHAR(3) NOT NULL,
    iva_id INTEGER NOT NULL,
    iva_no VARCHAR(15) NOT NULL,
    iva_percent INTEGER NOT NULL,
    active_flag CHAR(1) NOT NULL DEFAULT 'Y',
    last_updated_by VARCHAR(20) NOT NULL DEFAULT 'SYSTEM',
    last_update_date DATE NOT NULL,
    PRIMARY KEY (iva_id),
    FOREIGN KEY (co_code) REFERENCES erp.tb_company(co_code)
);

CREATE TABLE erp.tb_invoice
(
    co_code CHAR(3) NOT NULL,
    invoice_id INTEGER NOT NULL,
    invoice_no VARCHAR(15) NOT NULL,
    cust_no CHAR(5) NOT NULL,
    site_id INTEGER NOT NULL,
    payed CHAR(1) NOT NULL DEFAULT 'N',
    net_amount REAL NOT NULL,
    iva_amount REAL NOT NULL,
    tot_amount REAL NOT NULL,
    last_updated_by VARCHAR(20) NOT NULL DEFAULT 'SYSTEM',
    last_update_date DATE NOT NULL,
    PRIMARY KEY (invoice_id),
    FOREIGN KEY (co_code) REFERENCES erp.tb_company(co_code),
    FOREIGN KEY (cust_no) REFERENCES erp.tb_customer(cust_no),
    FOREIGN KEY (site_id) REFERENCES erp.tb_site(site_id)    
);

CREATE TABLE erp.tb_lines
(
    invoice_id INTEGER NOT NULL,
    line_id INTEGER NOT NULL,
    line_num INTEGER NOT NULL,
    item CHAR(5),
    description VARCHAR(120) NOT NULL,
    net_amount REAL NOT NULL,
    iva_amount REAL NOT NULL,
    last_updated_by VARCHAR(20) NOT NULL DEFAULT 'SYSTEM',
    last_update_date DATE NOT NULL,
    PRIMARY KEY (line_id),
    FOREIGN KEY (invoice_id) REFERENCES erp.tb_invoice(invoice_id)
);

