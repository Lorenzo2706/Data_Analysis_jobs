/*
Question: what are the most in demand skills for data analyst and business analysts?
- identify top 5 in-demand skills for data analyst 
- focus on all job postings in Amsterdam
--> valuable insight for job seeking
*/ 


-- Top Skills for Data Analyst in Amsterdam
SELECT
    skills_dim.skills AS skill_name,
    COUNT(job_postings_fact.job_id) AS job_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id 
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location LIKE '%Amsterdam%'
GROUP BY
    skill_name
ORDER BY
    job_count DESC
LIMIT 5;

/*
[
  {
    "skill_name": "sql",
    "job_count": "708"
  },
  {
    "skill_name": "python",
    "job_count": "593"
  },
  {
    "skill_name": "tableau",
    "job_count": "315"
  },
  {
    "skill_name": "r",
    "job_count": "276"
  },
  {
    "skill_name": "excel",
    "job_count": "250"
  }
]
*/

