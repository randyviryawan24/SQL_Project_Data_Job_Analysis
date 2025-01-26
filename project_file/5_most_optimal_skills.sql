/**Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?** 

- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis
*/

WITH data_analyst_salary AS
(
SELECT
    job_id,
    salary_year_avg
FROM job_postings_fact
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
)

SELECT
    s.skills,
    COUNT(*) AS num_jobs,
    ROUND(AVG(da.salary_year_avg),2) AS avg_salary
FROM skills_job_dim AS sj
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
INNER JOIN data_analyst_salary AS da
    ON sj.job_id = da.job_id
GROUP BY s.skills
ORDER BY num_jobs DESC
