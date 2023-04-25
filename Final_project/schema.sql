CREATE TABLE Store (
    store_id int UNIQUE NOT NULL PRIMARY KEY,
    store_name varchar(50) NOT NULL,
    street varchar(100) NOT NULL,
    borough varchar(100) NOT NULL,
    city varchar(50) NOT NULL,
    state varchar(50) NOT NULL,
    zip_code int NOT NULL
);

CREATE TABLE Employee (
    employee_id int UNIQUE NOT NULL PRIMARY KEY,
	store_id int NOT NULL,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    gender varchar(50) NOT NULL,
    job_title varchar(50) NOT NULL,
    year_of_experience int NOT NULL,
    FOREIGN KEY (store_id) REFERENCES store (store_id)
);

CREATE TABLE Salary (
    salary_id int UNIQUE NOT NULL PRIMARY KEY,
    employee_id int NOT NULL,
    salary_amount numeric(10,2) NOT NULL,
    salary_date date NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE Category (
    category_id int UNIQUE NOT NULL PRIMARY KEY,
    main_category varchar(50) NOT NULL,
    sub_category varchar(50) NOT NULL
);

CREATE TABLE Supplier (
    supplier_id int UNIQUE NOT NULL PRIMARY KEY,
    supplier_name varchar(50) NOT NULL,
    email varchar(50),
    address varchar(100),
	city varchar(50),
	state varchar(50);
    phone_number varchar(50)
);

CREATE TABLE Product (
    product_id int UNIQUE NOT NULL PRIMARY KEY,
    product_name varchar(500) NOT NULL,
    product_group varchar(100) NOT NULL,
    product_brand varchar(50) NOT NULL,
    category_id int NOT NULL,
    supplier_id int NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Category(category_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
);


CREATE TABLE Expense (
    expense_id int UNIQUE NOT NULL PRIMARY KEY,
    store_id int NOT NULL,
    expense_date date NOT NULL,
    expense_description varchar(100),
	expense_type varchar(100) NOT NULL,
    expense_amount numeric(10, 2) NOT NULL,
    FOREIGN KEY (store_id) REFERENCES Store(store_id)
);

CREATE TABLE Transaction (
    transaction_id int UNIQUE NOT NULL PRIMARY KEY,
    transaction_date date NOT NULL,
    transaction_price numeric(10, 2) NOT NULL,
    price_unit varchar(50) NOT NULL,
    transaction_quantity numeric(10, 2) NOT NULL,
    quantity_unit varchar(50) NOT NULL,
    store_id int NOT NULL,
    product_id int NOT NULL,
    FOREIGN KEY (store_id) REFERENCES Store(store_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE Inventory (
    inventory_id int UNIQUE NOT NULL PRIMARY KEY,
    product_id int NOT NULL,
    store_id int NOT NULL,
    inventory_quantity numeric(10, 2) NOT NULL,
    quantity_unit varchar(50) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (store_id) REFERENCES Store(store_id)
);

CREATE TABLE Customer (
    customer_id int UNIQUE NOT NULL PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    date_of_birth date NOT NULL,
    phone_number varchar(50),
    email varchar(50)
);

CREATE TABLE Sale (
    sale_id int UNIQUE NOT NULL PRIMARY KEY,
    sale_date date NOT NULL,
    sale_price numeric(10,2) NOT NULL,
    price_unit varchar(50) NOT NULL,
    sale_quantity numeric(10,2) NOT NULL,
    quantity_unit varchar(50) NOT NULL,
    product_id int NOT NULL,
    store_id int NOT NULL,
    customer_id int NOT NULL,
    employee_id int NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Product (product_id),
    FOREIGN KEY (store_id) REFERENCES Store (store_id),
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id),
    FOREIGN KEY (employee_id) REFERENCES Employee (employee_id)
);

CREATE TABLE Refund (
    refund_id int UNIQUE NOT NULL PRIMARY KEY,
    store_id int NOT NULL,
    customer_id int NOT NULL,
    refund_date date NOT NULL,
    refund_reason varchar(50),
    refund_amount numeric(10, 2) NOT NULL,
    FOREIGN KEY (store_id) REFERENCES Store(store_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Coupon (
    coupon_id int UNIQUE NOT NULL PRIMARY KEY,
    store_id int NOT NULL,
    customer_id int NOT NULL,
    coupon_date date NOT NULL,
    coupon_description varchar(50),
    coupon_rate numeric(10, 2) NOT NULL,
    FOREIGN KEY (store_id) REFERENCES Store(store_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Loyalty_program (
    loyalty_program_id int UNIQUE NOT NULL PRIMARY KEY,
    loyalty_program_name varchar(50) NOT NULL,
    loyalty_program_description varchar(500) NOT NULL
);

CREATE TABLE Loyalty_reward (
    loyalty_reward_id int UNIQUE NOT NULL PRIMARY KEY,
    loyalty_program_id int NOT NULL,
    store_id int NOT NULL,
    customer_id int NOT NULL,
    loyalty_reward_date date NOT NULL,
    FOREIGN KEY (loyalty_program_id) REFERENCES Loyalty_program(loyalty_program_id),
    FOREIGN KEY (store_id) REFERENCES Store(store_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);