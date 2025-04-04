


-- First assessment: how many jobs are in Amsterdam for data Analyst?
SELECT
    count(job_id)
FROM 
    job_postings_fact
WHERE 
    job_location LIKE '%Amsterdam%' AND
    job_title_short IN ('Data Analyst', 'Business Analyst');
-- Answer:1607


-- Second Assessment: how many have salary in the job posting?
SELECT
    count(job_id)
FROM 
    job_postings_fact
WHERE 
    job_location LIKE '%Amsterdam%' AND
    job_title_short IN ('Data Analyst', 'Business Analyst') AND
    salary_year_avg IS NOT NULL;
-- only 14

-- Statistics for Data Analyst and Business Analyst roles in Amsterdam
WITH median_salary AS (
    SELECT
        DISTINCT PERCENTILE_CONT(0.5) 
    WITHIN GROUP (ORDER BY salary_year_avg) AS median,
        job_title_short
    FROM job_postings_fact
    WHERE 
        job_title_short IN ('Data Analyst', 'Business Analyst') AND
        job_location LIKE '%Amsterdam%'  AND 
        salary_year_avg IS NOT NULL
    GROUP BY
        job_title_short
)
SELECT
    job_postings_fact.job_title_short AS role,
    median_salary.median,
    AVG(salary_year_avg) AS avg_salary,
    COUNT(job_id) AS job_count
FROM job_postings_fact
LEFT JOIN median_salary ON job_postings_fact.job_title_short = median_salary.job_title_short
WHERE 
    job_location LIKE '%Amsterdam%' AND
    job_postings_fact.job_title_short IN ('Data Analyst', 'Business Analyst') AND
    salary_year_avg IS NOT NULL
GROUP BY
    role,
    median_salary.median;
