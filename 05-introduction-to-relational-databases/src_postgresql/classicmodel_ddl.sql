
-- CREATE DATABASE classic_model;

/*
This is a multi-line comment.
As you can see, postgreSQL is not case sensitve.
That is, This is the same of this and the same as tHis.

Also the number of empty characters between statments does not matter. This:

DROP TABLE IF EXISTS public.offices;

is the same as this:

DROP      TABLE IF
EXISTS
     public.offices;

*/

-- This is a single inline comment
DROP TABLE IF EXISTS public.offices; -- This is also a valid single inline comment

CREATE TABLE public.offices (
    -- note that the primary key here is a string with 10 characters.
    -- Is this a good idea?
    officecode VARCHAR(10) PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    addressline1 VARCHAR(50) NOT NULL,
    addressline2 VARCHAR(50) DEFAULT NULL,
    state VARCHAR(50) DEFAULT NULL,
    country VARCHAR(50) NOT NULL,
    postalcode VARCHAR(15) NOT NULL,
    territory VARCHAR(10) NOT NULL
);

DROP TABLE IF EXISTS public.employees;

CREATE TABLE public.employees (
    employeenumber BIGINT PRIMARY KEY,
    lastname CHARACTER VARYING(50) NOT NULL,
    firstname CHARACTER VARYING(50) NOT NULL,
    extension CHARACTER VARYING(10) NOT NULL,
    email CHARACTER VARYING(100) NOT NULL,
    officecode CHARACTER VARYING(10) NOT NULL
        REFERENCES public.offices(officecode)
            ON DELETE CASCADE,
        -- This is how we create a foreign key, but not the only way.
        -- There is a way using the alter table command,
        -- but this is a compact way.
    reportsto BIGINT REFERENCES
        public.employees(employeenumber)
            ON DELETE CASCADE,
    jobtitle CHARACTER VARYING(50) NOT NULL
);

DROP TABLE IF EXISTS public.customers;

CREATE TABLE public.customers (
    customernumber BIGINT PRIMARY KEY,
    customername VARCHAR(50) NOT NULL,
    contactlastname VARCHAR(50) NOT NULL,
    contactfirstname VARCHAR(50) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    addressline1 VARCHAR(50) NOT NULL,
    addressline2 VARCHAR(50) DEFAULT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) DEFAULT NULL,
    postalcode VARCHAR(15) DEFAULT NULL,
    country VARCHAR(50) NOT NULL,
    salesrepemployeenumber BIGINT
        REFERENCES public.employees(employeenumber)
            ON DELETE CASCADE,
    -- can the credit be negative? no
    creditlimit DOUBLE PRECISION CHECK(creditlimit >= 0)
);

DROP TABLE IF EXISTS public.payments;

CREATE TABLE public.payments (
    customernumber BIGINT NOT NULL
    REFERENCES public.customers(customernumber)
    ON DELETE CASCADE,
    checknumber CHARACTER VARYING(50) NOT NULL,
    paymentdate date NOT NULL,
    amount DOUBLE PRECISION NOT NULL,
    -- this is a way to define a composite primary key
    PRIMARY KEY(customernumber, checknumber)
);

DROP TABLE IF EXISTS public.productlines;

CREATE TABLE public.productlines (
    productline VARCHAR(50) PRIMARY KEY,
    -- an alternative is to change the data type to 'text';
    -- text data type is practically ilimitated.
    textdescription VARCHAR(4000) DEFAULT NULL,
    htmldescription TEXT,
    -- an alternative to this is to save the path in the server
    -- where the image is saved; we save space this way
    image bytea
);

DROP TABLE IF EXISTS public.products;

CREATE TABLE public.products (
    productcode VARCHAR(15) PRIMARY KEY,
    productname VARCHAR(70) NOT NULL,
    productline VARCHAR(50) NOT NULL
        REFERENCES public.productlines(productline)
            ON DELETE CASCADE,
    productscale VARCHAR(10) NOT NULL,
    productvendor VARCHAR(50) NOT NULL,
    productdescription text NOT NULL,
    quantityinstock SMALLINT NOT NULL,
    buyprice DOUBLE PRECISION NOT NULL,
    msrp DOUBLE PRECISION NOT NULL
);

DROP TABLE IF EXISTS public.orders;

CREATE TABLE public.orders (
    ordernumber BIGINT PRIMARY KEY,
    orderdate date NOT NULL,
    requireddate date NOT NULL,
    shippeddate date,
    status VARCHAR(15) NOT NULL,
    comments text,
    customernumber BIGINT NOT NULL
        REFERENCES public.customers(customernumber)
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS public.orderdetails;

CREATE TABLE public.orderdetails (
    ordernumber BIGINT
        REFERENCES public.orders(ordernumber)
            ON DELETE CASCADE,
    productcode VARCHAR(15)
        REFERENCES public.products(productcode)
            ON DELETE CASCADE,
    quantityordered BIGINT NOT NULL,
    priceeach DOUBLE PRECISION NOT NULL,
    orderlinenumber SMALLINT NOT NULL,
    PRIMARY KEY(ordernumber, productcode)
);
