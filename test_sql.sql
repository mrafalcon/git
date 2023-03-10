--EXPLAIN PLAN FOR
--select distinct DEPARTMENT_ID, sum(SALARY) from EMP_DETAILS_VIEW
--having sum(salary) >= 5000
--group by DEPARTMENT_ID
select trunc(salary, -3), round(salary, -3) from EMP_DETAILS_VIEW
where JOB_ID like 'ST_%'