create or replace package TM_UTILS as
 
  procedure mark_for_review(preq_id number, pemp_id number, pmng_id number);
  procedure direct_rejection(preq_id number, pmng_id number);
  --- checks for overlapps and if there are none then validates
  procedure check_validate_request(pid_req number, pmng_id number);
  
  -- Does not check for overlap, assumes the TM has gone ahead and approved the request
  procedure validate_request(pid_req number, pmng_id number);
  procedure Smart_Validation(pstart_date date, pend_date date, paccepted_overlap number, prule number, pmng_id number);
  
  procedure Bulk_Validation(pall_these_req bulk_requests_array);
  -- passing attributions to another TM
  procedure Pass_Attributions(pgiver number, preceiver number, pdept_id number);
end TM_UTILS;


create or replace package body TM_UTILS as
  
  procedure mark_for_review(preq_id number, pemp_id number, pmng_id number) as 
    c_mng number;
    MNG_ISSUE EXCEPTION; 
    errM varchar2(255);     
    empl_name varchar(200);           
  BEGIN
    select count(*) into c_mng from employees emp where emp.emp_id = pemp_id 
        and emp.tm_id = pmng_id; 
    if (c_mng = 1 ) then
      update requests rq 
        set rq.under_review = 'D',
            rq.status = 'UNDER_REVIEW'
          where rq.id = preq_id;
    else
      raise MNG_ISSUE;
    end if;
    select f_name || ' ' || l_name into empl_name from employees emp where emp.emp_id = pemp_id;     
  exception  
    when MNG_ISSUE then 
      raise_application_error(-20155, 'You are not the manager of this employee: ' || empl_name);
    when others then 
      rollback;
      errM := substr(sqlerrm, 1, 500);  
      raise_application_error(-20155, errM);            
  END;
  
    
  procedure direct_rejection(preq_id number, pmng_id number) as
    
    -- all these checks should be done once in the trigger
    
    
/*    cursor c_check_empl is 
      select 1 from requests rq 
        join employees emp on emp.emp_id = rq.emp_id
        where emp.emp_id = pemp_id
          and emp.tm_id = pmng_id
          and rq.id = preq_id;
    cce c_check_empl%rowtype;
        
    cursor c_check_mng is
      select 1 from employees emp where emp.emp_id = pemp_id 
        and emp.tm_id = pmng_id;
    ccm c_check_mng%rowtype;  */
    empl_name varchar2(40);
    errm varchar2(255);     

  BEGIN 
        update requests rq
           set rq.rejected_user  = pmng_id,
               rq.rejected   = 'D',
               rq.resolved   = 'N',
               rq.res_user = null,
               rq.status = 'REJECTED'
         where rq.id = preq_id;        
    select f_name || ' ' || l_name into empl_name from employees emp where emp.emp_id = (select rq.emp_id from requests rq where rq.id = preq_id); 
  EXCEPTION 
/*    when MNG_ISSUE then 
      raise_application_error(-20155, 'You are not the manager of this employee: ' || empl_name);
    when EMPL_ISSUE then
      raise_application_error(-20155, 'Request not associated with this: ' || empl_name);  */
    when others then 
      rollback;
      errM := substr(sqlerrm, 1, 500);  
      raise_application_error(-20155, errM);        
  END;

 
  procedure check_validate_request(pid_req number, pmng_id number) as
    validationUser EXCEPTION;
    noSuchRequest EXCEPTION;
    overlapExcep EXCEPTION;
    checkOverlap COL_OVERLAPPED_DAYS;
    
    errM varchar2(255);
    cnt number;
  begin
    select count(*) into cnt from requests rq where rq.id = pid_req;
    if(cnt  > 0 ) then
      select count(*) into cnt from app_users a where a.emp_id = pmng_id;
      if(cnt = 1) then
        -- we check one last time to see if there are overlaps when resolving the request(the case of another req being submitted right before this is attempted)
        checkOverlap := AC_REQ_ACTIONS.get_all_overlapped_days(pid_req);
        
        if(checkOverlap.Count = 0) then 
          update requests rq
             set rq.res_user  = pmng_id,
                 rq.resolved   = 'D',
                 rq.rejected   = 'N',
                 rq.status = 'RESOLVED'
           where rq.id = pid_req;
           commit;
        else 
          raise overlapExcep;
        end if;     
      else
        raise validationUser;
      end if;        
    else
      raise noSuchRequest;
    end if;
    
  exception
    when noSuchRequest then 
      raise_application_error(-20155, 'No such request found');
    when validationUser then 
      raise_application_error(-20155, 'User with which you are validating has an issue');    
    when overlapExcep then 
      raise_application_error(-20155, 'There are overlapping requests submitted ');  
    when others then 
      rollback;
      errM := substr(sqlerrm, 1, 500);  
      raise_application_error(-20155, errM);  
  end;
  
  
  
  -- validates request without checking for overlap
  procedure validate_request(pid_req number, pmng_id number) as 
    userValidationIssue EXCEPTION;
    cnt number;
    errM varchar2(255);
  begin
    select count(*) into cnt from app_users au where au.emp_id = pmng_id;
    if (cnt = 1) then
      update requests rq
             set rq.res_user  = pmng_id,
                 rq.resolved   = 'D',
                 rq.rejected   = 'N',
                 rq.status = 'RESOLVED'
           where rq.id = pid_req;
      commit;     
    else
      raise userValidationIssue;
    end if;
  exception
    when userValidationIssue then 
      raise_application_error(-20155, 'Issue with the user that you are validating with, it does not appear');
    when others then 
      errM := substr(sqlerrm, 1, 255);
      raise_application_error(-20155, errM);
  end;
  
  
  
  
  procedure direct_validation(pid_req number,pemp_id number, pmng_id number) as
    NOT_MY_MANAGER EXCEPTIon;
    EMPLOYEE_ISSUE EXCEPTION;
    cnt number;
    emp_name varchar2(60);
    
    errm varchar2(255);
  begin
    -- select name of employee 
    SELECT f_name || ' ' || l_name
      into emp_name
      from employees emp
     where emp.emp_id = pemp_id;
    -- check if manager is his manager 
    select count(*)
      into cnt
      from employees emp
     where emp.emp_id = pemp_id
       and emp.tm_id = pmng_id;
    if(cnt = 1 ) then
      update requests rq
         set rq.res_user = pmng_id,
             rq.resolved = 'D',
             rq.rejected = 'N',
             rq.status   = 'RESOLVED'
       where rq.id = pid_req;
      commit;      
    elsif(cnt = 0) then
      raise NOT_MY_MANAGER;
    else  
      raise EMPLOYEE_ISSUE;
    end if;  
  EXCEPTION
    when EMPLOYEE_ISSUE then 
      raise_application_error(-20155, 'Issue with employee : ' || emp_name);
    when NOT_MY_MANAGER then
      raise_application_error(-20155, 'You are not the manager of the request !');  
    when others then 
      errM := substr(sqlerrm, 1, 255);
      raise_application_error(-20155, errM);     
  end;

  
  -- Resolves all requests based on submission date and does not allow any overlap
  -- It resolves requests as they are received by date and only checks for overlap with existing already resolved requests
  -- It DOES NOT check for overlap with existing SUBMITTED requests. Any request made on the same day that overlap will be skipped for them to be resolved by the TM.
  -- Any request that overlaps but is not made on the same day will be rejected
  function can_approve_request(pmax_overlap number, pstart_date date, pend_date date, preq_id number) return boolean as
    no_of_overlaps number;  
    min_req_cnt number;
    
    MIN_REQUIREMENTS EXCEPTION;
    errm varchar2(255);
  BEGIN 
   -- minimum requirements check
/*    select count(rq.id)
      into min_req_cnt
      from requests rq
      join status_types st
        on st.stat_code = rq.status
     where rq.id = preq_id
       and st.final = 'N'
       and st.active = 'D'
       and rq.dept_id = (select dept_id from requests rq where rq.id = preq_id);
      
    if min_req_cnt != 1 then 
      raise MIN_REQUIREMENTS;
    end if; */     
    
    -- The Above requeirements will go in a trigger    


    select count(rq.id)
      into no_of_overlaps
      from requests rq
     where trunc(rq.start_date) <= trunc(pend_date)
       and trunc(rq.end_date) >= trunc(pstart_date)
       and rq.resolved = 'D'
       and rq.status = 'RESOLVED'
       and rq.type_of_req = 'VACATION_LEAVE'
       and rq.res_user is not null
       and rq.id != preq_id;
    if no_of_overlaps >  pmax_overlap then 
      return false;
    else 
      return true;
    end if;  

  EXCEPTION
    when others then 
      errM := substr(sqlerrm, 1, 255);
      raise_application_error(-20155, errM);     
  END;
  
  

  
  procedure Smart_Validation(pstart_date date, pend_date date, paccepted_overlap number, prule number, pmng_id number) as
   /* cursor used for getting all the requests for vacation_leave in department */
    cursor c_pending_req_1 is 
      select rq.*, emp.f_name || ' ' || emp.l_name "FULL_NAME"
        from requests rq
        join employees emp
          on emp.emp_id = rq.emp_id
         and emp.dep_id = rq.dept_id
       where rq.type_of_req = 'VACATION_LEAVE'
         and rq.status = 'SUBMITTED'
         and rq.dept_id in (select dp.dep_id from departments dp where dp.tm_id = pmng_id)
         and trunc(rq.start_date) <= trunc(pend_date)
         and trunc(rq.end_date) >= trunc(pstart_date)
       order by rq.SUBMITION_DATE desc;     
    gpv c_pending_req_1%rowtype;
    
    -- rule 2 cursor
    cursor c_pending_req_2 is 
      select rq.*,
             emp.f_name || ' ' || emp.l_name "FULL_NAME",
             (select sum(rq2.total_no_of_days)
                from requests rq2
               where rq2.emp_id = rq.emp_id
                 and rq2.dept_id = rq.dept_id
                 and rq2.status <> 'REJECTED'
                 and extract(YEAR FROM rq.start_date) =
                     extract(YEAR from sysdate)
                 and rq2.rejected = 'N'
                 and rq2.rejected_user is null
                 and rq2.type_of_req = 'VACATION_LEAVE') "TAKEN_DAYS"
        from requests rq
        join employees emp
          on emp.emp_id = rq.emp_id
         and emp.dep_id = rq.dept_id
       where rq.type_of_req = 'VACATION_LEAVE'
         and rq.status = 'SUBMITTED'
         and rq.dept_id in
             (select dp.dep_id from departments dp where dp.tm_id = pmng_id)
         and trunc(rq.start_date) <= trunc(pend_date)
         and trunc(rq.end_date) >= trunc(pstart_date)
       order by TAKEN_DAYS, rq.SUBMITION_DATE desc;
            
    errm varchar2(255);   
    gpr c_pending_req_2%rowtype;
    
      
    under_review boolean;
    -- Types for rule 1
    type  int_number is record (req_id number);
    type int_table is table of int_number index by PLS_INTEGER; 
   
    selected_req int_number;
    req_on_same_day int_table;   
    -- Types for rule 2 
    type taken_days is record(taken_days number);
    type taken_table is table of taken_days;     
    
    same_taken_days taken_table;
 
  begin
    -- Initializing working variables
    under_review := false;
    
    -- now we check what requests are made on the same day and cannot be resolved by this rule
    -- so we exclude them if they are in the current working set  
    select rq.id
      bulk collect into req_on_same_day
      from requests rq
     where rq.status = 'SUBMITTED'
       and rq.type_of_req = 'VACATION_LEAVE'
       and rq.submition_date in (select rq.submition_date
                                   from requests rq
                                  where rq.type_of_req = 'VACATION_LEAVE'
                                    and rq.status = 'SUBMITTED'
                                  group by rq.submition_date
                                 having count(*) > 1);
    -- RULE 1 is FirstComeFirstServed
    -- RULE 2 is based on which person has taken the most days
    if(prule = 1) then 
      open c_pending_req_1;
      <<main_loop>>
      loop
        fetch c_pending_req_1 into gpv;
        exit when c_pending_req_1%notfound;
        -- we check the req made on the same day
        
        -- This is currently not working on this version of DB -> No Map method found for decalred Type !!!
/*      if (selected_req member of req_on_same_day) then 
          dbms_output.put(' -----> Marked for review');
        end if;*/  
        
        under_review := false;
        <<same_day_req>>
        for x in req_on_same_day.FIRST .. req_on_same_day.LAST loop
          exit same_day_req when req_on_same_day.count = 0;
          if gpv.id = req_on_same_day(x).req_id then 
            under_review := true;
            exit same_day_req;
          end if;
        end loop;    
        if (under_review) then 
          -- we mark the request for review and continue to next iterration
          mark_for_review(preq_id => gpv.id , pemp_id => gpv.emp_id , pmng_id => pmng_id);
          CONTINUE;          
        end if;
                  
        -- we go through each request and check if they violate the no overlap rule
        if(can_approve_request(paccepted_overlap, pstart_date, pend_date, gpv.id)) then 
          direct_validation(gpv.id, gpv.emp_id, pmng_id);
        else 
          direct_rejection(gpv.id, pmng_id);
        end if;
        
      end loop;
      close c_pending_req_1;
    elsif prule = 2 then
      -- we get all the number of taken days that appear more than once 
      -- and exlude the requests with the employee that has that number of taken days 
      select  same_number.taken_days bulk collect into same_taken_days from (select distinct rq.emp_id,
               (select sum(rq2.total_no_of_days)
                  from requests rq2
                 where rq2.emp_id = rq.emp_id
                   and rq2.dept_id = rq.dept_id
                   and rq2.status <> 'REJECTED'
                   and extract(YEAR FROM rq2.start_date) =
                       extract(YEAR from sysdate)
                   and rq2.rejected = 'N'
                   and rq2.rejected_user is null
                   and rq2.type_of_req = 'VACATION_LEAVE') "TAKEN_DAYS"
          from requests rq
          join employees emp
            on emp.emp_id = rq.emp_id
           and emp.dep_id = rq.dept_id
         where rq.type_of_req = 'VACATION_LEAVE'
           and rq.status = 'SUBMITTED'
           and rq.dept_id in
               (select dp.dep_id from departments dp where dp.tm_id = 1)
           and trunc(rq.start_date) <= trunc(pend_date)
           and trunc(rq.end_date) >= trunc(pstart_date)
         order by TAKEN_DAYS desc)  same_number  
       having  count(same_number.taken_Days) > 1 group by same_number.taken_days;
      
      dbms_output.put_line('Wait for your turn rule implementation');
      -- This rule will not take into consideration remaining days only days taken
      -- potential conflicts : if same number of taken days then they will be marked for review 
      open c_pending_req_2;
      <<main_loop>>
      loop
        -- we reinitialize the marker for the next request 
        under_review := false;
       
        fetch c_pending_req_2 into gpr;
        exit when c_pending_req_2%notfound;
        -- now we need to check if the employee has the number of days identified as appearing more than twice  
        <<same_taken_days_loop>>
        for x in same_taken_days.FIRST .. same_taken_days.LAST loop
          exit  when same_taken_days.count = 0;
          if gpr.taken_days = same_taken_days(x).taken_days then 
            
            under_review := true;
            exit same_taken_days_loop;
          end if;
        end loop;           
        if (under_review) then 
          -- we mark the request for review and continue to next iterration
          mark_for_review(preq_id => gpr.id , pemp_id => gpr.emp_id , pmng_id => pmng_id);
          CONTINUE;          
        end if;
          
        -- we go through each request that passed the under review flag and check if they violate the no overlap rule
        if(can_approve_request(paccepted_overlap, pstart_date, pend_date, gpr.id)) then 
          direct_validation(gpr.id, gpr.emp_id, pmng_id);
        else 
          direct_rejection(gpr.id, pmng_id);
        end if;
        
      end loop;        
      close c_pending_req_2;
    end if;
    
  EXCEPTION  
    when others then 
      errM := substr(sqlerrm, 1, 255);
      raise_application_error(-20155, errM);       
  end;

  -- passing attributions to another TM
  procedure Pass_Attributions(pgiver number, preceiver number, pdept_id number) as
    -- we need to insert the record in the appropriate table
    -- and modify the tm_id in departments
    errm varchar2(250);
  begin
    -- register the transfer
    insert into passed_attributions(giver_id, department_id, receiver_id) 
      values(pgiver, pdept_id, preceiver);
    -- 
    commit;  
    -- change the department id 
  EXCEPTION
    when others then 
      rollback;
      errm := substr(sqlerrm, 1, 255);
      raise_application_error(-20150, errm);
  end;
  
  procedure Bulk_Validation(pall_these_req bulk_requests_array) as 
    errm varchar2(255); 
  BEGIN
    for x in pall_these_req.FIRST .. pall_these_req.LAST
    Loop
      
      direct_validation(pall_these_req(x).req_id, pall_these_req(x).emp_id, pall_these_req(x).mng_id);
    end loop;
  
  EXCEPTION
    when others then 
      errM := substr(sqlerrm, 1, 255);
      raise_application_error(-20155, errM);     
  END;
  
end TM_UTILS;