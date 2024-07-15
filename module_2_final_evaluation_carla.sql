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
/* create a Common Table Expression that links each inventory record with its correspondent category name 
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


-- Exercise 14 - Displays the titles of all movies that contain the word "dog" or "cat" in their description
SELECT
	title AS MovieName,
    description -- the excercise statement itself doesn't ask to display this value. I added it to verify the query retrieves correct data
FROM
	film
WHERE 
	description LIKE "%dog%" OR description LIKE "%cat%";


-- Exercise 15 - Are there any actors or actresses who do not appear in any films in the film_actor table?
SELECT
	actor_id
FROM 
	actor
WHERE actor_id NOT IN (
	SELECT 
		actor_id
    FROM
		film_actor
	);
    
    
-- Exercise 16 - Find the title of all the movies that were released between 2005 and 2010
SELECT 
	title,
    release_year -- the excercise statement itself doesn't ask to display this value. I added it to verify the query retrieves correct data
FROM 
	film
WHERE 
	release_year BETWEEN 2005 AND 2020;


-- Exercise 17 - Find the titles of all movies that are in the same category as "Family"
SELECT 
	f.title AS MovieTitle,
    fc.category_id  AS MovieCategory-- the excercise statement itself doesn't ask to display this value. I added it to verify the query retrieves correct data
FROM
	film AS f
JOIN
	film_category AS fc ON f.film_id = fc.film_id
WHERE 
	category_id = (
		SELECT
			category_id
		FROM
			category
        WHERE name = "Family"
        );


-- Exercise 18 - Show the first and last names of actors who appear in more than 10 films
SELECT
    a.first_name AS ActorName, 
    a.last_name AS ActorLastName,
	COUNT(fa.film_id) AS MoviesCount
FROM 
	film_actor AS fa
JOIN
	actor AS a ON a.actor_id = fa.actor_id
GROUP BY
	fa.actor_id
HAVING
	MoviesCount > 10
ORDER BY MoviesCount DESC;


-- Exercise 19 -  Find the titles of all movies that are "R" and have a duration greater than 2 hours in the film table
SELECT 
	title, 
    rating, 
    length
FROM
	film
WHERE 
	rating = "R" AND length > 120
ORDER BY length ASC;


/* Exercise 20: Find movie categories that have an average length greater than 120 minutes and display the category name 
along with the average length.*/

SELECT
    c.name AS CategoryName,
    AVG(f.length) CategoryLengthDuration
FROM
	film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id
GROUP BY fc.category_id
HAVING CategoryLengthDuration > 120
ORDER BY CategoryLengthDuration ASC;

-- Exercise 21 - Find actors who have acted in at least 5 movies and display the actor's name along with the number of movies they have acted in
-- I'm using the same solution as in Exercise 18, changing the condition in the HAVING clause
SELECT
    a.first_name AS ActorName, 
    a.last_name AS ActorLastName,
	COUNT(fa.film_id) AS MoviesCount
FROM 
	film_actor AS fa
JOIN
	actor AS a ON a.actor_id = fa.actor_id
GROUP BY
	fa.actor_id
HAVING
	MoviesCount >= 5 
ORDER BY MoviesCount ASC;

/*Exercise 22 - Find the title of all movies that were rented for more than 5 days. Use a subquery to
find rental_ids with a duration greater than 5 days and then select the corresponding movies.
*/
SELECT 
	f.title,
    r.rental_id
FROM
	film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE rental_id IN (
	SELECT 
		rental_id
	FROM 
		rental
	WHERE 
		return_date IS NOT NULL AND 						-- this condition is to exclude records with no data
        TIMESTAMPDIFF(HOUR, rental_date, return_date) > 120 -- even tough the exercise statement mention day as the time unit, I chose to use hours instead to include the results that have 5 days and some hours but less than 6 days
    )
; 

/* Excersice 23: Find the first and last names of actors who have not acted in any movies in the "Horror" category.
Use a subquery to find actors who have acted in movies in the "Horror" category and then exclude them from the list of actors.
*/ 
/* 
-> Data to display: first and last name of actresses (this data is in actor table)
-> Condition(s): actresses didn't act in "Horror" movies (tables needed: category (to find relation between category name "Horror" and 
category_id), film_category (to find relation between category_id and film_id), film_actor (to find relation between actresses adn films))
*/
SELECT 
	first_name AS ActorFirstName,
    last_name AS ActorFirstName,
	name AS MovieCategory
FROM
	actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN film_category AS fc ON fa.film_id = fc.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = "Horror";


-- BONUS!! 🎉🎉
-- Exercise 24: Find the titles of films that are comedies and have a duration of more than 180 minutes in the film table
SELECT 
	f.title AS MovieTitle, 
    f.length AS MovieDuration,
    c.name AS MovieCategory
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = "Comedy" AND length > 180;


/* Exercise 25 - Find all actors who have acted together in at least one movie. 
The query should return the actors' first and last names and the number of movies they have acted together in.
*/
/* 
-> Data to display: actor first and last names and number of movies they have acted together in 
-> Tables involves: film_actor (to get relation movie <-> actor) and actor (to get actor first_name and last_name) 
-> Approach: 
- first, group actors by pairs of actors that worked on the same film 
- second, check if there are duplicates in those groups*/

SELECT 
    a1.first_name AS first_actor_first_name,
    a1.last_name AS first_actor_last_name,
    a2.first_name AS second_actor_first_name,
    a2.last_name AS second_actor_last_name,
    COUNT(*) AS number_of_movies_together
FROM 
    film_actor fa1
/* join table film_actor to itself through film_id column to generate pairs of actors (from fa1 y fa2) that worked in the same movie. 
The condition fa1.actor_id < fa2.actor_id avoids duplicates and self matching (an actor matching with itself)
*/
JOIN 
    film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id 
JOIN 
    actor a1 ON fa1.actor_id = a1.actor_id
JOIN 
    actor a2 ON fa2.actor_id = a2.actor_id
GROUP BY 
    fa1.actor_id, fa2.actor_id
ORDER BY 
    number_of_movies_together DESC;

