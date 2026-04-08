-- Create a new database for workforce salary analysis

CREATE DATABASE workforce_project;

-- Select the database to start working

USE workforce_project;

-- Preview first 5 records of the dataset

SELECT 
    *
FROM
    jobs_salary
LIMIT 5;

-- Count total number of jobs for each job role

SELECT 
    job_title, COUNT(*) AS total_jobs
FROM
    jobs_salary
GROUP BY job_title
ORDER BY total_jobs DESC;

-- Calculate average salary for each job role

SELECT 
    job_title, ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM
    jobs_salary
GROUP BY job_title
ORDER BY avg_salary DESC;

-- Analyze average salary based on experience level

SELECT 
    experience_level, ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM
    jobs_salary
GROUP BY experience_level
ORDER BY avg_salary DESC;

-- Identify top 10 highest paying job roles

SELECT 
    job_title, ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM
    jobs_salary
GROUP BY job_title
ORDER BY avg_salary DESC
LIMIT 10;

-- Analyze how remote work impacts salary

SELECT 
    remote_ratio, ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM
    jobs_salary
GROUP BY remote_ratio
ORDER BY avg_salary DESC;

-- Find top 10 locations with highest average salaries

SELECT 
    company_location, ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM
    jobs_salary
GROUP BY company_location
ORDER BY avg_salary DESC
LIMIT 10;

-- Compare job count and average salary across locations

SELECT 
    company_location,
    COUNT(*) AS total_jobs,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM
    jobs_salary
GROUP BY company_location
ORDER BY avg_salary DESC;

-- Analyze high-demand locations with more than 20 job postings

SELECT 
    company_location,
    COUNT(*) AS total_jobs,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM
    jobs_salary
GROUP BY company_location
HAVING COUNT(*) > 20
ORDER BY avg_salary DESC;

-- Compare salary across job roles and experience levels

SELECT 
    job_title,
    experience_level,
    ROUND(AVG(salary_in_usd), 0) AS avg_salary
FROM
    jobs_salary
GROUP BY job_title , experience_level
ORDER BY job_title , avg_salary DESC;

-- Filter high-paying job roles above 100K by experience level

SELECT 
    job_title,
    experience_level,
    ROUND(AVG(salary_in_usd), 0) AS avg_salary
FROM
    jobs_salary
GROUP BY job_title , experience_level
HAVING AVG(salary_in_usd) > 100000
ORDER BY avg_salary DESC;

-- Rank job roles based on average salary using RANK

SELECT 
    job_title,
    ROUND(AVG(salary_in_usd), 0) AS avg_salary,
    RANK() OVER (ORDER BY AVG(salary_in_usd) DESC) AS salary_rank
FROM jobs_salary
GROUP BY job_title;

-- Rank job roles using DENSE_RANK without gaps

SELECT 
    job_title,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary,
    DENSE_RANK() OVER (ORDER BY AVG(salary_in_usd) DESC) AS salary_rank
FROM jobs_salary
GROUP BY job_title;

-- Find top 3 highest paying jobs within each experience level (Subquery method)

SELECT *
FROM (
    SELECT 
        job_title,
        experience_level,
        ROUND(AVG(salary_in_usd), 2) AS avg_salary,
        DENSE_RANK() OVER (
            PARTITION BY experience_level 
            ORDER BY AVG(salary_in_usd) DESC
        ) AS rank_within_exp
    FROM jobs_salary
    GROUP BY job_title, experience_level
) AS ranked_jobs
WHERE rank_within_exp <= 3;

-- Find top 3 highest paying jobs within each experience level (CTE method)

WITH ranked_jobs AS (
    SELECT 
        job_title,
        experience_level,
        ROUND(AVG(salary_in_usd),0) AS avg_salary,
        DENSE_RANK() OVER (
            PARTITION BY experience_level 
            ORDER BY AVG(salary_in_usd) DESC
        ) AS rank_within_exp
    FROM jobs_salary
    GROUP BY job_title, experience_level
)

SELECT *
FROM ranked_jobs
WHERE rank_within_exp <= 3;

-- Convert experience codes into readable labels
SELECT 
    job_title,
    experience_level,
    CASE
        WHEN experience_level = 'EN' THEN 'Entry Level'
        WHEN experience_level = 'MI' THEN 'Mid Level'
        WHEN experience_level = 'SE' THEN 'Senior Level'
        WHEN experience_level = 'EX' THEN 'Executive Level'
        ELSE 'Other'
    END AS experience_label,
    ROUND(AVG(salary_in_usd), 0) AS avg_salary
FROM
    jobs_salary
GROUP BY job_title , experience_level;

-- Present cleaned experience levels in output
SELECT 
    job_title,
    CASE
        WHEN experience_level = 'EN' THEN 'Entry Level'
        WHEN experience_level = 'MI' THEN 'Mid Level'
        WHEN experience_level = 'SE' THEN 'Senior Level'
        WHEN experience_level = 'EX' THEN 'Executive Level'
    END AS experience_level,
    ROUND(AVG(salary_in_usd), 0) AS avg_salary
FROM
    jobs_salary
GROUP BY job_title , experience_level;