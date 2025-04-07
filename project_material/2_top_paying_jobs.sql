/*
Question: What are the top-paying data or business analyst jobs in Amsterdam (2023 data)?
- Identify the top 10 highest-paying Analyst roles for Data Anlysts that are 
available in Amsterdam.
- Focuses on job postings with specified salaries.
- Why? Aims to highlight the top-paying opportunities for Analysts, offering 
insights into employment options in Amsterdam.
*/



-- Top 10 Analyst roles in Amsterdam

SELECT
    job_id,
    name AS company_name,
    job_title_short AS job_title,
    job_title AS job_description,
    job_schedule_type AS contract_type,
    salary_year_avg AS yearly_salary,
    job_posted_date ::DATE,
    job_location
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_location LIKE '%Amsterdam%' AND
    job_title_short IN ('Data Analyst') AND
    salary_year_avg IS NOT NULL 
ORDER BY
    salary_year_avg DESC
LIMIT 10;



