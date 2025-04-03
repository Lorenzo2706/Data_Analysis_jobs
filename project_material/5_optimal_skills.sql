/*
What are the most optimal skills (meaning in high demand and high salary) skills 
to learn to get a job in Amsterdam as Data Analyst and Business Analyst?
- create 2 queries for each job type by linking former insights
*/

-- Data Analyst
WITH skill_demand AS (
SELECT
    skills_dim.skill_id,
    skills_dim.skills AS skill_name,
    COUNT(job_postings_fact.job_id) AS demand
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id 
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location LIKE '%Amsterdam%'
GROUP BY
    skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg),0) AS avg_salary
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location LIKE '%Amsterdam%'AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id
)
SELECT
    skill_demand.skill_id,
    skill_demand.skill_name,
    skill_demand.demand,
    average_salary.avg_salary
FROM
    skill_demand
INNER JOIN average_salary ON skill_demand.skill_id = average_salary.skill_id
WHERE
    demand > 10
ORDER BY
    avg_salary DESC,
    demand
LIMIT 25;

--Business Analyst
WITH skill_demand AS (
SELECT
    skills_dim.skill_id,
    skills_dim.skills AS skill_name,
    COUNT(job_postings_fact.job_id) AS demand
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id 
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Business Analyst' AND
    job_location LIKE '%Amsterdam%'
GROUP BY
    skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg),0) AS avg_salary
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_title_short = 'Business Analyst' AND
        job_location LIKE '%Amsterdam%'AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id
)
SELECT
    skill_demand.skill_id,
    skill_demand.skill_name,
    skill_demand.demand,
    average_salary.avg_salary
FROM
    skill_demand
INNER JOIN average_salary ON skill_demand.skill_id = average_salary.skill_id
ORDER BY
    avg_salary DESC,
    demand
LIMIT 25;

