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
        job_title_short IN ('Data Analyst','Business Analyst') AND
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

/*
Here are the top 10 most in-demand skills based on job postings in 2023:
    SQL (7 mentions) – Most frequently required skill.
    Python (6 mentions) – Strong demand for programming and data analysis.
    Excel (3 mentions) – Still a key tool for data manipulation.
    Looker (3 mentions) – Popular for data visualization.
    Tableau (3 mentions) – Widely used for business intelligence.
    Power BI (3 mentions) – Competing with Tableau for visualization.
    R (3 mentions) – Used for statistical computing.
    Go (2 mentions) – Less common but valued in backend and data engineering.
    Hadoop (2 mentions) – Indicates demand for big data skills.
    Outlook (2 mentions) – Likely related to communication and reporting.

[
  {
    "skill_name": "nosql",
    "job_id": 24675,
    "company_name": "ServiceNow",
    "job_title": "Data Analyst",
    "job_description": "Staff Research Engineer",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "177283.0",
    "job_posted_date": "2023-06-21"
  },
  {
    "skill_name": "azure",
    "job_id": 24675,
    "company_name": "ServiceNow",
    "job_title": "Data Analyst",
    "job_description": "Staff Research Engineer",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "177283.0",
    "job_posted_date": "2023-06-21"
  },
  {
    "skill_name": "aws",
    "job_id": 24675,
    "company_name": "ServiceNow",
    "job_title": "Data Analyst",
    "job_description": "Staff Research Engineer",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "177283.0",
    "job_posted_date": "2023-06-21"
  },
  {
    "skill_name": "spark",
    "job_id": 24675,
    "company_name": "ServiceNow",
    "job_title": "Data Analyst",
    "job_description": "Staff Research Engineer",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "177283.0",
    "job_posted_date": "2023-06-21"
  },
  {
    "skill_name": "hadoop",
    "job_id": 24675,
    "company_name": "ServiceNow",
    "job_title": "Data Analyst",
    "job_description": "Staff Research Engineer",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "177283.0",
    "job_posted_date": "2023-06-21"
  },
  {
    "skill_name": "sql",
    "job_id": 1051496,
    "company_name": "Netflix",
    "job_title": "Data Analyst",
    "job_description": "Analytics Engineer (L5) - Promotional Media - EMEA",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "147500.0",
    "job_posted_date": "2023-07-13"
  },
  {
    "skill_name": "python",
    "job_id": 1051496,
    "company_name": "Netflix",
    "job_title": "Data Analyst",
    "job_description": "Analytics Engineer (L5) - Promotional Media - EMEA",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "147500.0",
    "job_posted_date": "2023-07-13"
  },
  {
    "skill_name": "scala",
    "job_id": 1051496,
    "company_name": "Netflix",
    "job_title": "Data Analyst",
    "job_description": "Analytics Engineer (L5) - Promotional Media - EMEA",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "147500.0",
    "job_posted_date": "2023-07-13"
  },
  {
    "skill_name": "r",
    "job_id": 1051496,
    "company_name": "Netflix",
    "job_title": "Data Analyst",
    "job_description": "Analytics Engineer (L5) - Promotional Media - EMEA",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "147500.0",
    "job_posted_date": "2023-07-13"
  },
  {
    "skill_name": "go",
    "job_id": 1051496,
    "company_name": "Netflix",
    "job_title": "Data Analyst",
    "job_description": "Analytics Engineer (L5) - Promotional Media - EMEA",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "147500.0",
    "job_posted_date": "2023-07-13"
  },
  {
    "skill_name": "sql",
    "job_id": 348471,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Reporting",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111202.0",
    "job_posted_date": "2023-01-02"
  },
  {
    "skill_name": "python",
    "job_id": 348471,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Reporting",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111202.0",
    "job_posted_date": "2023-01-02"
  },
  {
    "skill_name": "r",
    "job_id": 348471,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Reporting",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111202.0",
    "job_posted_date": "2023-01-02"
  },
  {
    "skill_name": "vba",
    "job_id": 348471,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Reporting",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111202.0",
    "job_posted_date": "2023-01-02"
  },
  {
    "skill_name": "pyspark",
    "job_id": 348471,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Reporting",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111202.0",
    "job_posted_date": "2023-01-02"
  },
  {
    "skill_name": "airflow",
    "job_id": 348471,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Reporting",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111202.0",
    "job_posted_date": "2023-01-02"
  },
  {
    "skill_name": "hadoop",
    "job_id": 348471,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Reporting",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111202.0",
    "job_posted_date": "2023-01-02"
  },
  {
    "skill_name": "excel",
    "job_id": 348471,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Reporting",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111202.0",
    "job_posted_date": "2023-01-02"
  },
  {
    "skill_name": "tableau",
    "job_id": 348471,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Reporting",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111202.0",
    "job_posted_date": "2023-01-02"
  },
  {
    "skill_name": "looker",
    "job_id": 348471,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Reporting",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111202.0",
    "job_posted_date": "2023-01-02"
  },
  {
    "skill_name": "sql",
    "job_id": 138295,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Developer Relations",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111175.0",
    "job_posted_date": "2023-01-26"
  },
  {
    "skill_name": "python",
    "job_id": 138295,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Developer Relations",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111175.0",
    "job_posted_date": "2023-01-26"
  },
  {
    "skill_name": "r",
    "job_id": 138295,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Developer Relations",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111175.0",
    "job_posted_date": "2023-01-26"
  },
  {
    "skill_name": "go",
    "job_id": 138295,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Developer Relations",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111175.0",
    "job_posted_date": "2023-01-26"
  },
  {
    "skill_name": "matlab",
    "job_id": 138295,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Developer Relations",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111175.0",
    "job_posted_date": "2023-01-26"
  },
  {
    "skill_name": "looker",
    "job_id": 138295,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Data Analyst, Developer Relations",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111175.0",
    "job_posted_date": "2023-01-26"
  },
  {
    "skill_name": "excel",
    "job_id": 1112483,
    "company_name": "Lucid Motors",
    "job_title": "Data Analyst",
    "job_description": "Material Master Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111175.0",
    "job_posted_date": "2023-02-14"
  },
  {
    "skill_name": "word",
    "job_id": 1112483,
    "company_name": "Lucid Motors",
    "job_title": "Data Analyst",
    "job_description": "Material Master Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111175.0",
    "job_posted_date": "2023-02-14"
  },
  {
    "skill_name": "sap",
    "job_id": 1112483,
    "company_name": "Lucid Motors",
    "job_title": "Data Analyst",
    "job_description": "Material Master Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111175.0",
    "job_posted_date": "2023-02-14"
  },
  {
    "skill_name": "outlook",
    "job_id": 1112483,
    "company_name": "Lucid Motors",
    "job_title": "Data Analyst",
    "job_description": "Material Master Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "111175.0",
    "job_posted_date": "2023-02-14"
  },
  {
    "skill_name": "sql",
    "job_id": 1324347,
    "company_name": "FareHarbor",
    "job_title": "Business Analyst",
    "job_description": "Director of Business Intelligence",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "105300.0",
    "job_posted_date": "2023-07-18"
  },
  {
    "skill_name": "python",
    "job_id": 1324347,
    "company_name": "FareHarbor",
    "job_title": "Business Analyst",
    "job_description": "Director of Business Intelligence",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "105300.0",
    "job_posted_date": "2023-07-18"
  },
  {
    "skill_name": "express",
    "job_id": 1324347,
    "company_name": "FareHarbor",
    "job_title": "Business Analyst",
    "job_description": "Director of Business Intelligence",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "105300.0",
    "job_posted_date": "2023-07-18"
  },
  {
    "skill_name": "tableau",
    "job_id": 1324347,
    "company_name": "FareHarbor",
    "job_title": "Business Analyst",
    "job_description": "Director of Business Intelligence",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "105300.0",
    "job_posted_date": "2023-07-18"
  },
  {
    "skill_name": "power bi",
    "job_id": 1324347,
    "company_name": "FareHarbor",
    "job_title": "Business Analyst",
    "job_description": "Director of Business Intelligence",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "105300.0",
    "job_posted_date": "2023-07-18"
  },
  {
    "skill_name": "excel",
    "job_id": 312839,
    "company_name": "Lucid Motors",
    "job_title": "Data Analyst",
    "job_description": "Service Parts Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "105000.0",
    "job_posted_date": "2023-06-22"
  },
  {
    "skill_name": "sap",
    "job_id": 312839,
    "company_name": "Lucid Motors",
    "job_title": "Data Analyst",
    "job_description": "Service Parts Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "105000.0",
    "job_posted_date": "2023-06-22"
  },
  {
    "skill_name": "powerpoint",
    "job_id": 312839,
    "company_name": "Lucid Motors",
    "job_title": "Data Analyst",
    "job_description": "Service Parts Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "105000.0",
    "job_posted_date": "2023-06-22"
  },
  {
    "skill_name": "outlook",
    "job_id": 312839,
    "company_name": "Lucid Motors",
    "job_title": "Data Analyst",
    "job_description": "Service Parts Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "105000.0",
    "job_posted_date": "2023-06-22"
  },
  {
    "skill_name": "ms access",
    "job_id": 312839,
    "company_name": "Lucid Motors",
    "job_title": "Data Analyst",
    "job_description": "Service Parts Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "105000.0",
    "job_posted_date": "2023-06-22"
  },
  {
    "skill_name": "sql",
    "job_id": 1338696,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Marketing Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "89100.0",
    "job_posted_date": "2023-04-12"
  },
  {
    "skill_name": "python",
    "job_id": 1338696,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Marketing Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "89100.0",
    "job_posted_date": "2023-04-12"
  },
  {
    "skill_name": "sql",
    "job_id": 52153,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Financial Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "89100.0",
    "job_posted_date": "2023-03-09"
  },
  {
    "skill_name": "python",
    "job_id": 52153,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Financial Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "89100.0",
    "job_posted_date": "2023-03-09"
  },
  {
    "skill_name": "power bi",
    "job_id": 52153,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Financial Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "89100.0",
    "job_posted_date": "2023-03-09"
  },
  {
    "skill_name": "looker",
    "job_id": 52153,
    "company_name": "Adyen",
    "job_title": "Data Analyst",
    "job_description": "Financial Data Analyst",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "89100.0",
    "job_posted_date": "2023-03-09"
  },
  {
    "skill_name": "sql",
    "job_id": 917772,
    "company_name": "Amazon.com",
    "job_title": "Business Analyst",
    "job_description": "Senior Business Intelligence Engineer, SCP & EIM",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "89100.0",
    "job_posted_date": "2023-03-28"
  },
  {
    "skill_name": "aws",
    "job_id": 917772,
    "company_name": "Amazon.com",
    "job_title": "Business Analyst",
    "job_description": "Senior Business Intelligence Engineer, SCP & EIM",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "89100.0",
    "job_posted_date": "2023-03-28"
  },
  {
    "skill_name": "redshift",
    "job_id": 917772,
    "company_name": "Amazon.com",
    "job_title": "Business Analyst",
    "job_description": "Senior Business Intelligence Engineer, SCP & EIM",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "89100.0",
    "job_posted_date": "2023-03-28"
  },
  {
    "skill_name": "tableau",
    "job_id": 917772,
    "company_name": "Amazon.com",
    "job_title": "Business Analyst",
    "job_description": "Senior Business Intelligence Engineer, SCP & EIM",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "89100.0",
    "job_posted_date": "2023-03-28"
  },
  {
    "skill_name": "power bi",
    "job_id": 917772,
    "company_name": "Amazon.com",
    "job_title": "Business Analyst",
    "job_description": "Senior Business Intelligence Engineer, SCP & EIM",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "89100.0",
    "job_posted_date": "2023-03-28"
  },
  {
    "skill_name": "qlik",
    "job_id": 917772,
    "company_name": "Amazon.com",
    "job_title": "Business Analyst",
    "job_description": "Senior Business Intelligence Engineer, SCP & EIM",
    "job_location": "Amsterdam, Netherlands",
    "contract_type": "Full-time",
    "yearly_salary": "89100.0",
    "job_posted_date": "2023-03-28"
  }
]

*/ 