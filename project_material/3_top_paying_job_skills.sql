/*
Question: What skills are required for the top-paying analyst jobs in Amsterdam?
- Use the previous query as CTE
- Add specific skills required
- in this way we obtain an overview on which skills pay the most in Amsterdam
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        name AS company_name,
        job_title_short AS job_title,
        job_title AS job_description,
        job_location,
        job_schedule_type AS contract_type,
        salary_year_avg AS yearly_salary,
        job_posted_date ::DATE
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_location LIKE '%Amsterdam%' AND
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL 
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT
    skills_dim.skills AS skill_name,
    top_paying_jobs.*
FROM top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id 
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY 
    top_paying_jobs.yearly_salary DESC;

