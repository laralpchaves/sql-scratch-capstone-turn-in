-- Quiz Funnel

SELECT *
FROM survey
LIMIT 10
;
 
/*
1. The table has the following columns:
- question
- user_id
- response
*/

SELECT question,
	COUNT(DISTINCT user_id)
FROM survey
GROUP BY question
;

/*
2. The number of responses for each question is:
- Question 1: 500
- Question 2: 475
- Question 3: 380
- Question 4: 361
- Question 5: 270
*/

/*
3. Completion Rates:
- Question 1: 100%
- Question 2: 95%
- Question 3: 82%
- Question 4: 95%
- Question 5: 74%
The questions with lower completion rates are 'Which shapes do you like?' and 'When was your last eye exam?'
For the first one I think that people are not sure about what they want and for the second one is possible that they are not sure about the time without checking.
*/

-- Home Try-On Funnel

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

/*
4. The quiz table has the following columns:
- user_id
- style
- fit
- shape
- color

The home_try_on table has the following columns:
- user_id
- number_of_pairs
- address

The purchase table has the following columns:
- user_id
- product_id
- style
- model_name
- color
- price
*/

SELECT DISTINCT quiz.user_id,
  home_try_on.user_id IS NOT NULL AS 'is_home_try_on',
  home_try_on.number_of_pairs,
  purchase.user_id IS NOT NULL AS 'is_purchase'
FROM quiz
LEFT JOIN home_try_on
	ON quiz.user_id =
  home_try_on.user_id
LEFT JOIN purchase
	ON purchase.user_id = 
  home_try_on.user_id
LIMIT 10
;

/*
5. Seven Users tried items at home and three Users made a purchase
*/

WITH funnels AS 
(
	SELECT DISTINCT quiz.user_id,
  	home_try_on.user_id IS NOT NULL AS 'is_home_try_on',
  	home_try_on.number_of_pairs,
  	purchase.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz
	LEFT JOIN home_try_on
		ON quiz.user_id =
		home_try_on.user_id
	LEFT JOIN purchase
		ON purchase.user_id = 
  	home_try_on.user_id
)
SELECT COUNT (*) AS 'num_browse',
	SUM(is_home_try_on) AS 'num_home_try_on',
  SUM(is_purchase) AS 'num_purchase',
  1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'browse_to_home_try_on',
  1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'home_try_on_to_purchase'
FROM funnels
;