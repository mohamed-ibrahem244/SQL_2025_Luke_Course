WITH skills_demand AS (
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
)

, average_salary AS(
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg),0) AS salary

    FROM
        job_postings_fact

    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

    WHERE 
        job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id
 

)

SELECT
    skills_demand.skills, 
    demand_count, 
    salary
FROM skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY demand_count DESC, salary DESC
LIMIT 25





