SELECT	ticket_id, customer_id, issue_type, priority, agent_id, created_time, first_response_time, resolution_time, status, language,
		region, response_time_minutes, resolution_time_minutes, csat_score;


SELECT * FROM customer_tickets limit 100;
SELECT * FROM agent_performance limit 100;

-- PART I: Cleaning Data

/*Removing "T" letter from ticket ID and changing the type to int*/
/*Removing "C" letter from customet ID and changing the type to int*/
/*Removing "A" letter from Agent ID and changing the type to int*/
/*Creating Seperate columns for date and time for columns (FRT&RT)*/

SELECT	REPLACE(ticket_id, 'T', '') AS ticket_ID,  
		REPLACE(customer_id, 'C', '') AS customer_ID,
        REPLACE(agent_id, 'A', '') AS agent_ID,
        DATE(first_response_time) AS date_first_response, TIME(first_response_time) AS first_response_time,
        DATE(resolution_time) AS resolution_date, TIME(resolution_time) AS resolution_time,
        DATE(created_time) AS created_date, TIME(created_time) AS created_time,
        issue_type, priority, status, language, region, response_time_minutes, resolution_time_minutes, csat_score
FROM customer_tickets;

/*Update table*/

ALTER TABLE customer_tickets
ADD date_first_response DATE,
ADD resolution_date DATE,
ADD created_date DATE;

UPDATE customer_tickets
SET 	ticket_id = REPLACE(ticket_id, 'T', ''),
		customer_id = REPLACE(customer_id, 'C', ''),
		agent_id = REPLACE(agent_id, 'A', ''),
		date_first_response = DATE(first_response_time),
		first_response_time = TIME(first_response_time),
		resolution_date = DATE(resolution_time),
		resolution_time = TIME(resolution_time),
		created_date = DATE(created_time),
		created_time = TIME(created_time);

-- PART II: CSAT Calculation
/*Assigning 4&5 as CSAT 1-3 as DSAT */

SELECT IF(csat_score >3, "CSAT", "DSAT") AS survey_score, csat_score
FROM customer_tickets 
LIMIT 100;

/*Update table*/

ALTER TABLE customer_tickets 
ADD survey_score TEXT;

UPDATE customer_tickets
SET survey_score = IF(csat_score >3, "CSAT", "DSAT");

-- PART III: Exploratory Analysis

/*Average response time*/
SELECT survey_score, ROUND(AVG(response_time_minutes), 1) AS avg_response_time_sec
FROM customer_tickets
GROUP BY survey_score;

/*Average reselution time*/
SELECT survey_score, ROUND(AVG(resolution_time_minutes), 1) AS avg_resolution_time
FROM customer_tickets
GROUP BY survey_score;

/*CSAT by priority level*/
SELECT	priority, survey_score,
		COUNT(survey_score) OVER(PARTITION BY survey_score ORDER BY priority) AS rnk
FROM customer_tickets
GROUP BY priority, survey_score;



