create or replace trigger REQUESTS_BU
  BEFORE UPDATE on REQUESTS for each row

DECLARE
  errMsg varchar2(255);
  no_such_user EXCEPTION;
  Req_in_final_stage EXCEPTION;
  Changing_Employee EXCEPTION;
  Not_The_Manager EXCEPTION;
  -- cursor that checks the user that is resolving/rejecting the request
  cursor c_res_rej_user(puser varchar2) is
    select 1 from app_users au
      join employees emp on au.emp_id = emp.emp_id
      where au.active = 'D'
        and au.code = upper(puser)
        and emp.trial_period = 'N';
  crr c_res_rej_user%rowtype;

  f_stage varchar2(1);

  -- any modifications made on the requests must be made from the correct owner of the department
  cursor c_check_mng(pmng_id number) is
    select 1 from employees emp where emp.emp_id = :new.emp_id 
      and emp.tm_id = pmng_id;
  ccm c_check_mng%rowtype;  

  emp_name varchar(64);
  FUNCTION sanitize_user(puser varchar2) return varchar2 as

    result requests.res_user%type;
  BEGIN
    result := upper(trim(puser));
    return result;
  end;


BEGIN
  -- The empployee id associated with the request must never change !
  if :new.emp_id != :old.emp_id then 
    raise Changing_Employee;
  end if;   
  -- If the employee has not changed we extract it's name for reference in error messages
  -- for easier identification of issues during bulk/smart resolve
  select emp.f_name || emp.l_name into emp_name from employees emp where emp.emp_id = :new.emp_id;
  -- sanitizing the user
  if :new.res_user != :old.res_user then
    open c_res_rej_user(:new.res_user);
    fetch c_res_rej_user into crr;
    if c_res_rej_user%found then
      :new.res_user := sanitize_user(:new.res_user);
    else
       raise no_such_user;
    end if;
  end if;
  
  if :new.res_user is not null or :new.rejected_user is not null then
    if :new.res_user is not null then 
      open c_check_mng(:new.res_user);
      fetch c_check_mng into ccm;
      if c_check_mng%found then 
        null;
      else 
        raise Not_The_Manager;
      end if;
      
      close c_check_mng;
    elsif :new.rejected_user is not null then
      open c_check_mng(:new.rejected_user);
      fetch c_check_mng into ccm;
      if c_check_mng%found then 
        null;
      else 
        raise Not_The_Manager;
      end if;
      
      close c_check_mng;      
    end if;
  end if;
  -- can not be under review if in final stage
  if :new.under_review = 'D' then
    select st.final into f_stage from status_types st where st.stat_code = :new.status;
    if (f_stage = 'D') then
      raise Req_in_final_stage;
    end if;
  end if;
  -- submittion date needs always lesser than start date unless it is retroactive
  if ((:new.submition_date > :new.start_date or :new.submition_date > :new.start_date) and :new.is_retroactive = 'N' ) then
    raise_application_error(-20155, 'Submition date can NOT be greater than start or end date unless request is retroactive!');
  end if;

  -- status types must coincide with marks of resolved/rejected/underreview
  -- FINAL STAGES MUST COINCIDE WITH a 'D' values in ressolved = 'D' and res_user must not be null
  if(:new.status = 'RESOLVED') then
    if(:new.resolved is null or :new.resolved != 'D')  then
      raise_application_error(-20155, 'Resolved checkmark does not coincide with status');
    end if;

    if(:new.res_user is null) then
      raise_application_error(-20155, 'Missing TM user on resolved request!');
    end if;

    if(:new.rejected = 'D' or :new.rejected_user is not null) then
      raise_application_error(-20155, 'Missing TM user on resolved request!');
    end if;
  elsif(:new.status = 'REJECTED') then
    if(:new.resolved != 'N' or :new.res_user is not null) then
      raise_application_error(-20155, 'Rejected request can not be resolved!');
    end if;

    if(:new.rejected_user is null or :new.rejected != 'D') then
      raise_application_error(-20155, 'Rejected request is missing resolution user or mark!');
    end if;
  end if;
  
EXCEPTION
  when Not_The_Manager then 
    raise_application_error(-20153, 'You cannot alter the request of: ' || emp_name);
  when Changing_Employee then 
    raise_application_error(-20154, 'Employee of request can not change !');
  when no_such_user then
    raise_application_error(-20155, 'You can not resolve the request ');
  when Req_in_final_stage then
    raise_application_error(-20156, 'Request is in final stage');
  when others then
    errMsg := substr(sqlerrm, 1, 500);
    raise_application_error(-20150, errMsg);
END;