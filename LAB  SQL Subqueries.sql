# LAB | SQL Subqueries

# Write SQL queries to perform the following tasks using the Sakila database:
use sakila;

# 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(*) AS "Number of Copies"
FROM film f
JOIN inventory i 
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

# 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT f.title, f.length
FROM film f
WHERE f.length > (SELECT AVG(length) FROM film);

# 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (
    SELECT film_actor.actor_id
    FROM film_actor
    JOIN film ON film_actor.film_id = film.film_id
    WHERE film.title = 'Alone Trip'
);


#Bonus:
# 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

SELECT * FROM category;

SELECT f.title, c.name
FROM film f 
JOIN film_category fc 
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = 'Family';

# 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address
USING (address_id)
JOIN city ci
USING (city_id)
JOIN country co
USING (country_id)
WHERE co.country = 'Canada';

SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id IN (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

# 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. 
	# First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
    
SELECT film.title
FROM film
WHERE film.film_id IN 
(SELECT fa.film_id
 FROM film_actor fa
 WHERE fa.actor_id = 
	(SELECT a.actor_id
	FROM actor a
	GROUP BY a.actor_id
	ORDER BY  COUNT(fa.film_id) DESC
	LIMIT 1));


# 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

# 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.