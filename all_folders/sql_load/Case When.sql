--Practice Problem 1
SELECT
    job_id,
    job_title,
    salary_year_avg,
    CASE
        WHEN salary_year_avg >=100000 THEN 'High salary'
        WHEN salary_year_avg >=60000 THEN 'Medium salary'
        ELSE 'Low Salary'
    END AS group_salary
FROM job_postings_fact
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC;

--Practice Problem 2
SELECT
    CASE 
    WHEN job_work_from_home = TRUE THEN 'WFH'
    ELSE 'Onsite'
    END AS wfh_category,
    COUNT (DISTINCT company_id)
FROM job_postings_fact
GROUP BY wfh_category;

/*Another Solution*/

SELECT
    COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS wfh_category,
    COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS non_wfh_category
FROM job_postings_fact
;

--Practice Problem 3
SELECT
    job_id,
    salary_year_avg,
    CASE
        WHEN job_title ILIKE 'Senior' THEN 'Senior'
        WHEN job_title ILIKE 'Manager' THEN 'Lead/Manager'
        WHEN job_title ILIKE 'Lead' THEN 'Lead/Manager'
        WHEN job_title ILIKE 'Junior' THEN 'Junior/Entry'
        WHEN job_title ILIKE 'Entry' THEN 'Entry'
        ELSE 'Not Specified'
    END AS experience_level,
    CASE 
        WHEN job_work_from_home = TRUE THEN 'YES'
        ELSE 'NO'
    END AS remote_option
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY job_id
;
