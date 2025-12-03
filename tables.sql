DROP DATABASE IF EXISTS clean_air_corp;
CREATE DATABASE clean_air_corp;
USE clean_air_corp;

CREATE TABLE Department (
    dept_id      INT PRIMARY KEY,
    dept_name    VARCHAR(100) NOT NULL,
    dept_location VARCHAR(100),
    eSSN         CHAR(9)      
) ENGINE=InnoDB;

CREATE TABLE Customer (
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Vendor (
    vendor_id   INT PRIMARY KEY,
    vendor_name VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Product_Detail (
    product_num INT PRIMARY KEY,
    unit_info   VARCHAR(255),
    unit_status VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE Employee (
    ssn      CHAR(9)  PRIMARY KEY,
    name     VARCHAR(100) NOT NULL,
    dept_id  INT NOT NULL,
    dob      DATE,
    CONSTRAINT fk_employee_department
        FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id)
) ENGINE=InnoDB;

CREATE TABLE Maintenance_Service (
    job_num     INT PRIMARY KEY,
    date        DATE NOT NULL,
    job_type    VARCHAR(100),
    product_num INT NOT NULL,
    eSSN        CHAR(9) NOT NULL,
    CONSTRAINT fk_ms_product
        FOREIGN KEY (product_num)
        REFERENCES Product_Detail(product_num),
    CONSTRAINT fk_ms_employee
        FOREIGN KEY (eSSN)
        REFERENCES Employee(ssn)
) ENGINE=InnoDB;

CREATE TABLE Product_Sales (
    sale_id     INT PRIMARY KEY,
    product_num INT NOT NULL,
    customer_id INT NOT NULL,
    job_num     INT,        
    eSSN        CHAR(9) NOT NULL,
    date        DATE NOT NULL,
    CONSTRAINT fk_sales_product
        FOREIGN KEY (product_num)
        REFERENCES Product_Detail(product_num),
    CONSTRAINT fk_sales_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),
    CONSTRAINT fk_sales_job
        FOREIGN KEY (job_num)
        REFERENCES Maintenance_Service(job_num),
    CONSTRAINT fk_sales_employee
        FOREIGN KEY (eSSN)
        REFERENCES Employee(ssn)
) ENGINE=InnoDB;

CREATE TABLE Shipment (
    order_id INT PRIMARY KEY,
    sale_id  INT NOT NULL,
    customer VARCHAR(100) NOT NULL,
    address  VARCHAR(255) NOT NULL,
    ETA      DATE,
    CONSTRAINT fk_shipment_sale
        FOREIGN KEY (sale_id)
        REFERENCES Product_Sales(sale_id)
) ENGINE=InnoDB;

CREATE TABLE Purchasing (
    product_number INT NOT NULL,
    vendor_id      INT NOT NULL,
    eSSN           CHAR(9) NOT NULL,
    date           DATE NOT NULL,
    PRIMARY KEY (product_number, vendor_id),
    CONSTRAINT fk_purch_product
        FOREIGN KEY (product_number)
        REFERENCES Product_Detail(product_num),
    CONSTRAINT fk_purch_vendor
        FOREIGN KEY (vendor_id)
        REFERENCES Vendor(vendor_id),
    CONSTRAINT fk_purch_employee
        FOREIGN KEY (eSSN)
        REFERENCES Employee(ssn)
) ENGINE=InnoDB;

ALTER TABLE Department
    ADD CONSTRAINT fk_department_manager
        FOREIGN KEY (eSSN)
        REFERENCES Employee(ssn);
