CREATE TABLE "salesperson" (
  "sales_staff_id" SERIAL,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100),
  PRIMARY KEY ("sales_staff_id")
);

CREATE TABLE "customer" (
  "customer_id" SERIAL,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100),
  "billing_info" VARCHAR(100),
  PRIMARY KEY ("customer_id")
);

CREATE TABLE "car" (
  "serial_number" SERIAL,
  "make" VARCHAR(100),
  "model" VARCHAR(10),
  "car_price" NUMERIC(10,2),
  PRIMARY KEY ("serial_number")
);

CREATE TABLE "invoice" (
  "invoice_id" SERIAL,
  "invoice_date" DATE DEFAULT CURRENT_DATE,
  "sales_staff_id" SERIAL,
  "customer_id" SERIAL,
  "serial_number" SERIAL,
  PRIMARY KEY ("invoice_id"),
  CONSTRAINT "FK_invoice.customer_id"
    FOREIGN KEY ("customer_id")
      REFERENCES "customer"("customer_id"),
  CONSTRAINT "FK_invoice.sales_staff_id"
    FOREIGN KEY ("sales_staff_id")
      REFERENCES "salesperson"("sales_staff_id")
);
CREATE TABLE "mechanic" (
  "mechanic_staff_id" SERIAL,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100),
  PRIMARY KEY ("mechanic_staff_id")
);

CREATE TABLE "part" (
  "part_number" SERIAL,
  "type_of_part" VARCHAR,
  "part_price" NUMERIC(6,2),
  PRIMARY KEY ("part_number")
);

CREATE TABLE "service_ticket" (
  "service_ticket" SERIAL,
  "maintenance" VARCHAR(100),
  "total_price" NUMERIC(8,2),
  "service_ticket_date" DATE DEFAULT CURRENT_DATE,
  "serial_number" INTEGER,
  "customer_id" INTEGER,
  "part_number" INTEGER,
  "mechanic_staff_id" INTEGER,
  PRIMARY KEY ("service_ticket"),
  CONSTRAINT "FK_service_ticket.part_number"
    FOREIGN KEY ("part_number")
      REFERENCES "part"("part_number"),
  CONSTRAINT "FK_service_ticket.mechanic_staff_id"
    FOREIGN KEY ("mechanic_staff_id")
      REFERENCES "mechanic"("mechanic_staff_id"),
  CONSTRAINT "FK_service_ticket.customer_id"
    FOREIGN KEY ("customer_id")
      REFERENCES "customer"("customer_id"),
  CONSTRAINT "FK_service_ticket.serial_number"
    FOREIGN KEY ("serial_number")
      REFERENCES "car"("serial_number")
);

---------------------------------------------------------------------------

INSERT INTO customer
VALUES
	(
		1,
		'Jimmy',
		'Rascal',
		'1212-1212-1212-1212 08/24'
	),
	(
		2,
		'Indie',
		'Ellen',
		'2121-2121-2121-2121 09/25'
	);
	
INSERT INTO salesperson
VALUES
	(
		1,
		'Ian'
		'King'
	),
	(
		2,
		'Sean'
		'Everington'
	);
	
INSERT INTO car
VALUES
	(
		1010101,
		'BMW',
		'X3',
		55000
	),
	(
		2020202,
		'BMW',
		'X5',
		65000
	);

INSERT INTO part
VALUES
	(
		1,
		'seats',
		1499.00
	),
	(
		2,
		'wheel',
		786.73
		
	);
INSERT INTO mechanic
VALUES
	(
		1,
		'Angela',
		'King'
	),
	(
		2,
		'Heather',
		'Ross'
	);
INSERT INTO service_ticket(
	service_ticket,
	maintenance,
	total_price,
	service_ticket_date,
	serial_number,
	customer_id,
	mechanic_staff_id
)
VALUES
	(
		1,
		'Oil Change',
		64.99,
		'2023-06-02',
		1010101,
		2,
		1
	);

CREATE OR REPLACE FUNCTION price_calc(part_no INTEGER)
RETURNS DECIMAL
AS $$
DECLARE 
	price DECIMAL;
BEGIN
	SELECT part_price INTO price
	FROM part
	where part_number = part_no;
	RETURN price;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE service_ticket_parts_change(
	ticket_no INTEGER,
	customer INTEGER,
	part_no INTEGER,
	car_serial INTEGER,
	mechanic_id INTEGER
)

LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO service_ticket (
	service_ticket,
	maintenance,
	total_price,
	serial_number,
	customer_id,
	part_number,
	mechanic_staff_id
)
VALUES
	(
		ticket_no,
		'Parts Change',
		price_calc(part_no),
		car_serial,
		customer,
		part_no,
		mechanic_id);
	COMMIT;

END;
$$
		
CALL service_ticket_parts_change(2,1,1,1010101,2);

SELECT * 
FROM service_ticket;