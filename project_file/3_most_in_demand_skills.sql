/**Question: What are the most in-demand skills for data analysts?**

- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, providing insights into the most valuable skills for job seekers.
*/


SELECT
    s.skills,
    COUNT(*) AS num_jobs
FROM skills_job_dim AS sj
INNER JOIN skills_dim AS s
    ON sj.skill_id = s.skill_id
WHERE sj.job_id IN 
    (
        SELECT job_id
        FROM job_postings_fact
        WHERE job_title_short = 'Data Analyst'
    )
GROUP BY s.skills
ORDER BY num_jobs DESC
LIMIT 5

