--drop table current_emp cascade;
--drop table departments cascade;
--drop table dept_emp cascade;
--drop table dept_manager cascade;
--drop table emp_info cascade;
--drop table employees cascade;
--drop table retirement_info cascade;
--drop table salaries cascade;
--drop table titles cascade;

CREATE TABLE departments (
  dept_no VARCHAR(4) NOT NULL,
  dept_name VARCHAR(40) NOT NULL,
  PRIMARY KEY (dept_no),
  UNIQUE (dept_name)
);

CREATE TABLE employees (
  emp_no INT NOT NULL,
  birth_date DATE NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  gender VARCHAR NOT NULL,
  hire_date DATE NOT NULL,
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, from_date)
);
--drop table retirement_titles;
select e.emp_no, 
	e.first_name, 
	e.last_name, 
	ti.title, 
	ti.from_date, 
	ti.to_date 
INTO retirement_titles
from employees as e
inner join titles as ti
on e.emp_no = ti.emp_no
where (e.birth_date between '1-1-1952' and '12-31-1955')
order by emp_no;
select * from retirement_titles;
-- Use Dictinct with Orderby to remove duplicate rows
select rt.emp_no, rt.first_name, rt.last_name, rt.title into most_recent from retirement_titles as rt
select * from most_recent
drop table most_recent;
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
rt.first_name,
rt.last_name,
rt.title
INTO unique_title
FROM retirement_titles as rt
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;
select * from unique_title;
--drop table retiring_titles
select count(ut.title), ut.title into retiring_titles from unique_title as ut group by ut.title order by count(ut.title) desc;
select * from retiring_titles;

select distinct on(e.emp_no) e.emp_no, 
	e.first_name, 
	e.last_name,
	e.birth_date,
	dept_emp.from_date, 
	dept_emp.to_date, 
	titles.title 
INTO mentorship_eligibility
from employees as e
inner join dept_emp
on e.emp_no = dept_emp.emp_no
inner join titles on (e.emp_no = titles.emp_no)
where dept_emp.to_date = '9999-01-01' and (e.birth_date between '1-1-1965' and '12-31-1965')
order by emp_no;
select * from mentorship_eligibility;

select count(title), title into title_mentorship from mentorship_eligibility group by title order by count(title) desc;
select * from title_mentorship;
 
select distinct on (titles.emp_no) titles.emp_no, titles.title, titles.from_date, titles.to_date, employees.birth_date
into promote_senior_eng
from titles
left join employees on (titles.emp_no = employees.emp_no)
where title = 'Engineer' and to_date = '1-1-9999' and from_date < '1-1-2005' and not (employees.birth_date < '1-1-1960')
order by emp_no;

select distinct on (titles.emp_no) titles.emp_no, titles.title, titles.from_date, titles.to_date, employees.birth_date
into promote_senior_staff
from titles
left join employees on (titles.emp_no = employees.emp_no)
where title = 'Staff' and to_date = '1-1-9999' and from_date < '1-1-2005' and not (employees.birth_date < '1-1-1960')
order by emp_no;
select * from promote_senior_staff;
