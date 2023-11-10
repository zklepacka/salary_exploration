SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET SQL_SAFE_UPDATES = 0;
USE salary;

-- SALARY UNDER 30

-- SELECT DATA THAT WE ARE USING 

SELECT gender, age, job_title, education_level, country, salary
FROM salary
WHERE age < 30
ORDER BY gender, age, job_title, education_level, country;

CREATE TABLE salary_copy AS
SELECT * FROM salary;

SELECT * FROM salary_copy; 

-- DETECTING OUTLIERS SALARY

SELECT salary
FROM salary
ORDER BY salary;

DELETE FROM salary_copy WHERE salary <25000;

SELECT salary
FROM salary_copy
ORDER BY salary;

SELECT salary
FROM salary
ORDER BY salary DESC;

-- AVERAGE SALARY under 30

SELECT AVG(salary)
FROM salary;

-- AVERAGE SALARY under 30 by age

DELETE FROM salary_copy WHERE age >= 30; 

SELECT age, AVG(salary) as average_salary
FROM salary_copy
GROUP BY age
ORDER BY age;

-- AVERAGE SALARY under 30 in different jobs

SELECT job_title, age, country ,AVG(salary) as average_salary_by_job
FROM salary_copy
GROUP BY job_title, age
ORDER BY job_title, age, country;


-- 5 JOBS WITH BEST AVERAGE SALARY

SELECT job_title, AVG(salary) AS best_average_salary
FROM salary_copy
GROUP BY job_title
ORDER BY best_average_salary DESC
LIMIT 5;

-- TOP 3 COUNTRIES WITH HISGHEST AVERAGE SALARY UNDER 30

SELECT country, AVG(salary) AS best_countries_average_salary
FROM salary_copy
GROUP BY country
ORDER BY best_countries_average_salary DESC
LIMIT 3;


-- AVERAGE SALARY BY LEVEL OF EDUCATION

SELECT  education_level, AVG(salary)
FROM salary_copy
GROUP BY education_level
ORDER BY education_level;

-- PERCENT OF SALARY OVER 100K UNDER 30

SELECT 
    (COUNT(CASE WHEN salary > 100000 THEN 1 END) / COUNT(*)) * 100 AS percent_u30_over_100k
FROM salary_copy;

-- PERCENT OF SALARY UNDER 50k UNDER 30

SELECT 
    (COUNT(CASE WHEN salary < 50000 THEN 1 END) / COUNT(*)) * 100 AS percent_u30_u_50k
FROM salary_copy;


-- MAX SALARY under 30 female 

SELECT @max :=  MAX(salary) as max_salary FROM salary_copy WHERE gender = "female";
SELECT age, gender, job_title, salary FROM salary_copy WHERE salary = @max AND gender ="female"
ORDER BY age;

-- MAX SALARY under 30 male in USA

SELECT @max :=  MAX(salary) as max_salary FROM salary_copy WHERE gender = "male";
SELECT age, gender, job_title, salary FROM salary_copy WHERE salary = @max AND gender ="male"
ORDER BY age;

-- MIN SALARY under 30 female in USA

SELECT @min :=  MIN(salary) as min_salary FROM salary_copy WHERE gender = "female";
SELECT age, gender, job_title, salary FROM salary_copy WHERE salary = @min AND gender ="female"
ORDER BY age;

-- MIN SALARY under 30 male in USA

SELECT @min :=  MIN(salary) as min_salary FROM salary_copy WHERE gender = "male";
SELECT age, gender, job_title, salary FROM salary_copy WHERE salary = @min AND gender ="male"
ORDER BY age;

-- AVERAGE FEMALE'S SALARY

SELECT gender, AVG(salary) as avg_female_salary
FROM salary_copy
WHERE gender = "female";

-- AVERAGE MALE'S SALARY

SELECT gender, AVG(salary) as avg_male_salary
FROM salary_copy
WHERE gender = "male";

-- PERCENT OF FEMALE UNDER 30 ABOVE AVERAGE SALARY
SELECT
    (COUNT(CASE WHEN gender = 'female' AND salary > (SELECT AVG(salary) FROM salary_copy) THEN 1 END) / COUNT(CASE WHEN gender = 'female' THEN 1 END)) * 100 AS percent_female_above_avg_salary
FROM salary_copy;

-- PERCENT OF MALE UNDER 30 ABOVE AVERAGE SALARY

SELECT
    (COUNT(CASE WHEN gender = 'male' AND salary > (SELECT AVG(salary) FROM salary_copy) THEN 1 END) / COUNT(CASE WHEN gender = 'male' THEN 1 END)) * 100 AS percent_male_above_avg_salary
FROM salary_copy;

-- PERCENT OF FEMALE UNDER 30 ABOVE MALE'S AVERAGE SALARY

SELECT
    (COUNT(CASE WHEN gender = 'female' AND salary > (SELECT AVG(salary) FROM salary_copy  WHERE gender = "male") THEN 1 END) / COUNT(CASE WHEN gender = 'female' THEN 1 END)) * 100 AS percent_female_above_male_avg_salary
FROM salary_copy;

-- PERCENT OF MALE UNDER 30 ABOVE FEMALES'S AVERAGE SALARY

SELECT
    (COUNT(CASE WHEN gender = 'male' AND salary > (SELECT AVG(salary) FROM salary_copy  WHERE gender = "female") THEN 1 END) / COUNT(CASE WHEN gender = 'male' THEN 1 END)) * 100 AS percent_male_above_female_avg_salary
FROM salary_copy;


-- QUARTILES AND IQR FOR GENDERS

SELECT gender, salary, NTILE(4) OVER (PARTITION BY gender ORDER BY salary) AS Quartile
FROM salary_copy;
    
SELECT gender,
	MIN(salary) as Minimum,
	MAX(CASE WHEN Quartile = 1 THEN salary END) as 1Quartile,
	MAX(CASE WHEN Quartile = 2 THEN salary END) as Median,
	MAX(CASE WHEN Quartile = 3 THEN salary END) as 3Quartile,
	MAX(salary) as Maximum, 
    ((MAX(CASE WHEN Quartile = 3 THEN salary END)) - (MAX(CASE WHEN Quartile = 1 THEN salary END))) IQR
    
FROM (
	SELECT gender, salary, NTILE(4) OVER (PARTITION BY gender ORDER BY salary) AS Quartile
	FROM salary_copy
) Vals
GROUP BY gender;



    













