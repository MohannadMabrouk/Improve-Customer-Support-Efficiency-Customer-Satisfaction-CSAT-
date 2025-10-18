SELECT *
FROM customer_churn_telecom_services;


-- PART I Churn Rate Analysis

/*What is the overall churn rate?*/
SELECT	Churn,
		COUNT(*) AS total_customers,
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS churn_percentage
FROM customer_churn_telecom_services
GROUP BY Churn;

/*Which customer segments have the highest churn?*/

SELECT	Contract, COUNT(Churn) AS total_churn,
		ROUND(COUNT(Churn) * 100 / SUM(COUNT(Churn)) OVER(), 1) AS churn_contract_percentage
FROM	customer_churn_telecom_services
GROUP BY Contract;
-- Customers paying month-to-month leave at 55%, compared to only 21% for yearly contracts.

-- PART II Churn by Demographics

/*Does age group affect churn?*/

SELECT
    CASE
        WHEN SeniorCitizen = 1 THEN 'Senior Citizen'
        ELSE 'Adult'
    END AS Age_group,
    Churn,
    COUNT(*) AS churn_count,
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(PARTITION BY CASE
                WHEN SeniorCitizen = 1 THEN 'Senior Citizen'
                ELSE 'Adult'
            END), 2) AS churn_rate_percentage
FROM customer_churn_telecom_services
GROUP BY
    CASE
        WHEN SeniorCitizen = 1 THEN 'Senior Citizen'
        ELSE 'Adult'
    END,
    Churn
ORDER BY Age_group, Churn;















