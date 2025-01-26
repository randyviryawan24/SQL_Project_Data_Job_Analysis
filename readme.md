# Introduction
Welcome to my **SQL Portfolio Project**, where I delve into the **data job market** with a focus on **data analyst roles**. This project is a personal exploration into identifying the top-paying jobs, in-demand skills, and the intersection of high demand with high salary in the field of data analytics.
Check out my SQL queries here:
[**project_file**](/project_file/)
# Background
The motivation behind this project stemmed from my desire to understand the data analyst job market better. I aimed to discover which skills are paid the most and in demand, making my job search more targeted and effective. 

The data for this analysis is from Luke Barousse’s SQL Course **https://lukebarousse.com/sql**. This data includes details on job titles, salaries, locations, and required skills. 

The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn for a data analyst looking to maximize job market value?
# Tools I Used
In this project, I utilized a variety of tools to conduct my analysis:

- **SQL** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.
- **Github**: Essebtial for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking. 
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
ORDER BY salary_year_avg DESC
LIMIT 10
``` 

![Top Paying Roles](assets\Figure_1.png)
*Bar Chart Top Paying Roles*

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
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
```

| job_id  | job_title                                      | salary_year_avg | skills          |
|---------|------------------------------------------------|-----------------|-----------------|
| 552322  | Associate Director- Data Insights              | 255829.5        | sql             |
| 552322  | Associate Director- Data Insights              | 255829.5        | python          |
| 552322  | Associate Director- Data Insights              | 255829.5        | r               |
| 552322  | Associate Director- Data Insights              | 255829.5        | azure           |
| 552322  | Associate Director- Data Insights              | 255829.5        | databricks      |
| 552322  | Associate Director- Data Insights              | 255829.5        | aws             |
| 552322  | Associate Director- Data Insights              | 255829.5        | pandas          |
| 552322  | Associate Director- Data Insights              | 255829.5        | pyspark         |
| 552322  | Associate Director- Data Insights              | 255829.5        | jupyter         |
| 552322  | Associate Director- Data Insights              | 255829.5        | excel           |
| 552322  | Associate Director- Data Insights              | 255829.5        | tableau         |
| 552322  | Associate Director- Data Insights              | 255829.5        | power bi        |
| 552322  | Associate Director- Data Insights              | 255829.5        | powerpoint      |
| 99305   | Data Analyst, Marketing                        | 232423.0        | sql             |
| 99305   | Data Analyst, Marketing                        | 232423.0        | python          |
| 99305   | Data Analyst, Marketing                        | 232423.0        | r               |
| 99305   | Data Analyst, Marketing                        | 232423.0        | hadoop          |
| 99305   | Data Analyst, Marketing                        | 232423.0        | tableau         |
| 1021647 | Data Analyst (Hybrid/Remote)                   | 217000.0        | sql             |
| 1021647 | Data Analyst (Hybrid/Remote)                   | 217000.0        | crystal         |
| 1021647 | Data Analyst (Hybrid/Remote)                   | 217000.0        | oracle          |
| 1021647 | Data Analyst (Hybrid/Remote)                   | 217000.0        | tableau         |
| 1021647 | Data Analyst (Hybrid/Remote)                   | 217000.0        | flow            |
| 168310  | Principal Data Analyst (Remote)               | 205000.0        | sql             |
| 168310  | Principal Data Analyst (Remote)               | 205000.0        | python          |
| 168310  | Principal Data Analyst (Remote)               | 205000.0        | go              |
| 168310  | Principal Data Analyst (Remote)               | 205000.0        | snowflake       |
| 168310  | Principal Data Analyst (Remote)               | 205000.0        | pandas          |
| 168310  | Principal Data Analyst (Remote)               | 205000.0        | numpy           |
| 168310  | Principal Data Analyst (Remote)               | 205000.0        | excel           |
| 168310  | Principal Data Analyst (Remote)               | 205000.0        | tableau         |
| 168310  | Principal Data Analyst (Remote)               | 205000.0        | gitlab          |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | sql             |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | python          |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | azure           |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | aws             |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | oracle          |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | snowflake       |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | tableau         |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | power bi        |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | sap             |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | jenkins         |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | bitbucket       |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | atlassian       |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | jira            |
| 731368  | Director, Data Analyst - HYBRID                | 189309.0        | confluence      |
| 310660  | Principal Data Analyst, AV Performance Analysis| 189000.0        | sql             |
| 310660  | Principal Data Analyst, AV Performance Analysis| 189000.0        | python          |
| 310660  | Principal Data Analyst, AV Performance Analysis| 189000.0        | r               |
| 310660  | Principal Data Analyst, AV Performance Analysis| 189000.0        | git             |
| 310660  | Principal Data Analyst, AV Performance Analysis| 189000.0        | bitbucket       |
| 310660  | Principal Data Analyst, AV Performance Analysis| 189000.0        | atlassian       |
| 310660  | Principal Data Analyst, AV Performance Analysis| 189000.0        | jira            |
| 310660  | Principal Data Analyst, AV Performance Analysis| 189000.0        | confluence      |
| 1749593 | Principal Data Analyst                         | 186000.0        | sql             |
| 1749593 | Principal Data Analyst                         | 186000.0        | python          |
| 1749593 | Principal Data Analyst                         | 186000.0        | go              |
| 1749593 | Principal Data Analyst                         | 186000.0        | snowflake       |
| 1749593 | Principal Data Analyst                         | 186000.0        | pandas          |
| 1749593 | Principal Data Analyst                         | 186000.0        | numpy           |
| 1749593 | Principal Data Analyst                         | 186000.0        | excel           |
| 1749593 | Principal Data Analyst                         | 186000.0        | tableau         |
| 1749593 | Principal Data Analyst                         | 186000.0        | gitlab          |
| 387860  | ERM Data Analyst                               | 184000.0        | sql             |
| 387860  | ERM Data Analyst                               | 184000.0        | python          |
| 387860  | ERM Data Analyst                               | 184000.0        | r               |
*Table Skills for Top Paying Jobs*

### 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand. 

```sql
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
```

![In-Demand Skills](assets\Figure_3.png)
*Bar Chart In-Demand Skills for Data Analyst*
### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
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
```

| skills            | avg_salary   |
|-------------------|--------------|
| svn               | 400000.00    |
| solidity          | 179000.00    |
| couchbase         | 160515.00    |
| datarobot         | 155485.50    |
| golang            | 155000.00    |
| mxnet             | 149000.00    |
| dplyr             | 147633.33    |
| vmware            | 147500.00    |
| terraform         | 146733.83    |
| twilio            | 138500.00    |
| gitlab            | 134126.00    |
| kafka             | 129999.16    |
| puppet            | 129820.00    |
| keras             | 127013.33    |
| pytorch           | 125226.20    |
| perl              | 124685.75    |
| ansible           | 124370.00    |
| hugging face      | 123950.00    |
| tensorflow        | 120646.83    |
| cassandra         | 118406.68    |
| notion            | 118091.67    |
| atlassian         | 117965.60    |
| bitbucket         | 116711.75    |
| airflow           | 116387.26    |
| scala             | 115479.53    |
| linux             | 114883.20    |
| confluence        | 114153.12    |
| pyspark           | 114057.87    |
| mongodb           | 113607.71    |
| aurora            | 113393.90    |
| cordova           | 113269.50    |
| gcp               | 113065.48    |
| spark             | 113001.94    |
| splunk            | 112927.60    |
| databricks        | 112880.74    |
| unify             | 112317.44    |
| git               | 112249.64    |
| dynamodb          | 111840.00    |
| snowflake         | 111577.72    |
| shell             | 111496.45    |
| electron          | 111
*Table Skills Based on Salary*
### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
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
```

| Skills            | Number of Jobs | Avg Salary    |
|-------------------|-----------------|---------------|
| sql               | 398             | 97237.16      |
| excel             | 256             | 87288.21      |
| python            | 236             | 101397.22     |
| tableau           | 230             | 99287.65      |
| r                 | 148             | 100498.77     |
| sas               | 126             | 98902.37      |
| power bi          | 110             | 97431.30      |
| powerpoint        | 58              | 88701.09      |
| looker            | 49              | 103795.30     |
| word              | 48              | 82576.04      |
| oracle            | 37              | 104533.70     |
| snowflake         | 37              | 112947.97     |
| sql server        | 35              | 97785.73      |
| azure             | 34              | 111225.10     |
| aws               | 32              | 108317.30     |
| sheets            | 32              | 86087.79      |
| flow              | 28              | 97200.00      |
| go                | 27              | 115319.89     |
| spss              | 24              | 92169.68      |
| vba               | 24              | 88783.29      |
| hadoop            | 22              | 113192.57     |
| javascript        | 20              | 97587.00      |
| jira              | 20              | 104917.90     |
| sharepoint        | 18              | 81633.58      |
| java              | 17              | 106906.44     |
| alteryx           | 17              | 94144.53      |
| redshift          | 16              | 99936.44      |
| ssrs              | 14              | 99171.43      |
| qlik              | 13              | 99630.81      |
| outlook           | 13              | 90077.42      |
| spark             | 13              | 99076.92      |
| bigquery          | 13              | 109653.85     |
| nosql             | 13              | 101413.73     |
| ssis              | 12              | 106683.33     |
| confluence        | 11              | 114209.91     |
| c++               | 11              | 98958.23      |
| c#                | 10              | 86540.05      |
| visio             | 10              | 95841.55      |
| dax               | 10              | 104500.00     |
| databricks        | 10              | 141906.60     |
| mysql             | 9               | 95223.89      |
| t-sql             | 9               | 96365.00      |
| pandas            | 9               | 151821.33     |
| c                 | 9               | 98937.72      |
| html              | 8               | 86437.50      |
| sap               | 8               | 102919.88     |
| mongodb           | 6               | 66019.67      |
| bash              | 6               | 96558.33      |
| windows           | 6               | 74124.48      |
| spreadsheet       | 6               | 81892.23      |
| ms access         | 6               | 85518.83      |
| matplotlib        | 5               | 76301.40      |
| matlab            | 5               | 94200.00      |
| airflow           | 5               | 126103.00     |
| smartsheet        | 5               | 63000.00      |
| atlassian         | 5               | 131161.80     |
| scala             | 5               | 124903.00     |
| numpy             | 5               | 143512.50     |
| github            | 5               | 91580.00      |
| git               | 5               | 112000.00     |
| crystal           | 5               | 120100.00     |
| planner           | 5               | 76800.00      |
| express           | 4               | 80000.00      |
| ruby              | 4               | 61779.50      |
| powershell        | 4               | 95275.00      |
| db2               | 4               | 114072.13     |
| phoenix           | 4               | 97230.00      |
| cognos            | 4               | 93263.75      |
| microsoft teams   | 4               | 87853.88      |
| plotly            | 4               | 78750.00      |
| postgresql        | 4               | 123878.75     |
| terminal          | 4               | 80625.00      |
| shell             | 3               | 108200.00     |
| gcp               | 3               | 122500.00     |
| gitlab            | 3               | 154500.00     |
| jenkins           | 3               | 125436.33     |
| jupyter           | 3               | 152776.50     |
| seaborn           | 3               | 77500.00      |
| sqlite            | 3               | 89166.67      |
| unix              | 3               | 107666.67     |
| arch              | 2               | 82750.00      |
| julia             | 2               | 71148.00      |
| microstrategy     | 2               | 121619.25     |
| swift             | 2               | 153750.00     |
| spring            | 2               | 82000.00      |
| visual basic      | 2               | 62500.00      |
| scikit-learn      | 2               | 125781.25     |
| webex             | 2               | 81250.00      |
| bitbucket         | 2               | 189154.50     |
| pyspark           | 2               | 208172.25     |
| linux             | 2               | 136507.50     |
| kubernetes        | 2               | 132500.00     |
| datarobot         | 1               | 155485.50     |
| css               | 1               | 52500.00      |
| couchbase         | 1               | 160515.00     |
| colocation        | 1               | 67500.00      |
| twilio            | 1               | 127000.00     |
| unity             | 1               | 95500.00      |
| zoom              | 1               | 80740.00      |
| vb.net            | 1               | 90000.00      |
| clickup           | 1               | 90000.00      |
| chef              | 1               | 85000.00      |
| watson            | 1               | 160515.00     |
| ruby on rails     | 1               | 51059.00      |
| php               | 1               | 95000.00      |
| rust              | 1               | 97500.00      |
| pascal            | 1               | 92000.00      |
| sass              | 1               | 67500.00      |
| notion            | 1               | 125000.00     |
| wire              | 1               | 42500.00      |
| node.js           | 1               | 83500.00      |
| mariadb           | 1               | 95000.00      |
| ibm cloud         | 1               | 111500.00     |
| golang            | 1               | 145000.00     |
| ggplot2           | 1               | 75000.00      |
| erlang            | 1               | 72500.00      |
| elasticsearch     | 1               | 145000.00     |
*Table Most Optimal Skills to Learn*        

# What I Learned
Throughout this project, I honed several key SQL techniques and skills:

- **Complex Query Construction**: Learning to build advanced SQL queries that combine multiple tables and employ functions like **`WITH`** clauses for temporary tables.
- **Data Aggregation**: Utilizing **`GROUP BY`** and aggregate functions like **`COUNT()`** and **`AVG()`** to summarize data effectively.
- **Analytical Thinking**: Developing the ability to translate real-world questions into actionable SQL queries that got insightful answers.
# Conclusions
### **Insights**
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.
### **Closing Thoughts**
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.