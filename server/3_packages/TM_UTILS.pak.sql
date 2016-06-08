

create or replace package TM_UTILS as

  --- checks for overlapps and if there are none then validates
  procedure check_validate_request(pid_req number, pAcc_id number);

  -- Does not check for overlap, assumes the TM has gone ahead and approved the request
  procedure validate_request(pid_req number, pAcc_id number);
  procedure Smart_Validation(pid_dept number, pacc_id number);
  -- passing attributions to another TM
  procedure Pass_Attributions(pempl_id number, ptm_target varchar2);
end TM_UTILS;



create or replace package body TM_UTILS as
  

 
  procedure check_validate_request(pid_req number, pAcc_id number) as
    validationUser EXCEPTION;
    noSuchRequest EXCEPTION;
    overlapExcep EXCEPTION;
    checkOverlap COL_OVERLAPPED_DAYS;
    
    errM varchar2(255);
    cnt number;
  begin
    select count(*) into cnt from requests rq where rq.id = pid_req;
    if(cnt  > 0 ) then
      select count(*) into cnt from app_users a where a.id = pAcc_id;
      if(cnt != 1) then
        -- we check one last time to see if there are overlaps when resolving the request(the case of another req being submitted right before this is attempted)
        checkOverlap := AC_REQ_ACTIONS.get_overlapped_days(pid_req);
        
        if(checkOverlap.Count = 0) then 
          update requests rq
             set rq.res_user  =
                 (select code from app_users where id = pacc_id),
                 rq.resolved   = 'D',
                 rq.rejected   = 'N'
           where rq.id = pid_req;
           commit;
        else 
          raise validationUser;
        end if;     
      else
        raise overlapExcep;
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
  procedure validate_request(pid_req number, pAcc_id number) as 
    userValidationIssue EXCEPTION;
    cnt number;
    errM varchar2(255);
  begin
    select count(*) into cnt from app_users au where au.id = pAcc_id;
    if (cnt != 1) then
      update requests rq
             set rq.res_user  =
                 (select code from app_users where id = pacc_id),
                 rq.resolved   = 'D',
                 rq.rejected   = 'N'
           where rq.id = pid_req;
      commit;     
    else
      raise userValidationIssue;
    end if;
  exception
    when userValidationIssue then 
      raise_application_error(-20155, 'Issue with the user that you are validating with');
    when others then 
      errM := substr(sqlerrm, 1, 255);
      raise_application_error(-20155, errM);
  end;
  
  
  
  -- Resolves all requests based on submission date and does not allow any overlap
  -- It resolves requests as they are received by date and only checks for overlap with existing already resolved requests
  -- It DOES NOT check for overlap with existing SUBMITTED requests. Any request made on the same day that overlap will be skipped for them to be resolved by the TM.
  -- Any request that overlaps but is not made on the same day will be rejected
  procedure Smart_Validation(pid_dept number, pAcc_id number) as
    cursor   
  
  
  begin
    null;
  end;

  -- passing attributions to another TM
  procedure Pass_Attributions(pempl_id number, ptm_target varchar2) as

  begin
    null;
  end;
end TM_UTILS;