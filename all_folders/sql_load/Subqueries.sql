

--Subquery
SELECT
    company_id
FROM 
    job_postings_fact
WHERE
    job_no_degree_mention = TRUE
ORDER BY
    company_id
;

SELECT
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM 
        job_postings_fact
    WHERE
        job_no_degree_mention = TRUE
    ORDER BY
        company_id        
);

--Practice 1

SELECT*
FROM skills_job_dim
LIMIT 5

--Subquery = Most Used Skills
SELECT
    skill_id
FROM skills_job_dim
GROUP BY skill_id
ORDER BY COUNT(job_id) DESC
LIMIT 5
;

/* Solution 1*/
SELECT
    skill_id,
    skills
FROM skills_dim
WHERE skill_id IN (
    SELECT
        skill_id
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY COUNT(job_id) DESC
    LIMIT 5   
)
;

/* Solution 2*/

--Subquery
SELECT
    skill_id,
    COUNT(job_id) AS total
FROM skills_job_dim
GROUP BY skill_id
ORDER BY COUNT(job_id) DESC
LIMIT 5

--Main Query
SELECT
    s.skills
FROM skills_dim AS s
INNER JOIN (
        SELECT
            skill_id,
            COUNT(job_id) AS total
        FROM skills_job_dim
        GROUP BY skill_id
        ORDER BY COUNT(job_id) DESC
        LIMIT 5
            ) AS t
    ON t.skill_id = s.skill_id
ORDER BY t.total DESC
;

--Practice 2

--Subquery
SELECT
    company_id,
    COUNT(job_id) AS num_post
FROM job_postings_fact
GROUP BY company_id
ORDER BY COUNT(job_id) DESC
;

--Main Query
SELECT
    j.company_id,
    c.name,
    CASE
        WHEN num_post > 50 THEN 'Large'
        WHEN num_post BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Small'
    END AS company_size 
FROM (
    SELECT
        company_id,
        COUNT(job_id) AS num_post
    FROM job_postings_fact
    GROUP BY company_id
    ORDER BY COUNT(job_id) DESC
) AS j
INNER JOIN company_dim AS c
    ON j.company_id = c.company_id
ORDER BY j.company_id 
;

--Practice 3

-- Subquery 1 = Average Salary Each company

SELECT
    company_id,
    AVG(salary_year_avg) AS avg_company
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY company_id
ORDER BY avg_company
;

--Subquery 2 = Average Overall Salary
SELECT
    AVG(salary_year_avg) AS avg_overall
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
;

--Main Query
SELECT
    c.name,
    avgc.avg_company
-- 1st Sub Query
FROM (
    SELECT
        company_id,
        AVG(salary_year_avg) AS avg_company
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
    GROUP BY company_id
    ORDER BY avg_company
) AS avgc
INNER JOIN company_dim AS c
    ON c. company_id = avgc.company_id
-- 2nd Sub Query
WHERE avgc.avg_company > (
    SELECT
        AVG(salary_year_avg) AS avg_overall
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
)
;
/*General Rule:
Single-column subqueries: 
    Used in WHERE, IN, EXISTS, and SELECT clauses.
Multi-column subqueries: 
    Allowed in the FROM clause, JOIN or when creating Common Table Expressions (CTEs)
*/

