prompt PL/SQL Developer import file
prompt Created on Saturday, October 22, 2016 by Alexandru
set feedback off
set define off
prompt Disabling triggers for DEPARTMENTS...
alter table DEPARTMENTS disable all triggers;
prompt Disabling triggers for EMPLOYEES...
alter table EMPLOYEES disable all triggers;
prompt Disabling triggers for APP_USERS...
alter table APP_USERS disable all triggers;
prompt Disabling triggers for REQUEST_TYPES...
alter table REQUEST_TYPES disable all triggers;
prompt Disabling triggers for DAYS_PER_MONTH...
alter table DAYS_PER_MONTH disable all triggers;
prompt Disabling triggers for DAYS_PER_YEAR...
alter table DAYS_PER_YEAR disable all triggers;
prompt Disabling triggers for DEPT_REQUIREMENTS...
alter table DEPT_REQUIREMENTS disable all triggers;
prompt Disabling triggers for LEGAL_DAYS...
alter table LEGAL_DAYS disable all triggers;
prompt Disabling triggers for PASSED_ATTRIBUTIONS...
alter table PASSED_ATTRIBUTIONS disable all triggers;
prompt Disabling triggers for STATUS_TYPES...
alter table STATUS_TYPES disable all triggers;
prompt Disabling triggers for POSSIBLE_STATUS_CHANGE...
alter table POSSIBLE_STATUS_CHANGE disable all triggers;
prompt Disabling triggers for REQUESTS...
alter table REQUESTS disable all triggers;
prompt Disabling triggers for RESTANT_DAYS...
alter table RESTANT_DAYS disable all triggers;
prompt Disabling triggers for ROLE_TYPES...
alter table ROLE_TYPES disable all triggers;
prompt Disabling triggers for SKILL_TYPES...
alter table SKILL_TYPES disable all triggers;
prompt Disabling triggers for SKILL_MATRIX...
alter table SKILL_MATRIX disable all triggers;
prompt Disabling triggers for SL_ERRORS...
alter table SL_ERRORS disable all triggers;
prompt Disabling triggers for STANDARD_NOTIFICATIONS...
alter table STANDARD_NOTIFICATIONS disable all triggers;
prompt Disabling triggers for USER_ATRIBUTIONS...
alter table USER_ATRIBUTIONS disable all triggers;
prompt Disabling triggers for USER_CREDENTIALS...
alter table USER_CREDENTIALS disable all triggers;
prompt Disabling foreign key constraints for DEPARTMENTS...
alter table DEPARTMENTS disable constraint SYS_C0010533;
prompt Disabling foreign key constraints for EMPLOYEES...
alter table EMPLOYEES disable constraint FK_DEPT_ID;
alter table EMPLOYEES disable constraint FK_MANAGER_ID;
prompt Disabling foreign key constraints for APP_USERS...
alter table APP_USERS disable constraint FK_EMP_ID;
prompt Disabling foreign key constraints for DAYS_PER_MONTH...
alter table DAYS_PER_MONTH disable constraint FK_REQ_DAY_P_MONTH;
prompt Disabling foreign key constraints for PASSED_ATTRIBUTIONS...
alter table PASSED_ATTRIBUTIONS disable constraint FK_DEPARTMENT_ID;
alter table PASSED_ATTRIBUTIONS disable constraint FK_GIVER_ID;
alter table PASSED_ATTRIBUTIONS disable constraint FK_RECEIVER_ID;
prompt Disabling foreign key constraints for POSSIBLE_STATUS_CHANGE...
alter table POSSIBLE_STATUS_CHANGE disable constraint FK_CURR_STATE;
alter table POSSIBLE_STATUS_CHANGE disable constraint FK_FUTURE_STATE;
prompt Disabling foreign key constraints for REQUESTS...
alter table REQUESTS disable constraint REJ_USR_FK;
alter table REQUESTS disable constraint RES_USR_FK;
alter table REQUESTS disable constraint STATUS_REQ_FK;
prompt Disabling foreign key constraints for SKILL_MATRIX...
alter table SKILL_MATRIX disable constraint FK_EMP_ID_SKMATRIX;
alter table SKILL_MATRIX disable constraint FK_SKILL_CODE;
prompt Disabling foreign key constraints for USER_ATRIBUTIONS...
alter table USER_ATRIBUTIONS disable constraint SYS_C0011718;
alter table USER_ATRIBUTIONS disable constraint SYS_C0011719;
prompt Disabling foreign key constraints for USER_CREDENTIALS...
alter table USER_CREDENTIALS disable constraint FK_USER_CRED_NAME_FK;
prompt Truncating USER_CREDENTIALS...
truncate table USER_CREDENTIALS;
prompt Truncating USER_ATRIBUTIONS...
truncate table USER_ATRIBUTIONS;
prompt Truncating STANDARD_NOTIFICATIONS...
truncate table STANDARD_NOTIFICATIONS;
prompt Truncating SL_ERRORS...
truncate table SL_ERRORS;
prompt Truncating SKILL_MATRIX...
truncate table SKILL_MATRIX;
prompt Truncating SKILL_TYPES...
truncate table SKILL_TYPES;
prompt Truncating ROLE_TYPES...
truncate table ROLE_TYPES;
prompt Truncating RESTANT_DAYS...
truncate table RESTANT_DAYS;
prompt Truncating REQUESTS...
truncate table REQUESTS;
prompt Truncating POSSIBLE_STATUS_CHANGE...
truncate table POSSIBLE_STATUS_CHANGE;
prompt Truncating STATUS_TYPES...
truncate table STATUS_TYPES;
prompt Truncating PASSED_ATTRIBUTIONS...
truncate table PASSED_ATTRIBUTIONS;
prompt Truncating LEGAL_DAYS...
truncate table LEGAL_DAYS;
prompt Truncating DEPT_REQUIREMENTS...
truncate table DEPT_REQUIREMENTS;
prompt Truncating DAYS_PER_YEAR...
truncate table DAYS_PER_YEAR;
prompt Truncating DAYS_PER_MONTH...
truncate table DAYS_PER_MONTH;
prompt Truncating REQUEST_TYPES...
truncate table REQUEST_TYPES;
prompt Truncating APP_USERS...
truncate table APP_USERS;
prompt Truncating EMPLOYEES...
truncate table EMPLOYEES;
prompt Truncating DEPARTMENTS...
truncate table DEPARTMENTS;
prompt Loading DEPARTMENTS...
insert into DEPARTMENTS (dep_id, code, active, no_of_main_emp, no_of_res, tm_id, description, no_of_employees)
values (1, 'HR', 'D', 1, 0, 1, 'Human Resources', 1);
insert into DEPARTMENTS (dep_id, code, active, no_of_main_emp, no_of_res, tm_id, description, no_of_employees)
values (2, 'DEVELOPMENT', 'D', 7, 2, 1, 'Development', 9);
insert into DEPARTMENTS (dep_id, code, active, no_of_main_emp, no_of_res, tm_id, description, no_of_employees)
values (3, 'TESTING', 'D', 7, 1, 4, 'Testing', 8);
insert into DEPARTMENTS (dep_id, code, active, no_of_main_emp, no_of_res, tm_id, description, no_of_employees)
values (4, 'ATLAS', 'D', 2, 1, 30, 'Atlas', 3);
insert into DEPARTMENTS (dep_id, code, active, no_of_main_emp, no_of_res, tm_id, description, no_of_employees)
values (5, 'INFINICA', 'D', 2, 1, 33, 'Infinica', 3);
insert into DEPARTMENTS (dep_id, code, active, no_of_main_emp, no_of_res, tm_id, description, no_of_employees)
values (6, 'ERROR_HANDLING', 'D', 4, 2, 1, 'Error Handling', 6);
insert into DEPARTMENTS (dep_id, code, active, no_of_main_emp, no_of_res, tm_id, description, no_of_employees)
values (8, 'LIMBO', 'D', 0, 0, null, 'Limbo', 0);
insert into DEPARTMENTS (dep_id, code, active, no_of_main_emp, no_of_res, tm_id, description, no_of_employees)
values (7, 'PROJECT_MANAGER', 'D', 2, 0, 4, 'Management', 2);
commit;
prompt 8 records loaded
prompt Loading EMPLOYEES...
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (25, 'Alexandru', 'Neagoe', 'goe.alexander@gmail.com', to_date('07-04-2016', 'dd-mm-yyyy'), 1, 2, 'D');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (47, 'Vali', 'Chihaia', 'vali.chihaia@sinoptix.com', to_date('03-02-2016', 'dd-mm-yyyy'), 1, 2, 'D');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (33, 'Sergiu', 'Atomi', 'sergiu.atomi@sinoptix.com', to_date('01-06-2015', 'dd-mm-yyyy'), 1, 5, 'N');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (39, 'Andreea', 'Nenciu', 'andreea.nenciu@sinoptix.com', to_date('01-09-2015', 'dd-mm-yyyy'), 1, 2, 'N');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (1, 'AD', 'MIN', 'GOE.ALEXANDER@GMAIL.COM', to_date('01-01-2015', 'dd-mm-yyyy'), 1, 2, 'N');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (2, 'ALEX', 'VALENTIN', 'GOE.ALEXANDER@HOTMAIL.CO.UK', to_date('01-06-2015', 'dd-mm-yyyy'), 1, 2, 'N');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (38, 'Andreea', 'Nenciu', 'andreea.nenciu@sinoptix.com', to_date('01-08-2014', 'dd-mm-yyyy'), 1, 2, 'N');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (34, 'Daniel', 'Sandu', 'Dani.Sandu@gmail.com', to_date('01-05-2014', 'dd-mm-yyyy'), 1, 6, 'N');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (46, 'Claudiu', 'Brehoi', 'claudiu.brehoi@gmail.com', to_date('22-07-2016', 'dd-mm-yyyy'), 4, 6, 'N');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (48, 'Emanuel', 'Cambos Desperados', 'emanuel.desperados@sinoptix.com', to_date('03-01-2016', 'dd-mm-yyyy'), 1, 2, 'N');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (4, 'MARIUS', 'SEF', 'Marius.sef@gmail.com', to_date('02-08-2015', 'dd-mm-yyyy'), null, 7, 'N');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (42, 'Carmen', 'Buta', 'carmenB@sinoptix.com', to_date('13-10-2015', 'dd-mm-yyyy'), 33, 5, 'D');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (0, 'ADMIN', null, 'admin@admin.com', to_date('16-03-1989', 'dd-mm-yyyy'), null, 3, 'N');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (28, 'Florin', 'Muntean', 'florin.muntean@sinoptix.com', to_date('12-01-2015', 'dd-mm-yyyy'), 1, 5, 'N');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (30, 'Ciprian', 'Asmarandei', 'dan.muntean@sinoptix.com', to_date('12-01-2015', 'dd-mm-yyyy'), 1, 4, 'N');
insert into EMPLOYEES (emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period)
values (35, 'Carmen', 'Buta', 'carmenB@sinoptix.com', to_date('08-07-2015', 'dd-mm-yyyy'), 1, 1, 'N');
commit;
prompt 16 records loaded
prompt Loading APP_USERS...
insert into APP_USERS (id, code, emp_id, active)
values (4, 'ANONYMOUS', 1, 'D');
insert into APP_USERS (id, code, emp_id, active)
values (5, 'MARIUS.HR', 4, 'D');
insert into APP_USERS (id, code, emp_id, active)
values (0, 'ADMIN', 1, 'D');
insert into APP_USERS (id, code, emp_id, active)
values (3, 'MARIUS.SEF', 4, 'D');
commit;
prompt 4 records loaded
prompt Loading REQUEST_TYPES...
insert into REQUEST_TYPES (type_id, req_code, active, requires_flux, req_description)
values (1, 'MEDICAL_LEAVE', 'D', 'N', 'Medical Leave');
insert into REQUEST_TYPES (type_id, req_code, active, requires_flux, req_description)
values (2, 'VACATION_LEAVE', 'D', 'D', 'Vacation Leave');
insert into REQUEST_TYPES (type_id, req_code, active, requires_flux, req_description)
values (3, 'CULTURAL_HOLIDAY', 'D', 'N', 'Cultural Holiday');
insert into REQUEST_TYPES (type_id, req_code, active, requires_flux, req_description)
values (4, 'UNPAID_LEAVE', 'D', 'D', 'Unpaid Leave');
insert into REQUEST_TYPES (type_id, req_code, active, requires_flux, req_description)
values (5, 'RESTANT_LEAVE', 'D', 'N', 'Restant Leave');
commit;
prompt 5 records loaded
prompt Loading DAYS_PER_MONTH...
insert into DAYS_PER_MONTH (req_code, no_of_days)
values ('VACATION_LEAVE', 2);
commit;
prompt 1 records loaded
prompt Loading DAYS_PER_YEAR...
insert into DAYS_PER_YEAR (req_code, max_no_days)
values ('MEDICAL_LEAVE', 183);
insert into DAYS_PER_YEAR (req_code, max_no_days)
values ('VACATION_LEAVE', 23);
insert into DAYS_PER_YEAR (req_code, max_no_days)
values ('CULTURAL_HOLIDAY', 5);
insert into DAYS_PER_YEAR (req_code, max_no_days)
values ('LEGAL_DAYS', 13);
insert into DAYS_PER_YEAR (req_code, max_no_days)
values ('UNPAID_LEAVE', null);
commit;
prompt 5 records loaded
prompt Loading DEPT_REQUIREMENTS...
insert into DEPT_REQUIREMENTS (code, start_date, end_date, required_people, accepted_deficit)
values ('HR', to_date('01-06-2015', 'dd-mm-yyyy'), to_date('30-06-2015', 'dd-mm-yyyy'), 1, 1);
insert into DEPT_REQUIREMENTS (code, start_date, end_date, required_people, accepted_deficit)
values ('DEVELOPMENT', to_date('01-06-2015', 'dd-mm-yyyy'), to_date('30-06-2015', 'dd-mm-yyyy'), 9, 1);
insert into DEPT_REQUIREMENTS (code, start_date, end_date, required_people, accepted_deficit)
values ('TESTING', to_date('01-06-2015', 'dd-mm-yyyy'), to_date('30-06-2015', 'dd-mm-yyyy'), 8, 1);
insert into DEPT_REQUIREMENTS (code, start_date, end_date, required_people, accepted_deficit)
values ('ATLAS', to_date('01-06-2015', 'dd-mm-yyyy'), to_date('30-06-2015', 'dd-mm-yyyy'), 3, 1);
insert into DEPT_REQUIREMENTS (code, start_date, end_date, required_people, accepted_deficit)
values ('INFINICA', to_date('01-06-2015', 'dd-mm-yyyy'), to_date('30-06-2015', 'dd-mm-yyyy'), 3, 1);
insert into DEPT_REQUIREMENTS (code, start_date, end_date, required_people, accepted_deficit)
values ('ERROR_HANDLING', to_date('01-06-2015', 'dd-mm-yyyy'), to_date('30-06-2015', 'dd-mm-yyyy'), 6, 1);
commit;
prompt 6 records loaded
prompt Loading LEGAL_DAYS...
insert into LEGAL_DAYS (legal_date, in_year)
values (to_date('01-01-2016', 'dd-mm-yyyy'), '2016');
insert into LEGAL_DAYS (legal_date, in_year)
values (to_date('02-01-2016', 'dd-mm-yyyy'), '2016');
insert into LEGAL_DAYS (legal_date, in_year)
values (to_date('24-01-2016', 'dd-mm-yyyy'), '2016');
insert into LEGAL_DAYS (legal_date, in_year)
values (to_date('12-04-2016', 'dd-mm-yyyy'), '2016');
insert into LEGAL_DAYS (legal_date, in_year)
values (to_date('13-04-2016', 'dd-mm-yyyy'), '2016');
insert into LEGAL_DAYS (legal_date, in_year)
values (to_date('01-05-2016', 'dd-mm-yyyy'), '2016');
insert into LEGAL_DAYS (legal_date, in_year)
values (to_date('31-05-2016', 'dd-mm-yyyy'), '2016');
insert into LEGAL_DAYS (legal_date, in_year)
values (to_date('01-06-2016', 'dd-mm-yyyy'), '2016');
insert into LEGAL_DAYS (legal_date, in_year)
values (to_date('15-08-2016', 'dd-mm-yyyy'), '2016');
insert into LEGAL_DAYS (legal_date, in_year)
values (to_date('30-11-2016', 'dd-mm-yyyy'), '2016');
insert into LEGAL_DAYS (legal_date, in_year)
values (to_date('01-12-2016', 'dd-mm-yyyy'), '2016');
insert into LEGAL_DAYS (legal_date, in_year)
values (to_date('25-12-2016', 'dd-mm-yyyy'), '2016');
insert into LEGAL_DAYS (legal_date, in_year)
values (to_date('26-12-2016', 'dd-mm-yyyy'), '2016');
commit;
prompt 13 records loaded
prompt Loading PASSED_ATTRIBUTIONS...
prompt Table is empty
prompt Loading STATUS_TYPES...
insert into STATUS_TYPES (stat_code, description, active, final)
values ('SUBMITTED', 'First Stage', 'D', 'N');
insert into STATUS_TYPES (stat_code, description, active, final)
values ('UNDER_REVIEW', 'Second Stage', 'D', 'N');
insert into STATUS_TYPES (stat_code, description, active, final)
values ('RESOLVED', 'Accepted Request', 'D', 'D');
insert into STATUS_TYPES (stat_code, description, active, final)
values ('REJECTED', 'Denied Request', 'D', 'D');
commit;
prompt 4 records loaded
prompt Loading POSSIBLE_STATUS_CHANGE...
prompt Table is empty
prompt Loading REQUESTS...
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (82, 'VACATION_LEAVE', 'RESOLVED', to_date('03-07-2016', 'dd-mm-yyyy'), 1, 2, to_date('07-07-2016', 'dd-mm-yyyy'), to_date('09-07-2016', 'dd-mm-yyyy'), 2, 'D', 1, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (83, 'VACATION_LEAVE', 'SUBMITTED', to_date('03-07-2016', 'dd-mm-yyyy'), 1, 2, to_date('19-07-2016', 'dd-mm-yyyy'), to_date('25-07-2016', 'dd-mm-yyyy'), 1, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (84, 'MEDICAL_LEAVE', 'SUBMITTED', to_date('03-07-2016', 'dd-mm-yyyy'), 1, 2, to_date('07-07-2016', 'dd-mm-yyyy'), to_date('09-07-2016', 'dd-mm-yyyy'), 1, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (85, 'UNPAID_LEAVE', 'SUBMITTED', to_date('03-07-2016', 'dd-mm-yyyy'), 1, 2, to_date('09-07-2016', 'dd-mm-yyyy'), to_date('15-07-2016', 'dd-mm-yyyy'), 0, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (94, 'CULTURAL_HOLIDAY', 'RESOLVED', to_date('08-07-2016', 'dd-mm-yyyy'), 1, 2, to_date('09-07-2016', 'dd-mm-yyyy'), to_date('11-07-2016', 'dd-mm-yyyy'), 1, 'D', 1, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (124, 'VACATION_LEAVE', 'SUBMITTED', to_date('25-09-2016', 'dd-mm-yyyy'), 4, 7, to_date('02-09-2016', 'dd-mm-yyyy'), to_date('06-09-2016', 'dd-mm-yyyy'), 3, 'N', null, 'N', null, 'D', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (125, 'VACATION_LEAVE', 'SUBMITTED', to_date('25-09-2016', 'dd-mm-yyyy'), 4, 7, to_date('08-09-2016', 'dd-mm-yyyy'), to_date('12-09-2016', 'dd-mm-yyyy'), 3, 'N', null, 'N', null, 'D', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (126, 'VACATION_LEAVE', 'SUBMITTED', to_date('25-09-2016', 'dd-mm-yyyy'), 4, 7, to_date('23-09-2016', 'dd-mm-yyyy'), to_date('28-09-2016', 'dd-mm-yyyy'), 4, 'N', null, 'N', null, 'D', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (127, 'VACATION_LEAVE', 'SUBMITTED', to_date('25-09-2016', 'dd-mm-yyyy'), 4, 7, to_date('06-09-2016', 'dd-mm-yyyy'), to_date('09-09-2016', 'dd-mm-yyyy'), 4, 'N', null, 'N', null, 'D', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (128, 'CULTURAL_HOLIDAY', 'SUBMITTED', to_date('25-09-2016', 'dd-mm-yyyy'), 4, 7, to_date('26-09-2016', 'dd-mm-yyyy'), to_date('29-09-2016', 'dd-mm-yyyy'), 4, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (130, 'MEDICAL_LEAVE', 'SUBMITTED', to_date('25-09-2016', 'dd-mm-yyyy'), 4, 7, to_date('14-09-2016', 'dd-mm-yyyy'), to_date('17-09-2016', 'dd-mm-yyyy'), 1, 'N', null, 'N', null, 'D', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (131, 'MEDICAL_LEAVE', 'SUBMITTED', to_date('25-09-2016', 'dd-mm-yyyy'), 4, 7, to_date('04-10-2016', 'dd-mm-yyyy'), to_date('09-10-2016', 'dd-mm-yyyy'), 4, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (77, 'CULTURAL_HOLIDAY', 'RESOLVED', to_date('21-06-2016', 'dd-mm-yyyy'), 1, 2, to_date('02-06-2016', 'dd-mm-yyyy'), to_date('16-06-2016', 'dd-mm-yyyy'), 11, 'D', 1, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (78, 'VACATION_LEAVE', 'SUBMITTED', to_date('21-06-2016', 'dd-mm-yyyy'), 1, 2, to_date('02-06-2016', 'dd-mm-yyyy'), to_date('16-06-2016', 'dd-mm-yyyy'), 11, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (96, 'VACATION_LEAVE', 'REJECTED', to_date('08-07-2016', 'dd-mm-yyyy'), 1, 2, to_date('12-07-2016', 'dd-mm-yyyy'), to_date('13-07-2016', 'dd-mm-yyyy'), 2, 'N', null, 'D', 1, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (108, 'VACATION_LEAVE', 'SUBMITTED', to_date('01-08-2016', 'dd-mm-yyyy'), 47, 2, to_date('02-08-2016', 'dd-mm-yyyy'), to_date('10-08-2016', 'dd-mm-yyyy'), 7, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (110, 'CULTURAL_HOLIDAY', 'SUBMITTED', to_date('07-08-2016', 'dd-mm-yyyy'), 1, 2, to_date('08-08-2016', 'dd-mm-yyyy'), to_date('12-08-2016', 'dd-mm-yyyy'), 5, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (111, 'MEDICAL_LEAVE', 'SUBMITTED', to_date('07-08-2016', 'dd-mm-yyyy'), 1, 2, to_date('08-08-2016', 'dd-mm-yyyy'), to_date('11-08-2016', 'dd-mm-yyyy'), 1, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (114, 'CULTURAL_HOLIDAY', 'SUBMITTED', to_date('07-08-2016', 'dd-mm-yyyy'), 1, 2, to_date('08-08-2016', 'dd-mm-yyyy'), to_date('12-08-2016', 'dd-mm-yyyy'), 5, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (129, 'VACATION_LEAVE', 'SUBMITTED', to_date('25-09-2016', 'dd-mm-yyyy'), 4, 7, to_date('12-09-2016', 'dd-mm-yyyy'), to_date('12-09-2016', 'dd-mm-yyyy'), 1, 'N', null, 'N', null, 'D', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (88, 'VACATION_LEAVE', 'RESOLVED', to_date('09-07-2016', 'dd-mm-yyyy'), 2, 2, to_date('07-07-2016', 'dd-mm-yyyy'), to_date('11-07-2016', 'dd-mm-yyyy'), 2, 'D', 1, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (90, 'MEDICAL_LEAVE', 'SUBMITTED', to_date('07-07-2016', 'dd-mm-yyyy'), 33, 5, to_date('11-07-2016', 'dd-mm-yyyy'), to_date('21-07-2016', 'dd-mm-yyyy'), 2, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (91, 'VACATION_LEAVE', 'SUBMITTED', to_date('08-07-2016', 'dd-mm-yyyy'), 39, 2, to_date('10-07-2016', 'dd-mm-yyyy'), to_date('18-07-2016', 'dd-mm-yyyy'), 7, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (92, 'VACATION_LEAVE', 'RESOLVED', to_date('08-07-2016', 'dd-mm-yyyy'), 25, 2, to_date('10-07-2016', 'dd-mm-yyyy'), to_date('18-07-2016', 'dd-mm-yyyy'), 8, 'D', 1, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (98, 'UNPAID_LEAVE', 'SUBMITTED', to_date('09-07-2016', 'dd-mm-yyyy'), 38, 2, to_date('13-07-2016', 'dd-mm-yyyy'), to_date('15-07-2016', 'dd-mm-yyyy'), 2, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (99, 'MEDICAL_LEAVE', 'SUBMITTED', to_date('09-07-2016', 'dd-mm-yyyy'), 38, 2, to_date('13-07-2016', 'dd-mm-yyyy'), to_date('19-07-2016', 'dd-mm-yyyy'), 2, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (116, 'VACATION_LEAVE', 'SUBMITTED', to_date('12-08-2016', 'dd-mm-yyyy'), 34, 6, to_date('12-08-2016 11:54:12', 'dd-mm-yyyy hh24:mi:ss'), to_date('16-08-2016 11:54:12', 'dd-mm-yyyy hh24:mi:ss'), 2, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (100, 'VACATION_LEAVE', 'SUBMITTED', to_date('12-07-2016', 'dd-mm-yyyy'), 1, 2, to_date('13-07-2016', 'dd-mm-yyyy'), to_date('16-07-2016', 'dd-mm-yyyy'), 3, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (102, 'VACATION_LEAVE', 'SUBMITTED', to_date('12-07-2016', 'dd-mm-yyyy'), 1, 2, to_date('13-07-2016', 'dd-mm-yyyy'), to_date('14-07-2016', 'dd-mm-yyyy'), 2, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (117, 'MEDICAL_LEAVE', 'SUBMITTED', to_date('12-08-2016', 'dd-mm-yyyy'), 34, 6, to_date('22-08-2016 11:54:54', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-09-2016 11:54:54', 'dd-mm-yyyy hh24:mi:ss'), 9, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (118, 'MEDICAL_LEAVE', 'SUBMITTED', to_date('12-08-2016', 'dd-mm-yyyy'), 46, 6, to_date('07-08-2016 11:55:24', 'dd-mm-yyyy hh24:mi:ss'), to_date('14-08-2016 11:55:24', 'dd-mm-yyyy hh24:mi:ss'), 5, 'N', null, 'N', null, 'D', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (119, 'VACATION_LEAVE', 'SUBMITTED', to_date('12-08-2016', 'dd-mm-yyyy'), 46, 6, to_date('18-08-2016 11:55:48', 'dd-mm-yyyy hh24:mi:ss'), to_date('26-08-2016 11:55:48', 'dd-mm-yyyy hh24:mi:ss'), 7, 'N', null, 'N', null, 'D', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (120, 'VACATION_LEAVE', 'SUBMITTED', to_date('12-08-2016', 'dd-mm-yyyy'), 35, 1, to_date('12-08-2016 11:56:17', 'dd-mm-yyyy hh24:mi:ss'), to_date('16-08-2016 11:56:17', 'dd-mm-yyyy hh24:mi:ss'), 2, 'N', null, 'N', null, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (121, 'VACATION_LEAVE', 'REJECTED', to_date('12-08-2016', 'dd-mm-yyyy'), 35, 1, to_date('18-08-2016 11:56:31', 'dd-mm-yyyy hh24:mi:ss'), to_date('23-08-2016 11:56:31', 'dd-mm-yyyy hh24:mi:ss'), 4, 'N', null, 'D', 1, 'N', 'N');
insert into REQUESTS (id, type_of_req, status, submition_date, emp_id, dept_id, start_date, end_date, total_no_of_days, resolved, res_user, rejected, rejected_user, is_retroactive, under_review)
values (122, 'VACATION_LEAVE', 'SUBMITTED', to_date('20-08-2016', 'dd-mm-yyyy'), 1, 2, to_date('21-08-2016', 'dd-mm-yyyy'), to_date('22-08-2016', 'dd-mm-yyyy'), 1, 'N', null, 'N', null, 'N', 'N');
commit;
prompt 35 records loaded
prompt Loading RESTANT_DAYS...
insert into RESTANT_DAYS (empl_id, remaining_days, remaining_year)
values (1, 6, '2015');
commit;
prompt 1 records loaded
prompt Loading ROLE_TYPES...
insert into ROLE_TYPES (role_id, role_code, role_description, active, priority)
values (1, 'ADMIN', 'Administrator, Bo$$', 'D', 0);
insert into ROLE_TYPES (role_id, role_code, role_description, active, priority)
values (2, 'PROJECT_MANAGER', 'Responsible of organization', 'D', 1);
insert into ROLE_TYPES (role_id, role_code, role_description, active, priority)
values (3, 'TEAM_LEAD', 'Head of team', 'D', 2);
insert into ROLE_TYPES (role_id, role_code, role_description, active, priority)
values (4, 'HR', 'Human Resources', 'D', 3);
insert into ROLE_TYPES (role_id, role_code, role_description, active, priority)
values (5, 'USER', 'Pawn', 'D', 4);
commit;
prompt 5 records loaded
prompt Loading SKILL_TYPES...
insert into SKILL_TYPES (skill_code, skill_description)
values ('SQL', 'Structured Query Language');
insert into SKILL_TYPES (skill_code, skill_description)
values ('PL/SQL', 'Procedural Structured Query Language');
insert into SKILL_TYPES (skill_code, skill_description)
values ('JAVA', 'Java Master Race');
insert into SKILL_TYPES (skill_code, skill_description)
values ('PHP', 'PHP Hypertext Processor');
insert into SKILL_TYPES (skill_code, skill_description)
values ('JS', 'Java Script');
insert into SKILL_TYPES (skill_code, skill_description)
values ('TESTING', 'Testing Skills');
commit;
prompt 6 records loaded
prompt Loading SKILL_MATRIX...
insert into SKILL_MATRIX (emp_id, skill, lvl)
values (1, 'JAVA', 3);
insert into SKILL_MATRIX (emp_id, skill, lvl)
values (1, 'SQL', 3);
insert into SKILL_MATRIX (emp_id, skill, lvl)
values (1, 'JS', 4);
insert into SKILL_MATRIX (emp_id, skill, lvl)
values (1, 'PHP', 1);
commit;
prompt 4 records loaded
prompt Loading SL_ERRORS...
insert into SL_ERRORS (cod_err, err_description, active)
values ('4', 'Part of that interval ', 'D');
insert into SL_ERRORS (cod_err, err_description, active)
values ('3', 'You have pending Vacation requests that are unresolved.', 'D');
commit;
prompt 2 records loaded
prompt Loading STANDARD_NOTIFICATIONS...
prompt Table is empty
prompt Loading USER_ATRIBUTIONS...
insert into USER_ATRIBUTIONS (acc_id, role_id)
values (0, 1);
insert into USER_ATRIBUTIONS (acc_id, role_id)
values (0, 2);
insert into USER_ATRIBUTIONS (acc_id, role_id)
values (0, 4);
insert into USER_ATRIBUTIONS (acc_id, role_id)
values (0, 5);
insert into USER_ATRIBUTIONS (acc_id, role_id)
values (3, 1);
insert into USER_ATRIBUTIONS (acc_id, role_id)
values (3, 2);
insert into USER_ATRIBUTIONS (acc_id, role_id)
values (3, 3);
insert into USER_ATRIBUTIONS (acc_id, role_id)
values (4, 1);
insert into USER_ATRIBUTIONS (acc_id, role_id)
values (4, 2);
insert into USER_ATRIBUTIONS (acc_id, role_id)
values (4, 3);
commit;
prompt 10 records loaded
prompt Loading USER_CREDENTIALS...
insert into USER_CREDENTIALS (user_nm, pass_word)
values ('MARIUS.SEF', 'RnPzQ9g0OfQBN8eZKs7oKA==');
insert into USER_CREDENTIALS (user_nm, pass_word)
values ('ADMIN', '0IJqwnbM7ToHO86cngXhWA==');
commit;
prompt 2 records loaded
prompt Enabling foreign key constraints for DEPARTMENTS...
alter table DEPARTMENTS enable constraint SYS_C0010533;
prompt Enabling foreign key constraints for EMPLOYEES...
alter table EMPLOYEES enable constraint FK_DEPT_ID;
alter table EMPLOYEES enable constraint FK_MANAGER_ID;
prompt Enabling foreign key constraints for APP_USERS...
alter table APP_USERS enable constraint FK_EMP_ID;
prompt Enabling foreign key constraints for DAYS_PER_MONTH...
alter table DAYS_PER_MONTH enable constraint FK_REQ_DAY_P_MONTH;
prompt Enabling foreign key constraints for PASSED_ATTRIBUTIONS...
alter table PASSED_ATTRIBUTIONS enable constraint FK_DEPARTMENT_ID;
alter table PASSED_ATTRIBUTIONS enable constraint FK_GIVER_ID;
alter table PASSED_ATTRIBUTIONS enable constraint FK_RECEIVER_ID;
prompt Enabling foreign key constraints for POSSIBLE_STATUS_CHANGE...
alter table POSSIBLE_STATUS_CHANGE enable constraint FK_CURR_STATE;
alter table POSSIBLE_STATUS_CHANGE enable constraint FK_FUTURE_STATE;
prompt Enabling foreign key constraints for REQUESTS...
alter table REQUESTS enable constraint REJ_USR_FK;
alter table REQUESTS enable constraint RES_USR_FK;
alter table REQUESTS enable constraint STATUS_REQ_FK;
prompt Enabling foreign key constraints for SKILL_MATRIX...
alter table SKILL_MATRIX enable constraint FK_EMP_ID_SKMATRIX;
alter table SKILL_MATRIX enable constraint FK_SKILL_CODE;
prompt Enabling foreign key constraints for USER_ATRIBUTIONS...
alter table USER_ATRIBUTIONS enable constraint SYS_C0011718;
alter table USER_ATRIBUTIONS enable constraint SYS_C0011719;
prompt Enabling foreign key constraints for USER_CREDENTIALS...
alter table USER_CREDENTIALS enable constraint FK_USER_CRED_NAME_FK;
prompt Enabling triggers for DEPARTMENTS...
alter table DEPARTMENTS enable all triggers;
prompt Enabling triggers for EMPLOYEES...
alter table EMPLOYEES enable all triggers;
prompt Enabling triggers for APP_USERS...
alter table APP_USERS enable all triggers;
prompt Enabling triggers for REQUEST_TYPES...
alter table REQUEST_TYPES enable all triggers;
prompt Enabling triggers for DAYS_PER_MONTH...
alter table DAYS_PER_MONTH enable all triggers;
prompt Enabling triggers for DAYS_PER_YEAR...
alter table DAYS_PER_YEAR enable all triggers;
prompt Enabling triggers for DEPT_REQUIREMENTS...
alter table DEPT_REQUIREMENTS enable all triggers;
prompt Enabling triggers for LEGAL_DAYS...
alter table LEGAL_DAYS enable all triggers;
prompt Enabling triggers for PASSED_ATTRIBUTIONS...
alter table PASSED_ATTRIBUTIONS enable all triggers;
prompt Enabling triggers for STATUS_TYPES...
alter table STATUS_TYPES enable all triggers;
prompt Enabling triggers for POSSIBLE_STATUS_CHANGE...
alter table POSSIBLE_STATUS_CHANGE enable all triggers;
prompt Enabling triggers for REQUESTS...
alter table REQUESTS enable all triggers;
prompt Enabling triggers for RESTANT_DAYS...
alter table RESTANT_DAYS enable all triggers;
prompt Enabling triggers for ROLE_TYPES...
alter table ROLE_TYPES enable all triggers;
prompt Enabling triggers for SKILL_TYPES...
alter table SKILL_TYPES enable all triggers;
prompt Enabling triggers for SKILL_MATRIX...
alter table SKILL_MATRIX enable all triggers;
prompt Enabling triggers for SL_ERRORS...
alter table SL_ERRORS enable all triggers;
prompt Enabling triggers for STANDARD_NOTIFICATIONS...
alter table STANDARD_NOTIFICATIONS enable all triggers;
prompt Enabling triggers for USER_ATRIBUTIONS...
alter table USER_ATRIBUTIONS enable all triggers;
prompt Enabling triggers for USER_CREDENTIALS...
alter table USER_CREDENTIALS enable all triggers;
set feedback on
set define on
prompt Done.
