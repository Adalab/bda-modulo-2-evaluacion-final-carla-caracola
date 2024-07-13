USE Sakila;

-- Excercise 1 - Select all movie names without duplicates
SELECT DISTINCT
	title AS MovieName
FROM
	film;
    
    
-- Exercise 2 - Displays the names of all movies that have a "PG-13" rating
SELECT
	title AS MovieName,
    rating 		-- the excercise statement itself doesn't ask to display this value. I added it to verify the query retrieves correct data. 
FROM
	film
WHERE
	rating = "PG-13";
    

-- Exercise 3 - Find the title and description of all movies that contain the word "amazing" in their description
SELECT
	title AS MovieName,
    description
FROM 
	film
WHERE 
	description LIKE "%amazing%";
    

-- Exercise 4 - Find the title of all movies that are longer than 120 minutes
SELECT
	title AS MovieName,
    length -- the excercise statement itself doesn't ask to display this value. I added it to verify the query retrieves correct data. 
FROM 
	film
WHERE 
	length > 120
ORDER BY length;


-- Exercise 5 - Retrieve the names of all the actors
SELECT
	first_name AS ActorName
FROM actor;


-- Exercise 6 - Find the first and last names of actors who have "Gibson" in their last name
SELECT
	first_name AS ActorName,
    last_name AS ActorLastName
FROM actor
WHERE last_name LIKE "%Gibson%";


-- Exercise 7 - Find the names of actors that have an actor_id between 10 and 20
SELECT
	actor_id, -- the excercise statement itself doesn't ask to display this value. I added it to verify the query retrieves correct data.
    first_name AS ActorName
FROM actor
WHERE actor_id BETWEEN 10 AND 20
ORDER BY actor_id;


-- Exercise 8 - Find the titles of movies in the film table that are neither "R" nor "PG-13" in terms of their rating.
SELECT
	title AS MovieName,
    rating 		-- the excercise statement itself doesn't ask to display this value. I added it to verify the query retrieves correct data. 
FROM
	film
WHERE
	rating NOT IN ("R","PG-13")
ORDER BY rating;

-- running the following sentences lets you verify the previous query is retriving the correct data

-- select all movies
SELECT
	title AS MovieName,
    rating 
FROM
	film;

-- select movies with rating "R" or "PG-13"
SELECT
	title AS MovieName,
    rating 
FROM
	film
WHERE
	rating IN ("R","PG-13");


/*Excercise 9 - Find the total number of films in each classification in the film table and display the classification along 
with the count*/
SELECT
    rating,
    COUNT(*) AS FilmsCount
FROM
	film
GROUP BY rating;

/* Exercise 10 - Find the total number of movies rented by each customer and display the customer ID, first and last name along 
with the number of movies rented*/

SELECT
	c.customer_id,
	c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS MoviesCount
FROM 
	customer c
JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY 
	customer_id;

-- Exercise 11 - Find the total number of movies rented by category and display the category name along with the rental count
/* create a Common Table Expression that links an inventory record with its correspondent category name 
using inventory_id > film_id > category_id > name */
WITH InventoryWithCategory AS (		
	SELECT 
		i.inventory_id,
        i.film_id,
        fc.category_id,
        c.name AS FilmCategory
	FROM
		inventory AS i
	JOIN film_category AS fc ON i.film_id = fc.film_id
    JOIN category AS c ON fc.category_id = c.category_id
  )  

SELECT
	FilmCategory, 
    COUNT(r.rental_id) AS RentalCount
FROM 
	rental AS r
JOIN InventoryWithCategory ON r.inventory_id = InventoryWithCategory.inventory_id 
GROUP BY FilmCategory
ORDER BY RentalCount;

-- Exercise 12 - Find the average length of movies for each rating in the film table and display the rating along with the average length. 
SELECT
	rating AS Rating,
    AVG (length) AS AvarageLength
FROM
	film
GROUP BY (rating);


-- Exercise 13 - Find the first and last names of the actors who appear in the film with the title "Indian Love".

SELECT
    first_name,
    last_name
FROM 
	actor
WHERE
	actor_id IN (
		SELECT 
			actor_id
		FROM 
			film_actor
		WHERE
			film_id = (
				SELECT 
					film_id
				FROM 
					film
				WHERE 
					title = "Indian Love"
				)
		);

-- running the following sentences, one by one, lets you verify the previous query is retriving the correct data

-- first, find "Indian Love"'s film_id
SELECT
	film_id
FROM 
	film
WHERE 
	title = "Indian Love";
-- "Indian Love"'s film_id is 458

-- second, find actor_id (s) related to the film_id
SELECT 
	actor_id
FROM 
	film_actor
WHERE
	film_id = 458; 
-- related actor's ids: 2, 8, 38, 77, 81, 107, 135, 149, 176, 177

-- Lastly, find actor name and last_name
SELECT
    first_name,
    last_name
FROM
	actor
WHERE
	actor_id IN (2, 8, 38, 77, 81, 107, 135, 149, 176, 177);




