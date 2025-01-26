/**Question: What are the top-paying data analyst jobs, and what skills are required?** 

- Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
- Filters for roles with specified salaries that are remote
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries
*/

--CTE
WITH top_paying_jobs AS 
(
    SELECT
    job_id,
    job_title,
    salary_year_avg
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
ORDER BY salary_year_avg DESC
LIMIT 10
)

--Main Query
SELECT
    t.job_id,
    t.job_title,
    t.salary_year_avg,
    s.skills
FROM top_paying_jobs AS t
INNER JOIN skills_job_dim AS sj
    ON t.job_id = sj.job_id
INNER JOIN skills_dim AS s
    ON s.skill_id = sj.skill_id
