-- Learn how to extract Month and Year
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM 
    job_postings_fact
LIMIT 5;


SELECT
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    COUNT(job_id) AS num_jobs
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY date_month
ORDER BY date_month;

--Learn how to change timestamp to Date
SELECT
    job_posted_date AS date_time,
    job_posted_date::DATE AS date,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_timezone
FROM job_postings_fact
LIMIT 5;

--Practice Problems

--1

SELECT
    job_schedule_type,
    AVG(salary_year_avg) AS avg_year,
    AVG(salary_hour_avg) AS avg_hour
FROM job_postings_fact
WHERE job_posted_date::DATE > '2023-06-01'
GROUP BY job_schedule_type
ORDER BY job_schedule_type;

--2

/*Count the number of job postings for each month in 2023, 
adjusting the job_posted_date to be in 'America/New_York' time zone before extracting the month. 
Assume the job_posted_date is stored in UTC. 
Group by and order by the month.*/

SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
    COUNT(job_id) AS num_jobs
FROM job_postings_fact
WHERE 
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') = 2023
GROUP BY 
    month
ORDER BY
    month;

--3
/*Find companies (include company name) that have posted jobs offering health insurance, 
where these postings were made in the second quarter of 2023. 
Use date extraction to filter by quarter. 
And order by the job postings count from highest to lowest.*/

SELECT
    c.name AS company_name,
    COUNT(j.job_id) AS num_jobs
FROM job_postings_fact AS j
INNER JOIN company_dim AS c
    ON c.company_id = j.company_id
WHERE
    j.job_health_insurance = TRUE
    AND EXTRACT(QUARTER FROM j.job_posted_date::DATE) = 2
    AND EXTRACT(YEAR FROM j.job_posted_date::DATE) = 2023
GROUP BY
    company_name
HAVING 
    COUNT(j.job_id) >= 1
ORDER BY
    num_jobs DESC;

    
SELECT*
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date::DATE) = 2022;