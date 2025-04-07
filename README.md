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
A series of insights come from this analysis:
- **SQL is king**: As expected, SQL leads the way (6 mentions), reinforcing its necessity for any data analyst role.
- **Python is nearly as vital** (5 mentions): It’s used for data manipulation, analysis, and increasingly for building data pipelines and automation.
- **Visualization tools matter**:

   - Excel (3) remains essential even in high-paying roles.
   - Looker (3) is clearly in-demand, especially at tech-focused firms like Adyen.
   - Tableau, Power BI, and Airflow appear but only once each—valuable, but not deal-breakers.

- **Statistical languages like R and Go**: Both appear more than once.
- **Cloud & Big Data tools**: mentioning at least once differtent cloud skills (Hadoop, Spark, NoSQL, AWS, Azure), indicates a niche request for data engeneering skills together with data analytics competences.
- **Office tools are still listed**: Word, Outlook, PowerPoint, MS Access—while not “hot tech,” they’re part of standard enterprise data workflows.
![Skills per top paying jobs](/assets/Table%203.png)
*Count of mentions for skills in top paying jobs*

### 4. Trending Skills for Data Analysts in Amsterdam
The following query aims to assess the most in demand skills for Data Analyst in Amsterdam, not focusing on salary parameters as done in the previous query
```sql
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
```
Two immediate deductions can be made from this analysis:
- **SQL and Excel remain fundamental**, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming and Visualization Tools like Python, R, and Tableau are essential**, pointing towards the increasing importance of technical skills in data storytelling and decision support.

![Demand per skill](/assets/Table%204.png)
*Table with demand per skill*

### 5. Top skills based on salary
After having identified the skills associated with the top paying jobs and the global demand for skills in Amsterdam, next analysis focuses on average salary per skill.
```sql
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
```
Here a breakdown of the top 25 paying skills in Amsterdam:
- **Cloud and Big Data skills dominate the top**: AWS, Azure, NoSQL, and Hadoop are extremely valuable.
- **Programming languages like Go and R also command high pay**.
- **Python ($95,442) and SQL ($95,442) are standard must-haves** but don’t drive the highest salary on their own.
- **Excel ($99,469) and Tableau ($111,202) are slightly better compensated**, especially when paired with more technical skills.
- **Airflow, VBA, and Spark sit in a mid-high salary range** ($111K–$122K), great for analysts moving into data engineering workflows.
![Top Paying skills](/assets/Table%205.png)
*Table with top 10 skills per average salary*

### 6. Most optimal skills to learn
Last analysis aims to identify the optimal skills to focus on as to build a career into Data Analytics. For this assessment, previous queries are joined to find the skills that are most in demand and pay the most.
```sql
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
```
![Optimal Skills for Data Analysts](/assets/Table%206.png)
*Scatter Plot made in Excel showing the top 25 skill by Salary and Demand*

Few considerations on the optimal skills:

1. **Programming & Query Languages – Top Priority**
    - *Why it matters*: These are core technical skills. Every data analyst role requires at least one of them.
    - *Key skills*:
        - **Python** – Extremely high demand; versatile and beginner-friendly.
        - **SQL** – The most demanded skill in the market. Essential for data access and wrangling.
        - **R** – Not as universal as Python, but offers strong salaries and is well-respected in statistical fields
    - *Verdict*: **Must-have**. These are foundational skills and open the door to most data roles.
2. **Cloud & Big Data Tools – High Salary, Niche Demand**
    - *Why it matters*: Cloud and big data expertise is becoming increasingly important in data pipelines and enterprise-scale analysis.
    - *Key skills*:
        - **AWS & Azure** – Command some of the highest salaries. Great for analysts working closely with cloud infrastructure or moving toward data engineering.
        - **Spark, Airflow, Hadoop, Pyspark** – Offer excellent pay but are in lower demand compared to core programming/BI tools.
    - *Verdict*: **Strategic advantage**. Worth learning if you're aiming for high-paying roles in larger organizations or want to specialize in data engineering.
3. **Business Intelligence (BI) & Visualization Tools – High Demand & Practical**
    - *Why it matters*: BI tools are **essential for communicating data insights** to stakeholders.
    - *Key skills*:
        - **Tableau** – High in both demand and salary; a great visualization tool for dashboards.
        - **Power BI** – Very popular in enterprise environments; slightly lower pay but very accessible.
        - **Looker** – Gaining traction in modern data stacks.
    - *Verdict*: **Should-have**. If you're focusing on insight delivery and dashboarding, these are a must.
4. **Productivity & Enterprise Tools – Low Strategic Value**
    - *Why it matters*: These are basic tools for workplace communication but don’t offer career growth.
    - *Key skills*:
        - **Excel** – High demand, decent salary. Still heavily used and good to master.
        - **PowerPoint, Word, SAP, VBA** – Often required, but low pay and low differentiation.
    - *Verdict*: **Good to know**, but don’t spend too much effort learning these beyond the basics.

Final takeaways:
- Start with: Python, SQL, Excel
- Add BI tools: Tableau or Power BI
- Level up with cloud/data tools: AWS, Azure, Spark, Airflow

# What I Learnt
I am safe to affirm that during this project I have enhanced my SQL capabilities by:
- **Creating complex queries**: by merging queries and joining tables I learnt how to navigate across data
- **Aggregating data**: I improved my understanding of SQL operators and grouping function to extrapolate key metrics 
- **Delivering actionable insights**: Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions
Using real world data, I tried to optimize my job seeking journey by assessing which is the role to focus my applications and the skills that I need to develop now and in the future to get a career into Data Analytics in Amsterdam. My conclusions are:
- Data Analyst jobs can pay up to € 177 K, making this career path very rewarding from a salary standpoint

- To get a very high salary it is necessary to specialize on niche cloud skills such as AWS or Azure, that are less in demand on the market

- Very few jobs declare the salary in the job posting compared to the totality of the postings. Therefore, due to lack of data this analysis is not perfect, but still valuable.

- SQL is a critical skill both in terms of salary and in terms of demand, making it a must-have to land a job offer and therefore the most optimal skill to learn.
