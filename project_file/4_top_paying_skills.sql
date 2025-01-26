/**Question: What are the top skills based on salary?** 

- Look at the average salary associated with each skill for Data Analyst positions.
- Focuses on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve.
*/

WITH data_analyst_salary AS
(
SELECT
    job_id,
    salary_year_avg
FROM job_postings_fact
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
)

SELECT
    s.skills,
    ROUND(AVG(da.salary_year_avg),2) AS avg_salary
FROM skills_job_dim AS sj
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
INNER JOIN data_analyst_salary AS da
    ON sj.job_id = da.job_id
GROUP BY s.skills
ORDER BY avg_salary DESC