/* 
Question:what are the top paying skills based on salary in Amsterdam?
- use average salary per skill associated with data analyst and business analsyst
*/


-- Top skills for Data Analyst
SELECT
    skills_dim.skills AS skill_name,
    ROUND( AVG(salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location LIKE '%Amsterdam%'AND
    salary_year_avg IS NOT NULL
GROUP BY
    skill_name
ORDER BY
    avg_salary DESC
LIMIT 25;

/*
[
  {
    "skill_name": "nosql",
    "avg_salary": "177283"
  },
  {
    "skill_name": "aws",
    "avg_salary": "177283"
  },
  {
    "skill_name": "azure",
    "avg_salary": "177283"
  },
  {
    "skill_name": "hadoop",
    "avg_salary": "144243"
  },
  {
    "skill_name": "go",
    "avg_salary": "129338"
  },
  {
    "skill_name": "r",
    "avg_salary": "123292"
  },
  {
    "skill_name": "spark",
    "avg_salary": "122142"
  },
  {
    "skill_name": "vba",
    "avg_salary": "111202"
  },
  {
    "skill_name": "airflow",
    "avg_salary": "111202"
  },
  {
    "skill_name": "tableau",
    "avg_salary": "111202"
  },
  {
    "skill_name": "pyspark",
    "avg_salary": "111202"
  },
  {
    "skill_name": "word",
    "avg_salary": "111175"
  },
  {
    "skill_name": "outlook",
    "avg_salary": "108088"
  },
  {
    "skill_name": "sap",
    "avg_salary": "108088"
  },
  {
    "skill_name": "scala",
    "avg_salary": "107250"
  },
  {
    "skill_name": "ms access",
    "avg_salary": "105000"
  },
  {
    "skill_name": "powerpoint",
    "avg_salary": "105000"
  },
  {
    "skill_name": "looker",
    "avg_salary": "103826"
  },
  {
    "skill_name": "excel",
    "avg_salary": "99469"
  },
  {
    "skill_name": "sql",
    "avg_salary": "95442"
  },
  {
    "skill_name": "python",
    "avg_salary": "95442"
  },
  {
    "skill_name": "matlab",
    "avg_salary": "90838"
  },
  {
    "skill_name": "power bi",
    "avg_salary": "79800"
  },
  {
    "skill_name": "java",
    "avg_salary": "67000"
  },
  {
    "skill_name": "databricks",
    "avg_salary": "67000"
  }
]
*/

-- Top skills for Business Analyst
SELECT
    skills_dim.skills AS skill_name,
    ROUND( AVG(salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Business Analyst' AND
    job_location LIKE '%Amsterdam%'AND
    salary_year_avg IS NOT NULL
GROUP BY
    skill_name
ORDER BY
    avg_salary DESC
LIMIT 25;

/*
[
  {
    "skill_name": "python",
    "avg_salary": "105300"
  },
  {
    "skill_name": "express",
    "avg_salary": "105300"
  },
  {
    "skill_name": "power bi",
    "avg_salary": "97200"
  },
  {
    "skill_name": "aws",
    "avg_salary": "89100"
  },
  {
    "skill_name": "qlik",
    "avg_salary": "89100"
  },
  {
    "skill_name": "redshift",
    "avg_salary": "89100"
  },
  {
    "skill_name": "sql",
    "avg_salary": "85800"
  },
  {
    "skill_name": "tableau",
    "avg_salary": "85800"
  }
]
*/