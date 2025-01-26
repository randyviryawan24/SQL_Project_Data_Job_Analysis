--P1
-- Goal: find companies that have posted more than 3 remote job postings
-- Steps
/*
1. Find number of remote jobs for each company -> Sub Query
2. Filter only companies that have more than 3 remote jobs -> WHERE OR JOIN
*/

--Sub Query

SELECT
    company_id,
FROM job_postings_fact
WHERE job_work_from_home = TRUE
GROUP BY company_id
HAVING COUNT (job_id) > 3
;

--Sub Query Alternatives
SELECT
    company_id,
    COUNT (job_id) as total
FROM job_postings_fact
WHERE job_work_from_home = TRUE
GROUP BY company_id
HAVING COUNT (job_id) > 3
;

--Main Query
SELECT
    company_id,
    name
FROM company_dim
WHERE company_id IN (
        SELECT
            company_id
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
        GROUP BY company_id
        HAVING COUNT (job_id) > 3
);

--Main Query Alternative

SELECT
    c.company_id,
    c.name,
    t.total
FROM company_dim AS c
INNER JOIN (
    SELECT
        company_id,
        COUNT (job_id) as total
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
    GROUP BY company_id
    HAVING COUNT (job_id) > 3
) AS t
    ON c.company_id = t.company_id
ORDER BY t.total DESC;

--P2 Skills Required for Jobs in Top Locations

/*
1. Find top 3 most common locations job postings.
    connect to skill_job_id table
2. join skills table to job_id
*/

--Sub Query
SELECT 
    job_location
FROM job_postings_fact
GROUP BY job_location
ORDER BY COUNT(job_id) DESC
LIMIT 3;

--Main Query
SELECT 
    s.skills,
    COUNT(j.job_id) AS num_jobs
FROM job_postings_fact AS j
INNER JOIN skills_job_dim AS sj
    ON j.job_id = sj.job_id
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
WHERE job_location IN 
    (   SELECT 
            job_location
        FROM job_postings_fact
        GROUP BY job_location
        ORDER BY COUNT(job_id) DESC
        LIMIT 3
)
GROUP BY s.skills
ORDER BY num_jobs DESC
;

--P3 Top 5 job titles with highest average salary

SELECT
    job_title,
    AVG(salary_year_avg) AS avg_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title
ORDER BY avg_salary DESC
LIMIT 5;

-- P5: Companies Offering Jobs with Health Insurance
/*Problem:
Find all companies that have posted jobs offering health insurance. 
List the company name and the number of jobs that offer health insurance.
*/

--Subquery

SELECT 
    company_id,
    COUNT(job_id) AS num_jobs
FROM job_postings_fact
WHERE job_health_insurance = TRUE
GROUP BY company_id
;

--Main Query
SELECT
    c.name,
    j.num_jobs
FROM company_dim AS c
INNER JOIN
    (
        SELECT 
            company_id,
            COUNT(job_id) AS num_jobs
        FROM job_postings_fact
        WHERE job_health_insurance = TRUE
        GROUP BY company_id
    ) AS j
    ON c.company_id = j.company_id
ORDER BY j.num_jobs DESC
;

--Practice Problem 6: Job Postings with Skills Not Required for Any Job
/*Problem:
Find job postings that require skills that are not required for any other job posting. 
List the job titles and skills.*/

-- Subquery
SELECT
    sj.skill_id,
    s.skills
FROM skills_job_dim AS sj
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
GROUP BY sj.skill_id,s.skills
HAVING COUNT(sj.job_id) = 1
ORDER BY sj.skill_id
;

-- Main Query
SELECT
    sj.job_id,
    j.job_title,
    j.job_title_short,
    t.skills
FROM skills_job_dim AS sj
INNER JOIN
    (
        SELECT
            sj.skill_id,
            s.skills
        FROM skills_job_dim AS sj
        INNER JOIN skills_dim AS s
        ON sj.skill_id = s.skill_id
        GROUP BY sj.skill_id,s.skills
        HAVING COUNT(sj.job_id) = 1
        ORDER BY sj.skill_id
    ) AS t
    ON t.skill_id = sj.skill_id
INNER JOIN job_postings_fact AS j
    ON j.job_id = sj.job_id
;

--Practice Problem 7: Companies with the Most Job Titles
/*Find the top 5 companies with the highest number of unique job titles. 
Include the company name and the count of unique job titles.
*/

--Subquery

SELECT
    company_id,
    COUNT(DISTINCT job_title) AS num_unique_titles
FROM job_postings_fact
GROUP BY company_id
ORDER BY num_unique_titles DESC
LIMIT 5

--Main Query
SELECT
    c.name,
    t.num_unique_titles
FROM company_dim AS c
INNER JOIN
    (SELECT
        company_id,
        COUNT(DISTINCT job_title) AS num_unique_titles
    FROM job_postings_fact
    GROUP BY company_id
    ORDER BY num_unique_titles DESC
    LIMIT 5
    ) AS t
    ON t.company_id = c.company_id
;

-- Practice Problem 9: Skills Exclusive to Remote Jobs
/*List skills that are only required for remote jobs. 
Include the skill name and the number of remote jobs requiring it
*/

--Subquery
SELECT 
    job_id,
FROM job_postings_fact
WHERE job_location = 'Anywhere'

;

--Main Query
SELECT
    
FROM skills_job_dim AS sj
WHERE sj.job_id IN 
    (
     SELECT 
        job_id
    FROM job_postings_fact
    WHERE job_location = 'Anywhere'
    )

--Sub Query
SELECT
    sj.skill_id,
    COUNT(CASE WHEN job_location = 'Anywhere' THEN sj.job_id END) AS remote,
    COUNT(CASE WHEN job_location <> 'Anywhere' THEN sj.job_id END) AS onsite
FROM skills_job_dim AS sj
INNER JOIN job_postings_fact AS j
    ON sj.job_id = j.job_id
GROUP BY sj.skill_id
HAVING COUNT(CASE WHEN job_location <> 'Anywhere' THEN 1 END) = 0 
;

--Main Query
SELECT
    s.skills,
    t.remote,
    t.onsite
FROM skills_dim AS s
INNER JOIN
    (
        SELECT
            sj.skill_id,
            COUNT(CASE WHEN job_location = 'Anywhere' THEN sj.job_id END) AS remote,
            COUNT(CASE WHEN job_location <> 'Anywhere' THEN sj.job_id END) AS onsite
        FROM skills_job_dim AS sj
        INNER JOIN job_postings_fact AS j
            ON sj.job_id = j.job_id
        GROUP BY sj.skill_id
        HAVING COUNT(CASE WHEN job_location <> 'Anywhere' THEN 1 END) = 0    
    ) AS t
    ON s.skill_id = t.skill_id
;

-- Practice Problem 1: Popular Skills by Exclusive Job Types
/*Find the top 5 skills that are required exclusively for full-time jobs 
and not part-time jobs. 
Display the skill name and the number of full-time jobs requiring it.*/

--1st Subquery
SELECT job_id
FROM job_postings_fact
WHERE job_schedule_type = 'Full-time'

--2nd Subquery
SELECT job_id
FROM job_postings_fact
WHERE job_schedule_type != 'Full-time'

--Main Query

SELECT
    s.skills,
    COUNT(sj.job_id) AS num_jobs
FROM skills_job_dim AS sj
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
WHERE sj.job_id IN 
    (
        SELECT job_id
        FROM job_postings_fact
        WHERE job_schedule_type = 'Full-time'
    ) AND
    sj.job_id NOT IN 
    (
        SELECT job_id
        FROM job_postings_fact
        WHERE job_schedule_type != 'Full-time'   
    )
GROUP BY s.skills
ORDER BY num_jobs DESC
LIMIT 5
; 

SELECT
    s.skills,
    COALESCE(AVG(CASE WHEN j.job_location = 'Anywhere' THEN j.salary_year_avg END),0) AS avg_remote,
    COALESCE(AVG(CASE WHEN j.job_location != 'Anywhere' THEN j.salary_year_avg END),0) AS avg_onsite,
    ABS(
        COALESCE(AVG(CASE WHEN j.job_location = 'Anywhere' THEN j.salary_year_avg END),0) -
        COALESCE(AVG(CASE WHEN j.job_location != 'Anywhere' THEN j.salary_year_avg END),0)
        )AS var
FROM skills_job_dim AS sj
INNER JOIN 
    (SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL) AS j
    ON sj.job_id = j.job_id
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
GROUP BY s.skills
ORDER BY var DESC
LIMIT 5

