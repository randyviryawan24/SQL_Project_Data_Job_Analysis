--Find companies with the most job openings

--Subquery Solutions

SELECT 
    c.name,
    j.num_jobs
FROM company_dim AS c
LEFT JOIN
    (
        SELECT 
            company_id,
            COUNT(job_id) AS num_jobs
        FROM job_postings_fact
        GROUP BY company_id
    ) AS j
    ON c.company_id = j.company_id
ORDER BY j.num_jobs DESC
;

--CTE solutions

WITH count_jobs_company AS (
        SELECT 
            company_id,
            COUNT(job_id) AS num_jobs
        FROM job_postings_fact
        GROUP BY company_id
)

SELECT 
    c.name,
    j.num_jobs
FROM company_dim AS c
LEFT JOIN count_jobs_company AS j
    ON c.company_id = j.company_id
ORDER BY j.num_jobs
;

--Identify companies with the most diverse (unique) job titles. 
/*Use a CTE to count the number of unique job titles per company, 
then select companies with the highest diversity in job titles.
*/

WITH diverse_job_titles AS
    (
        SELECT
            company_id,
            COUNT(DISTINCT job_title) AS titles
        FROM job_postings_fact
        GROUP BY company_id 
    )

SELECT
    c.name,
    d.titles
FROM company_dim AS c
LEFT JOIN diverse_job_titles AS d
    ON c.company_id = d.company_id
ORDER BY d.titles DESC, c.name ASC
LIMIT 10
;

/*Explore job postings by listing job id, 
job titles, company names, and their average salary rates, 
while categorizing these salaries relative to the average in their respective countries. 
Include the month of the job posted date. 
Use CTEs, conditional logic, and date functions, to compare individual salaries with national averages.
*/

WITH avg_national_salary AS (
    SELECT
        job_country,
        AVG(salary_year_avg) AS avg_salary_country
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
    GROUP BY job_country
)

SELECT
    j.job_id,
    j.job_title,
    c.name,
    j.salary_year_avg AS avg_salary,
    n.avg_salary_country,
    EXTRACT(MONTH FROM j.job_posted_date::DATE) AS posted_month,
    CASE 
        WHEN j.salary_year_avg > n.avg_salary_country THEN 'Above Average'
        WHEN j.salary_year_avg < n.avg_salary_country THEN 'Below Average'
        ELSE 'Same Salary'
    END AS salary_comparison
FROM job_postings_fact AS j
LEFT JOIN company_dim AS c
    ON j.company_id = c.company_id
LEFT JOIN avg_national_salary AS n
    ON j.job_country = n.job_country
WHERE j.salary_year_avg IS NOT NULL
ORDER BY posted_month DESC

/*Calculate the number of unique skills required by each company. 
Aim to quantify the unique skills required per company and 
identify which of these companies offer the highest average salary for positions necessitating at least one skill. 
For entities without skill-related job postings, list it as a zero skill requirement and a null salary. 
Use CTEs to separately assess the unique skill count and the maximum average salary offered by these companies.
*/

WITH unique_skills AS(
    SELECT
        j.company_id,
        COUNT (DISTINCT sj.skill_id) AS unique_skills
    FROM skills_job_dim AS sj
    INNER JOIN job_postings_fact AS j
        ON sj.job_id = j.job_id
    GROUP BY j.company_id

),

    highest_average_salary AS (
    SELECT
        company_id,
        MAX(salary_year_avg) AS max_avg_salary
    FROM job_postings_fact
    WHERE job_id IN (
        SELECT job_id
        FROM skills_job_dim
    )
    GROUP BY company_id
)

SELECT
    c.name,
    COALESCE(u.unique_skills,0) AS unique_skills,
    COALESCE(h.max_avg_salary,0) AS max_avg_salary
FROM company_dim AS c
LEFT JOIN unique_skills AS u
    ON c.company_id = u.company_id
LEFT JOIN highest_average_salary AS h
    ON c.company_id = h.company_id
ORDER BY c.name


/*Find the count of the number of remote job postings per skill
*/

SELECT
    sj.skill_id,
    s.skills,
    COUNT(sj.job_id) AS num_remote_skills
FROM skills_job_dim AS sj
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
WHERE sj.job_id IN (
        SELECT 
            job_id
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
)
GROUP BY sj.skill_id,s.skills
ORDER BY num_remote_skills DESC
LIMIT 5
;


(
    SELECT
    job_id,
    job_title,
    'With Salary Info' AS salary_info
FROM job_postings_fact 
WHERE salary_year_avg IS NOT NULL
)

UNION ALL

(
SELECT
    job_id,
    job_title,
    'Without Salary Info' AS salary_info
FROM job_postings_fact 
WHERE salary_year_avg IS NULL
)
ORDER BY
    salary_info DESC,job_id

--1st Quarter 2023 analysis

WITH first_quarter AS
(
(
SELECT*
FROM jan_2023_jobs
)

UNION ALL

(
SELECT*
FROM feb_2023_jobs
)

UNION ALL

(
SELECT*
FROM mar_2023_jobs
)
)

SELECT
    fq.job_id,
    fq.job_title_short,
    fq.job_location,
    fq.job_via,
    t.skills,
    t.type
FROM first_quarter AS fq
LEFT JOIN 
    (
        SELECT
            sj.job_id,
            s.skills,
            s.type
        FROM skills_job_dim AS sj
        LEFT JOIN skills_dim AS s
            ON sj.skill_id = s.skill_id
    ) AS t
    ON t.job_id = fq.job_id
WHERE fq.salary_year_avg > 70000 
ORDER by fq.job_id


--Separated
WITH first_quarter AS
(
(
SELECT*
FROM jan_2023_jobs
)

UNION ALL

(
SELECT*
FROM feb_2023_jobs
)

UNION ALL

(
SELECT*
FROM mar_2023_jobs
)
)

SELECT
    t.skills,
    COUNT(CASE WHEN EXTRACT(MONTH FROM fq.job_posted_date::DATE) = 1 THEN fq.job_id END) AS jan_jobs,
    COUNT(CASE WHEN EXTRACT(MONTH FROM fq.job_posted_date::DATE) = 2 THEN fq.job_id END) AS feb_jobs,
    COUNT(CASE WHEN EXTRACT(MONTH FROM fq.job_posted_date::DATE) = 3 THEN fq.job_id END) AS mar_jobs
FROM first_quarter AS fq
LEFT JOIN 
    (
        SELECT
            sj.job_id,
            s.skills,
            s.type
        FROM skills_job_dim AS sj
        LEFT JOIN skills_dim AS s
            ON sj.skill_id = s.skill_id
    ) AS t
    ON t.job_id = fq.job_id 
GROUP BY t.skills