# ABOUT THE PROJECT

The main goal for this project is to **understand which are the most optimal skills to learn** to get a job as a Data Analyst in Amsterdam. 
The underneath assumptions are:
1. The selected location is Amsterdam, Netherlands. I'm not going to assess whether this is the best paying location for analyst role.
2. A skill can be defined "optimal" whenever is both in demand and highly paid.
3. I will focus just on Data Analyst and Business Analyst roles, since they are the ones I'm currently the most interested into

The rationale behind is to make my job seeking experience more effective and targeted, avoiding wasting my time in building non relevant skills.

To achieve this objective, I have broken down the overral terget finding into sub-questions:
1) *Which job pays the most between Data Analyst and Business Analyst?*  First step is to decide where to focus my research.
2) *What are the top-paying jobs for the selected jobs?* The assumption is that the highest paid jobs are representative to assess the best skills to learn
3) *What are the skills required for these top-paying jobs?* 
4) *What are the most in-demand skills for my role?*
5) *What are the top skills based on salary for my role?*
6) *What are the most optimal skills to learn?* For optimal is intended in high demand and highly paying

Regarding the dataset, I have used the data from Luke Barousse's course on SQL, which comes from real world data obtained bt web scraping the main job platforms like Linkdin, Indeed, ect. 

Checkout the SQL queries that I made for the analysis in the [project material folder](/project_material/).


# TOOLS I USED

For my in-depth exploration of the data analyst job market in Amsterdam, I leveraged the following key tools:

- **SQL**: The foundation of my analysis, enabling me to query the database, extract and elaborate valuable insights
- **PostgreSQL**: my open source relational database of choice, due to its characteristics and popularity (check out the [2022 Developer survey by Stack Overflow](/https://survey.stackoverflow.co/2022/#most-popular-technologies-database-prof))
- **Visual Studio Code**: my preferred IDE for executing SQL queries
- **Git & GitHub**: used to create a repository to track, save and share progresses made

# THE ANALYSIS
Each query aims to get valuable insights from the job market, following the structure stated in the project introduction. Each query is duplicated for Data Analyst and Business Analyst roles to ultimately make a comparison useful for future decision.

### 1. Top paying role for analysts in Amsterdam
My first analysis comes in 3 steps/queries:
1. Assessing how many jobs YTD for Data & Business Analyst are in Amsterdam
2. Among these, count how many specify the salary
3. Compare Data Analyst key statistics with Business Analyst's

  **1 - Job Count for both roles**
```SQL
SELECT
    count(job_id)
FROM 
    job_postings_fact
WHERE 
    job_location LIKE '%Amsterdam%' AND
    job_title_short IN ('Data Analyst', 'Business Analyst');
```
The total number of jobs for either Data Analyst or Business Analyst is 1607

  **2 - Filter out job postings with no salary listed**
```sql

SELECT
    count(job_id)
FROM 
    job_postings_fact
WHERE 
    job_location LIKE '%Amsterdam%' AND
    job_title_short IN ('Data Analyst', 'Business Analyst') AND
    salary_year_avg IS NOT NULL;
```
Among those 1607 jobs, only 14 have specified the salary


```sql
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
    COUNT(job_id) AS job_count,
    ROUND (AVG(salary_year_avg)) AS avg_salary,
    median_salary.median
FROM job_postings_fact
LEFT JOIN median_salary ON job_postings_fact.job_title_short = median_salary.job_title_short
WHERE 
    job_location LIKE '%Amsterdam%' AND
    job_postings_fact.job_title_short IN ('Data Analyst', 'Business Analyst') AND
    salary_year_avg IS NOT NULL
GROUP BY
    role,
    median_salary.median;
```
![Data analyst vs Business Analyst](/assets/Table%201.png)
*Table from the last query showcasing key data for comparisons between roles*


#### Key Takeaways:
- **Data Analyst is the better role** in terms of salary and job availability.
- The **higher demand for Data Analysts** makes it a more stable career choice.
- However, **Business Analysts may have different responsibilities** (strategy, operations), which could align better with non-technical career paths.

### 2. Top paying jobs for Data Analyst
After having chosen to focus on Data Analyst roles only, next step is to identify the top paying jobs in this category, filtering by position, location and salary specified.
```sql
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
```
The evidences from this analysis suggest that:
- **Salary Range & Distribution**: Salaries span from €67K to €177K, showing the possibility of a rewarding career oppurtunities. The distribution shows clear salary bands: top-tier roles involve hybrid skills (data + engineering), mid-tier reflects experienced analysts, and lower-tier roles are entry-level or specialist.
- **Industry Trends**: Tech & SaaS firms (ServiceNow, Netflix) dominate the high end of the pay scale. Fintech (Adyen) and automotive (Lucid Motors) offer steady mid-to-high salaries. Energy (Vattenfall) and AI/Cloud (Databricks) present opportunities at the lower end—likely due to role type (e.g. junior, internship) rather than industry valuation.
- **Seniority Trends**: The highest salaries are tied to senior or hybrid roles, likely involving core Data Analysts capabilities together with  engineering, leadership, or cross-functional skills. Mid-level roles remain strong around €105K–€111K, while entry-level positions sit below €90K. A clear pattern seems to emerge: more technical + strategic = higher compensation. The next steps of the analysis will try to validate this point.

![Top Paying Jobs in Amsterdam](/assets/Table%202.png)
*Bar chart showing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from my SQL query results*

### 3. Skills for top paying jobs
Once identified top paying jobs, it is time to find the associated skills that are required for applying to these offerings. To do that, I joined the job posting table with the skills table and counted the skills mentioned.
```sql
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
```

