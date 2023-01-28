-- QN 1
ALTER TABLE customer ADD PRIMARY KEY(customer_id);
ALTER TABLE passengers_on_flights ADD FOREIGN KEY(customer_id) REFERENCES customer(customer_id);
ALTER TABLE ticket_details ADD FOREIGN KEY(customer_id) REFERENCES customer(customer_id);
ALTER TABLE routes ADD PRIMARY KEY(route_id);
ALTER TABLE passengers_on_flights ADD FOREIGN KEY(route_id) REFERENCES routes(route_id);

-- QN 2
CREATE TABLE route_details(
	route_id int NOT NULL,
    UNIQUE (route_id),
    flight_num int NOT NULL,
    CHECK (flight_num >0),
    origin_airport varchar(3) NOT NULL,
    destination_airport varchar(3) NOT NULL,
    aircraft_id varchar(12) NOT NULL,
    distance_miles int NOT NULL,
    CHECK (distance_miles >0)
    );
    
-- QN 3
SELECT 
	*
FROM passengers_on_flights
WHERE route_id BETWEEN 0 AND 25;

-- QN 4
SELECT
	COUNT(*) AS NumberOf_Bussiness_Passenger,
    SUM(Price_per_ticket*no_of_tickets) AS Total_Revenue_Business
FROM ticket_details
WHERE class_id = 'Bussiness'

-- QN 5
SELECT
	CONCAT(first_name, " ",last_name) AS full_name
FROM customer

-- QN 6
SELECT
	*
FROM customer
INNER JOIN ticket_details
ON customer.customer_id = ticket_details.customer_id

-- QN 7
SELECT
	first_name,
    last_name,
    brand
FROM ticket_details
LEFT JOIN customer
ON ticket_details.customer_id = customer.customer_id
WHERE brand = 'Emirates'

-- QN 8
SELECT 
	*
FROM passengers_on_flights
GROUP BY customer_id
HAVING class_id = 'Economy Plus'

-- QN 9
SELECT
    IF(SUM(Price_per_ticket*no_of_tickets) >10000,"MORE THAN 10000","LESS THAN 10000") AS revenue
FROM ticket_details

-- QN 10
CREATE VIEW business_customer_airline AS
SELECT
	customer.customer_id,
	first_name,
    last_name,
    brand,
    class_id
FROM customer
LEFT JOIN ticket_details
ON customer.customer_id = ticket_details.customer_id
WHERE class_id = 'Bussiness'

-- QN 11
delimiter &&
CREATE PROCEDURE details_of_passengers(IN route_lower INT, IN route_upper INT)
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION  SELECT "No Table Exist." ;
SELECT
	customer.customer_id,
	customer.first_name,
	customer.last_name,
	customer.date_of_birth,
	customer.gender,
    routes.route_id
FROM passengers_on_flights
INNER JOIN customer
ON passengers_on_flights.customer_id = customer.customer_id
INNER JOIN routes
WHERE routes.route_id BETWEEN route_lower AND route_upper;
END &&
delimter ;

-- QN 12
delimiter &&
CREATE PROCEDURE routedetails_morethan2000()
BEGIN
SELECT
*
FROM routes
WHERE distance_miles > 2000;
END &&
delimiter ;

-- QN 13
delimiter &&
CREATE PROCEDURE distance_cat()
BEGIN
SELECT *,
IF(distance_miles <= 2000, 'SDT', IF(distance_miles <=6500,'IDT','LDT')) AS d_cat
FROM routes;
END &&
delimiter ;