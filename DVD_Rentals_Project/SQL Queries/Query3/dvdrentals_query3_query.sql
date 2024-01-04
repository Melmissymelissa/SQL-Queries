-- return first 10 records from the film table to view fields
SELECT *
FROM film
LIMIT 10;
-- return first 10 records from the inventory table to view fields
SELECT *
FROM inventory
LIMIT 10;

-- return first 10 records from the customer table to view fields
SELECT *
FROM customer
LIMIT 10;
-- return first 10 records from the address table to view fields
SELECT *
FROM address
LIMIT 10;
--return first 10 records from the city table to view fields
SELECT *
FROM city
LIMIT 10;
-- return first 10 records from the country table to view fields
SELECT *
FROM country
LIMIT 10;
/* find the number of rentals for each customer for each US state 
that has as least 2 customers
*/
WITH joined_table AS (
SELECT district, 
    customer.customer_id, 
    CONCAT(customer.last_name, ', ', customer.first_name) AS customer_name, 
    rental_id
FROM customer
    JOIN address ON customer.address_id = address.address_id
    JOIN city ON address.city_id = city.city_id
    JOIN country ON city.country_id = country.country_id
    JOIN rental ON customer.customer_id = rental.customer_id
WHERE country = 'United States'
),

num_customers AS (
SELECT district, COUNT(DISTINCT customer_id) AS customers
FROM joined_table
GROUP BY district
)

SELECT joined_table.district AS "state", customer_name, COUNT(DISTINCT rental_id) AS rentals
FROM joined_table
    JOIN num_customers ON joined_table.district = num_customers.district
WHERE customers >= 2
GROUP BY joined_table.district, customer_id, customer_name
ORDER BY 1, 3 DESC;


/* for each US state, show the average number of G-rated films that each
customer has rented, in decending order.
*/
WITH customer_g_films AS (
SELECT a.district, c.customer_id, COUNT(*) AS films
FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN customer c ON r.customer_id = c.customer_id
    JOIN address a ON c.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'United States' AND f.rating = 'G'
GROUP BY a.district, c.customer_id)

SELECT district AS "state", ROUND(AVG(films), 1) AS avg_g_films
FROM customer_g_films
GROUP BY district
ORDER BY 2 DESC;

/*
Create a table of all rentals that have a renturn date, what film was rented and 
from what store address, the what customer rented it with their name, email, and 
address
*/
SELECT r.rental_date, 
    r.return_date, 
    f.title AS film_title, 
    iad.address AS store_address, 
    c.last_name || ', ' || c.first_name AS customer_name, 
    c.email AS customer_email, 
    cad.address AS customer_address
FROM rental r
    LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
        LEFT JOIN film f ON i.film_id = f.film_id
        LEFT JOIN store ist ON i.store_id = ist.store_id
        LEFT JOIN address iad ON ist.address_id = iad.address_id
    LEFT JOIN customer c ON r.customer_id = c.customer_id
        LEFT JOIN address cad ON c.address_id = cad.address_id
WHERE r.return_date IS NOT NULL
ORDER BY r.rental_date
LIMIT 1000;


