# Pewlett-Hackard-Analysis
## Overview
Using the data sets and our SQL queries, we are trying to 
-	1. Find out how many people are about to retire and in what role they are serving. 
-	2. Are there enough experienced employees to mentor the new and current employees for the roles that are about to become available after the current employees retire.
## Results
-	In the file retirement_titles.csv, the employees who are eligible for retirement along with their list of job titles are listed.
-	In the file unique_titles.csv, the recent job titles of the employees who are eligible for retirement are listed
-	In the file retiring_titles.csv the number of employees in each job title who are eligible for retirement is listed. 
-	In the file mentorship_eligibility.csv, the list of employees who are eligible to mentor the new hires can be found
## Summary 
1.	If all employees who are eligible for retirement retire at the same time, the company has to hire total of 72485 people to fill in the open positions.

2.	I used the following query to list the number of employees who are eligible for mentoring based on their job title: 

select count(title), title into title_mentorship from mentorship_eligibility group by title order by count(title) desc
According to my analysis, the majority of employees who are about to retire hold senior positions with senior engineer with 25916 employees has the highest value; however, the number of employees who are eligible to mentor the new hires are not nearly as large (see the graph below) to compare the retiring employee’s vs mentoring employees.

![comparing](/Pewlett-Hackard-Analysis/Data/count_vs_title.png?raw=true "retiring_vs_mentoring")

# Addtional queries:

- 1. I ran the following query to see how many engineers can be promoted to senior engineers. The conditions I emplaced are: 1. The engineer is NOT about to retire, 2. They are currently enrolled as an engineer 3. They have been an engineer before 1/1/2005:

select distinct on (titles.emp_no) titles.emp_no, titles.title, titles.from_date, titles.to_date, employees.birth_date
into promote_senior_eng
from titles
left join employees on (titles.emp_no = employees.emp_no)
where title = 'Engineer' and to_date = '1-1-9999' and from_date < '1-1-2005' and not (employees.birth_date < '1-1-1960')
order by emp_no

According to my analysis 12139 people can be promoted to senior engineers which means there is less need for mentoring.

- 2. I did similar analysis to see how many staff can be promoted to senior staffs: : 1. The staff is NOT about to retire, 2. They are currently enrolled as staff 3. They have been a staff before 1/1/2005

select distinct on (titles.emp_no) titles.emp_no, titles.title, titles.from_date, titles.to_date, employees.birth_date
into promote_senior_staff
from titles
left join employees on (titles.emp_no = employees.emp_no)
where title = 'Staff' and to_date = '1-1-9999' and from_date < '1-1-2005' and not (employees.birth_date < '1-1-1960')
order by emp_no

According to my analysis 9977 people can be promoted to senior staff which means there is less need for mentoring.
