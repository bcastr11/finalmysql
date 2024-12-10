-- 1a
USE COMP_BALTAZAR_CASTROLUZ;

-- 1b
SELECT current_user(), now(), database();
SHOW TABLES;

-- 1d
INSERT INTO employee (emp_ssn, emp_last_name, emp_first_name, emp_middle_name, emp_address, emp_city, emp_state, emp_zip, emp_date_of_birth, emp_salary, emp_parking_space, emp_gender, emp_dpt_num, emp_superssn) 
SELECT '111111111', 'Castro', 'Baltazar', NULL, '123 St St.', 'Charlotte', 'NC', '11111', '2003-12-05', 80000, 10, 'M', 7, '999666666'
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE emp_ssn = '111111111');


-- 1e
INSERT INTO dependent (dep_emp_ssn, dep_name, dep_gender, dep_date_of_birth, dep_relationship) 
SELECT '111111111', 'Jane', 'C', '2010-05-15', 'DAUGHTER'
WHERE NOT EXISTS (SELECT 1 FROM dependent WHERE dep_emp_ssn = '111111111' AND dep_name = 'Jane');

-- 1f
SELECT * FROM employee;

-- 1g
SELECT * FROM dependent;

-- 2
SELECT 
    CONCAT(e.emp_first_name, ' ', e.emp_last_name) AS 'Employee Name',
    e.emp_dpt_num AS 'Department Number',
    d.dpt_name AS 'Department Name',
    IFNULL(COUNT(a.work_pro_num), 0) AS '# of Projects',
    NULLIF(SUM(a.work_hours), 0) AS 'Total Actual Hours',
    NULLIF(SUM(a.work_hours_planned), 0) AS 'Total Planned Hours',
    NULLIF(SUM(a.work_hours_planned), 0) - NULLIF(SUM(a.work_hours), 0) AS 'Difference'
FROM 
    employee e
LEFT JOIN 
    assignment a ON e.emp_ssn = a.work_emp_ssn
JOIN 
    department d ON e.emp_dpt_num = d.dpt_no
GROUP BY 
    e.emp_ssn, e.emp_first_name, e.emp_last_name, e.emp_dpt_num, d.dpt_name
ORDER BY 
    e.emp_dpt_num ASC, COUNT(a.work_pro_num) ASC;



-- 3
SELECT 
    e.emp_ssn AS 'Employee SSN',
    CONCAT(e.emp_first_name, ' ', e.emp_last_name) AS 'Employee Name',
    IFNULL(COUNT(a.work_pro_num), 0) AS '# of Projects',
    IFNULL(CONCAT('$ ', FORMAT(SUM(eq.eqp_total_value), 2)), 'NULL') AS 'Equip. Total'
FROM 
    employee e
LEFT JOIN 
    assignment a ON e.emp_ssn = a.work_emp_ssn
LEFT JOIN 
    equipment eq ON a.work_pro_num = eq.eqp_pro_num
GROUP BY 
    e.emp_ssn, e.emp_first_name, e.emp_last_name, e.emp_dpt_num
ORDER BY 
    e.emp_dpt_num ASC, COUNT(a.work_pro_num) ASC;

-- 4
SELECT 
    CONCAT(p.pro_num, ' - ', p.pro_name) AS 'Project',
    IFNULL(SUM(a.work_hours_planned), 0) AS 'Hours Planned',
    IFNULL(SUM(a.work_hours), 0) AS 'Hours Worked',
    ABS(IFNULL(SUM(a.work_hours_planned), 0) - IFNULL(SUM(a.work_hours), 0)) AS 'Difference',
    COUNT(DISTINCT a.work_emp_ssn) AS '# of Employees'
FROM 
    project p
LEFT JOIN 
    assignment a ON p.pro_num = a.work_pro_num
GROUP BY 
    p.pro_num, p.pro_name
HAVING 
    ABS(IFNULL(SUM(a.work_hours_planned), 0) - IFNULL(SUM(a.work_hours), 0)) > 10
ORDER BY 
    'Difference' DESC;

-- 5

SELECT 
    m.emp_ssn AS 'Manager SSN',
    CONCAT(m.emp_first_name, ' ', m.emp_last_name) AS 'Manager Name',
    e.emp_dpt_num AS 'Department',
    d.dpt_name AS 'Department Name',
    e.emp_ssn AS 'Employee SSN',
    CONCAT(e.emp_first_name, ' ', e.emp_last_name) AS 'Employee Name',
    dep.dep_name AS 'Dependent Name',
    dep.dep_relationship AS 'Relationship',
    DATE_FORMAT(dep.dep_date_of_birth, '%M %d, %Y') AS 'Dependent DOB',
    dep.dep_gender AS 'Dep. Gender'
FROM 
    employee e
LEFT JOIN 
    employee m ON e.emp_superssn = m.emp_ssn
JOIN 
    department d ON e.emp_dpt_num = d.dpt_no
LEFT JOIN 
    dependent dep ON e.emp_ssn = dep.dep_emp_ssn
ORDER BY 
    e.emp_dpt_num ASC, e.emp_ssn ASC;


