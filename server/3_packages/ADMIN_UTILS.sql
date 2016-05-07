/*Package for creating a new user for an employee*/
-- tables needed for creating a new user
create or replace package ADMIN_UTILS as
  -- admin procedure for registering new accounts.
  procedure insert_new_employee(pf_name varchar2, pl_name varchar2, p_email varchar2, phire_date date, p_tm_id number, pdep_id number, ptrial_period varchar2, out_emp_id OUT number);
  function insert_new_employee(pf_name varchar2, pl_name varchar2, p_email varchar2, phire_date date, p_tm_id number, pdep_id number, ptrial_period boolean )  return number;
  function create_new_user(p_user_name varchar2, p_password varchar2, pemp_id number, p_department varchar2, ptm_id number) return number;
  
  -- when deleting an employee all app users tied to that account( which should be one ) need to also be removed 
  procedure delete_empl(pid_empl varchar2);
  procedure edit_empl(pemp_id number, pl_name varchar2, pf_name varchar2, pemail varchar2, phire_date date, pTm_ID number, pDep_id number;	
end ADMIN_UTILS;

create or replace package body ADMIN_UTILS as
  -- internal procedure to delete an app user when an employee is deleted
  -- tables in question: app_users, user_attribtions, user_credentials 
  procedure delete_app_user(pid_app_user number,  pempl_id number) as
    cursor c_get_user is 
      select apu.code, apu.id from app_users apu where apu.id = pid_app_user and apu.emp_id = pempl_id;
    
    
    errMsg varchar2(255);
  begin
    -- we need to firstly delete the user credentials then attributes
    for x in c_get_user loop
      BEGIN
        delete user_credentials uc where uc.user_nm = x.code;
        delete user_atributions ua where ua.user_id = x.id;

      EXCEPTION
        when others then
          rollback;
          errMsg := substr(sqlerrm, 1, 500);
          raise_application_error(-21500, errMsg);
      END;  
    end loop;
    delete app_users a where a.id = pid_app_user and a.emp_id = pempl_id;
  exception 
    when others then
      raise;
  end;

  procedure delete_empl(pid_empl varchar2) as
    errMsg varchar2(255);
    -- cursor that checks if there is an application user to delete it also
    cursor c_check_user is
      select * from app_users au where au.emp_id = pid_empl;
    
    cursor c_exists_empl is 
      select 1 from employees emp where emp.emp_id = pid_empl;
     cee c_exists_empl%rowtype;   
     
    NO_SUCH_EMPLOYEE Exception;  
    OTHER_ROLES EXCEPTION;
    cursor c_dept_attributions is
      select 1 from departments dep where dep.tm_id = pid_empl;
    cda c_dept_attributions%rowtype;
      
  BEGIN
    -- if any user found then we call internal procedure to delete the user
    open c_exists_empl;
    fetch c_exists_empl into cee;
    if c_exists_empl%found then
      open c_dept_attributions;
      fetch c_dept_attributions into cda;
      if c_dept_attributions%notfound then
        for x in c_check_user loop
          delete_app_user(x.id, pid_empl);
        end loop;
        
        -- then we delete the actual employee
        delete from employees emp where emp.emp_id = pid_empl;
        commit;
      else
        raise OTHER_ROLES;  
      end if;  
    else 
      raise NO_SUCH_EMPLOYEE;
    end if;   
    close c_exists_empl;
  exception
    when NO_SUCH_EMPLOYEE then 
      raise_application_error(-20101, 'No such employee id found!');
    when OTHER_ROLES then
      raise_application_error(-20101, 'Employee has other Roles');  
    when others then 
      rollback;
      errMsg := substr(sqlerrm, 1, 500);
      raise_application_error(-20101, errMsg);  
  END;
  

  procedure insert_new_employee(pf_name varchar2, pl_name varchar2, p_email varchar2, phire_date date, p_tm_id number, pdep_id number, ptrial_period varchar2, out_emp_id OUT number) as
    errMsg varchar2(255);
    empId number; 
  begin    
    begin
      insert into employees(emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period) 
        values(emp_id_seq.nextval, pf_name, pl_name, p_email, trunc(phire_date), p_tm_id, pdep_id, ptrial_period); 
      commit;  
      dbms_output.put_line('inserted the employee');
      empId := emp_id_seq.currval;  
    exception
      when others then 
        errMsg := substr(sqlerrm, 1, 500); 
        raise_application_error(-20157, errMsg);
    end; 
    dbms_output.put_line('Null checks');
    if errMsg is null and empId is not null then 
      dbms_output.put_line('Works');
      out_emp_id := empId;  
    else
      out_emp_id := -1;
    end if;
  exception 
    when others then 
       raise_application_error(-20157, errMsg);
  end;
  
  function insert_new_employee(pf_name varchar2, pl_name varchar2, p_email varchar2, phire_date date, p_tm_id number, pdep_id number, ptrial_period boolean ) return number as 
    errMsg varchar2(255);
    empId number; 
    is_on_trial varchar2(1);
  begin 
    if ptrial_period then 
      is_on_trial := 'D';
    else 
      is_on_trial := 'N';
    end if;    
    begin
      insert into employees(emp_id, f_name, l_name, email, hire_date, tm_id, dep_id, trial_period) 
        values(emp_id_seq.nextval, pf_name, pl_name, p_email, trunc(phire_date), p_tm_id, pdep_id, is_on_trial); 
      commit;  
      empId := emp_id_seq.currval;  
    exception
      when others then 
        errMsg := substr(sqlerrm, 1, 500); 
    end; 
    if errMsg is null and empId is not null then 
      return empId;  
    else
      return -1;
    end if;
  exception 
    when others then 
      raise;
  end;

  function create_new_user(p_user_name varchar2, p_password varchar2, pemp_id number, p_department varchar2, ptm_id number) return number as

    cursor c_user_already_exits is 
      select 1 from app_users au 
        where au.code = p_user_name; 
    cae c_user_already_exits%Rowtype;
    
    errMsg varchar2(255);
  begin
    open c_user_already_exits;
    fetch c_user_already_exits into cae; 
    if c_user_already_exits%found then 
      -- if username already found we return -1
      return -1;
    else 
      null;
      --insert into app_users(id, code, emp_id, active) values (app_users_seq.nextval, p_user_name, pemp_id, p_department, ptm_id);
      --  we continue inserting the username 
    end if;
    close c_user_already_exits;
  exception
    when others then 
      errMsg := substr(sqlerrm, 1, 500);
      raise_application_error(-20150, errMsg); 
  end;


  -- This procedure does not edit the trial_period. THat is regulated with a job after a standard period of 3 months. This period can be configurable.
  procedure edit_empl(pemp_id number, pf_name varchar2, pl_name varchar2, pemail varchar2, phire_date date, pTm_ID number, pDep_id number) as
    cursor c_get_empl is 
      select 1 from employees emp 
        where emp.emp_id = pemp_id;
    cge c_get_empl%rowtype;
    
    errM varchar2(255);
    NO_SUCH_USER EXCEPTION;
  BEGIN
    open c_get_empl;
    fetch c_get_empl into cge;
    if c_get_empl%found then 
      update Employees emp
         set Emp_Id       = pemp_id,
             f_Name       = pf_name,
             l_Name       = pl_name,
             Email        = pemail,
             Hire_Date    = phire_date,
             Tm_Id        = pTm_ID,
             Dep_Id       = pDep_id
       where emp.emp_id = pemp_id;
      commit;
    else
      raise NO_SUCH_USER;
    end if;
  EXCEPTION
    when NO_SUCH_USER then 
      raise_application_error(-20155,'Users ID not FOUND !');
    when others then 
      rollback;
      errM := substr(sqlerrm, 1, 500);
      raise_application_error(-20155, errM);
  END;
  
end;
