create or replace trigger REQUESTS_BU
  BEFORE UPDATE on REQUESTS for each row
  
DECLARE
  errMsg varchar2(255);
  no_such_user EXCEPTION;
  Req_in_final_stage EXCEPTION;
  
  -- cursor that checks the user that is resolving/rejecting the request
  cursor c_res_rej_user(puser varchar2) is
    select 1 from app_users au
      join employees emp on au.emp_id = emp.emp_id
      where au.active = 'D'
        and au.code = upper(puser)
        and emp.trial_period = 'N';
  crr c_res_rej_user%rowtype;
  
  f_stage varchar2(1);      
  
  FUNCTION sanitize_user(puser varchar2) return varchar2 as

    result requests.res_user%type;
  BEGIN
    result := upper(trim(puser));
    return result;
  end;

        
BEGIN
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
  when no_such_user then
    raise_application_error(-20155, 'No such user resolved ');
  when Req_in_final_stage then
    raise_application_error(-20156, 'Request is in final stage');  
  when others then
    errMsg := substr(sqlerrm, 1, 500);
    raise_application_error(-20150, errMsg);
END;