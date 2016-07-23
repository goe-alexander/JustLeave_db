create or replace type overlap_day as object(
  day_overlapped number,
  month_of_day varchar2(30)
  
);
create or replace public synonym new_employee_type for new_employee_type; 

create type col_overlapped_days is table of overlap_day;
create or replace public synonym col_overlapped_days for col_overlapped_days; 

create type emp_details_type as object(
  acc_id number,
  emp_id number,
  f_name varchar2(80),
  l_name varchar2(80),
  dep_id number,
  tm_id number,
  email varchar2(80),
  hire_date date
);

create or replace public synonym emp_details_type for emp_details_type; 

create type new_employee_type as object(
  acc_id number,
  emp_id number,
  f_name varchar2(80),
  l_name varchar2(80),
  email varchar2(120),
  dep_id number,
  tm_id number,
  hire_date date, 
  trial_period varchar2(1),
  user_name varchar2(20),
  user_role varchar2(60),
  crypted_pass varchar2(2000) -- we send the crypted pass in the db so we can send the encryption at  every logIn so we may only compare HashStrings 
);
create public synonym new_employee_type for new_employee_type; 



-- types needed for bulk processing 
create or replace type int_array as varray(400) of INTEGER;
create or replace public synonym int_array for int_array; 

create or replace type bulk_requests as object(
  req_id number(20),
  emp_id number(20),
  mng_id number(20)     
);
create public synonym bulk_requests for bulk_requests;


create or replace type bulk_requests_array is table of   bulk_requests
create public synonym bulk_requests_array for bulk_requests_array;
