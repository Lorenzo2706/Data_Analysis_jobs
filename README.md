# ABOUT THE PROJECT

The main goal for this project is to **understand which are the most optimal skills to learn** to get a job as a Data Analyst in Amsterdam. 
The underneath assumption is that a skill can be defined "optimal" whenever is both in demand and highly paid.
In this way, I aim to make my job seeking experience more effective and targeted, avoiding wasting my time in building non relevant skills.

To achieve this objective, I have broken down the overral terget finding into sub-questions:
1) What are the top-paying jobs for my role?
2) What are the skills required for these top-paying roles? 
3) What are the most in-demand skills for my role?
4) What are the top skills based on salary for my role?
5) What are the most optimal skills to learn? (for optimal is intended in high demand and highly paying)

Regarding the dataset, I have used the data from Luke Barousse's course on SQL, which comes from web scraping the main job platforms like Linkdin, Indeed, ect. 

Checkout the SQL queries that I made for the analysis in the [project material folder](/project_material/).


# TOOLS I USED

For my in-depth exploration of the data analyst job market in Amsterdam, I leveraged the following key tools:

- **SQL**: The foundation of my analysis, enabling me to query the database, extract and elaborate valuable insights
- **PostgreSQL**: my open source relational database of choice, due to its characteristics and popularity (check out the [2022 Developer survey by Stack Overflow](/https://survey.stackoverflow.co/2022/#most-popular-technologies-database-prof))
- **Visual Studio Code**: my preferred IDE for executing SQL queries
- **Git & GitHub**: used to create a repository to track, save and share progresses made

# THE ANALYSIS
Each query aims to get valuable insights from the job market, following the structure stated in the project introduction. Each query is duplicated for Data Analyst and Business Analyst roles to ultimately make a comparison useful for future decision.

### 1. Top paying jobs for Analysts in Amsterdam
My first analysis comes in 3 steps/queries:
1. Assessing how many jobs YTD for Data & Business Analyst are in Amsterdam
2. Among these, count how many specify the salary
3. Individuate the top 10 paying jobs for the two roles of interest

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
LIMIT 10;
```


Key Takeaways

-  Tech companies pay the most, with ServiceNow (€177K) and Netflix (€147.5K) leading.
- Business Analyst roles are fewer and pay slightly lower than high-end Data Analyst roles.
- Amsterdam remains a high-paying hub for Data and Business Analytics roles.

m


