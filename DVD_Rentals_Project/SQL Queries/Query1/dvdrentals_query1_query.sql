-- return first 10 records from the film table to view fields
SELECT *
FROM film
LIMIT 10;
-- return first 10 records from the address table to view fields
SELECT *
FROM address
LIMIT 10;

-- return first 10 records from the store table to view fields
SELECT *
FROM store
LIMIT 10;
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


