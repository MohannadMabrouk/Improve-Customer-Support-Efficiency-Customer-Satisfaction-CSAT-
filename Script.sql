SELECT *
FROM customer_churn_telecom_services;

/*What is the overall churn rate?*/
SELECT	Churn,
		COUNT(*) AS total_customers,
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS churn_percentage
FROM customer_churn_telecom_services
GROUP BY Churn;

