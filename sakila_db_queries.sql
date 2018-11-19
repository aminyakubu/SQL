USE sakila;

# Question 1 - How many actors have information stored in the sakila database?
# There are 200 actors in the database
SELECT COUNT(DISTINCT actor_id) AS number
FROM actor;

# Question 2 - How many different districts do the customers represent?
# There are 376 districts that the customers represent

SELECT COUNT(DISTINCT district) AS num_dis
	FROM customer AS c
	INNER JOIN address AS ad
		ON c.address_id = ad.address_id;

# Question 3 - How many different countries do the customers represent?
# There are 108 different countries that customers represent

SELECT COUNT( DISTINCT country_id) AS num_country
	FROM customer AS c
    JOIN address AS a
		ON c.address_id = a.address_id
	JOIN city AS ct
		ON ct.city_id = a.city_id;

# Question 4 - Which actor did the most films?
# 42 films - GINA DEGENERES

SELECT a.actor_id, a.first_name, a.last_name, COUNT(f.film_id) AS num_films
FROM actor AS a
	INNER JOIN film_actor AS f
	ON a.actor_id = f.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING num_films = (
	SELECT COUNT(f.film_id) AS num_films
	FROM actor AS a
		INNER JOIN film_actor AS f
		ON a.actor_id = f.actor_id
	GROUP BY a.actor_id, a.first_name, a.last_name
	ORDER BY num_films DESC
    LIMIT 1);*/
    
#Question 5 - Which actor did the most action films? List the top actor by name, along with their number of action films 
# Hopkins Natalie has the highest number of action movies. 6 in total

SELECT a.actor_id, a.first_name, a.last_name, COUNT(f.film_id) AS num_action_films
FROM actor AS a
	INNER JOIN film_actor AS f
	ON a.actor_id = f.actor_id
	INNER JOIN film_category AS c
	ON f.film_id = c.film_id
WHERE c.category_id = 1
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING num_action_films = (
	SELECT COUNT(f.film_id) AS num_action_films
	FROM actor AS a
		INNER JOIN film_actor AS f
		ON a.actor_id = f.actor_id
		INNER JOIN film_category AS c
		ON f.film_id = c.film_id
	WHERE category_id = 1
	GROUP BY a.actor_id, a.first_name, a.last_name
	ORDER BY num_action_films DESC
	LIMIT 1);
 
 # Question 6 - Which category of films has the smallest number of records recorded in the database? Give the name of the category and not the id number.
 #Music category has the smallest number of records recorded in the database
 
 SELECT fc.category_id, name, COUNT(fc.category_id) AS number_of_records
	FROM  film_category AS fc
    JOIN category AS c
		ON fc.category_id = c.category_id
	GROUP BY category_id, name
    ORDER BY number_of_records;
 
 # Question 7 - What is the longest movie in the database? (If multiple movies tied for longest, list all movies)
 # There are 10 longest movies (tie) -- Darn forrester, pond seattle, chicago north, muscle bright, worst banger, gangs pride, soldiers evolution, home pity, 
 #sweet brotherhood and control anthem
 	
SELECT title, length
FROM film
WHERE length = (
	SELECT MAX(length) 
    FROM film);
 
#Question 8 - What is the average running time of each category of movie?
# The averages are listed in the query table

SELECT d.category_id, c.name, average_length FROM(
	SELECT category_id, AVG(length) AS average_length
	FROM film AS f
	INNER JOIN film_category AS fc
		ON f.film_id = fc.film_id
	GROUP BY category_id) AS d
	INNER JOIN category AS c
	ON c.category_id = d.category_id;
 
 #Question 9 - What is the average length of time between movie rental and movie return?
 #The average is 120.1159 hours
 
SELECT AVG(TIMESTAMPDIFF(HOUR, rental_date, return_date)) AS ave_time
	FROM rental;


 #Question 10 - List the 3 customers who take the longest to return their movie rentals, on average 
 #Kenneth Gooden, Brittany Riley, Kevin Schuler
 
 SELECT customer_id, first_name, last_name, AVG(days) AS average_days 
	FROM(
		SELECT c.customer_id, first_name, last_name, TIMESTAMPDIFF(DAY, rental_date, return_date) AS days
		FROM rental AS r
	INNER JOIN customer AS c
		ON r.customer_id = c.customer_id) AS d
	GROUP BY customer_id, first_name, last_name
	ORDER BY average_days DESC
	LIMIT 3;
 
 #Question 11 - Which staff member had their customers spend a higher amount per rental, on average: Mike or Jon?
 #Jon had his customers speding a higher amount per rental
 
SELECT p.staff_id, first_name, last_name, AVG(amount) AS avg_amt_per_staff
	FROM payment AS p
	INNER JOIN staff AS s
		ON p.staff_id = s.staff_id
	GROUP BY staff_id, first_name, last_name
	ORDER BY avg_amt_per_staff DESC;
 
#Question 12 - In which city are the stores located? -- Lethbridge and Woodridge
 
 SELECT store_id, city
	FROM store AS s
    JOIN address AS a
		ON s.address_id = a.address_id
	JOIN city AS cit
		ON a.city_id = cit.city_id;

    
    
 
 
 
 
 
 
 
