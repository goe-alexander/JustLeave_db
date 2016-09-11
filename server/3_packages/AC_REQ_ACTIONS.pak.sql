/* Package that contains all available actions on a request as well as 
  procedures to determine which actions are available on which request 
  according to role and start date of each vaction leave
*/
create or replace package AC_req_actions as

  function is_working_day(pdate date) return boolean;
  procedure insert_request(p_l_type varchar, p_start_date Date, p_end_date Date, pemp_id number, p_dept_id number, p_total_days number, p_is_retroactive varchar2, p_id_req out number);
  -- used for inserting from db, calculates the number of days between the dates 
  procedure insert_rq_from_db(p_l_type varchar, p_start_date Date, p_end_date Date, pemp_id number, p_dept_id number, p_is_retroactive varchar2, p_id_req out number);
  
  function num_days_in_interval(pst_date date, pend_Date date) return number;
  procedure delete_this_request(pid_req number, pemp_id number);
  procedure update_this_request(pid_req number, p_req_type varchar, p_start_date date, p_end_date date, p_total_days number);
  function pending_vacation_req(pemp_id number, pdept_id number ) return number;
  -- used by web to call before inserting any request we have to validate there is no overlap
  function validate_period(p_st_date date, p_end_date date, pdpt_id number) return varchar2;
  -- Functions that search for overlap with existing resolved requests or newly submitted ones and both
   function get_all_overlapped_days(preq_id number) return col_overlapped_days;
   function get_resolved_overlapped_days(preq_id number) return col_overlapped_days;
   function get_submitted_overlapped_days(preq_id number) return col_overlapped_days;
   -- function that calls the first overlapp function and then also checks to see if there is a 
   /*function smart_resolve() return col_overlapped_days; */
end AC_req_actions;

create or replace package body AC_req_actions as
  function is_working_day(pdate date) return boolean as
    rez boolean;
    -- all legal free days that are not weekend
    cursor c_get_legal_days is
      select legal_date from legal_days ld
        where ld.in_year = to_char(sysdate,'YYYY')
          and (MOD(TO_CHAR(legal_date, 'J'), 7) + 1 NOT IN (6, 7))
          and ld.legal_date = pdate;
    cgl c_get_legal_days%rowtype;
  begin
    rez := true;
    -- check if it's weekend
    open c_get_legal_days;
    fetch c_get_legal_days into cgl;
    if c_get_legal_days%notfound then
      if (MOD(TO_CHAR(pdate, 'J'), 7) + 1 IN (6, 7)) then
        rez := false;
      end if;
    else
      rez := false;
    end if;
    return rez;
  end;

  function num_days_in_interval(pst_date date, pend_Date date)
    return number as
    -- we choose all legal days that are not in a weekend
    cursor c_legal_day is
      select legal_date
        from legal_days ld
       where ld.in_year = to_char(sysdate, 'YYYY')
         and (MOD(TO_CHAR(legal_date, 'J'), 7) + 1 NOT IN (6, 7));
    init_number number;
    curr_Date   date; -- cursor date that we use to go through the interval
    err_m       varchar2(500);
  begin
    if pst_date <= pend_Date then
      -- we calculate the default number of days between the interval
      select (trunc(pend_date + 1) - trunc(pst_date))
        into init_number
        from dual;
      dbms_output.put_line('starting point ->' || init_number);
      curr_date := pst_Date;
      -- we firstly exclude weekend days if there are any
      loop
        --dbms_output.put_line('data -> ' || curr_date);
        if (MOD(TO_CHAR(curr_date, 'J'), 7) + 1 IN (6, 7)) then
          init_number := init_number - 1;
          /*dbms_output.put_line('este weekend');*/
        end if;
        curr_date := curr_date + 1;
        exit when curr_date > pend_date;
      end loop;
      -- now we exclude legal days that have already been checked for weekend overlap
      for x in c_legal_day loop
        if ((x.legal_date >= pst_date) and (x.legal_date <= pend_date)) then
          init_number := init_number - 1;
        end if;
      end loop;
    else
      select (trunc(pend_date) - trunc(pst_date))
        into init_number
        from dual;
    end if;
    return init_number;
  exception
    when others then
      err_m := substr(sqlerrm, 1, 500);
      raise_application_error(-20150, err_m);
  end num_days_in_interval;

  --#### function no longer used. Less restrictive process of adding requests.!
  function validate_period(p_st_date date, p_end_date date, pdpt_id number) return varchar2 as
    -- we search for how many days of the interval are already covered
    rez varchar2(60);
    existing_req_per_int number;
    accepted_final_no number;
    reserves number;
    deficit number;
    exm varchar2(500);
  begin
    existing_req_per_int := 0;
    for k in (select * from requests rq where rq.resolved = 'D' and rq.dept_id  = pdpt_id and (trunc(rq.start_date) <= trunc(p_end_date) and trunc(rq.end_date) >= trunc(p_st_date))) loop
      -- for each req overlapped we increase the counter
      existing_req_per_int := existing_req_per_int + 1;
    end loop;
    -- we calculate the total number of accepted people on leave per dept
    begin
      select dp.no_of_res, dr.accepted_deficit
        into reserves, deficit
        from departments dp
        join dept_requirements dr
          on dp.code = dr.code
       where dp.dep_id = pdpt_id;
    exception
      when no_data_found then
        rez := 'No Such department';
        return rez;
    end;
    accepted_final_no := reserves + deficit;
    if (accepted_final_no < (existing_req_per_int + 1)) then
      rez := 'OK';
      return rez;
    else
      rez := 'Overlap beyond accepted number, all reserves are on Holiday in that period.';
      return rez;
    end if;
  exception
    when no_data_found then
      exm := substr(sqlerrm, 1, 500);
        raise_application_error(-20155, exm);
  end validate_period;

  procedure insert_request(p_l_type varchar, p_start_date Date, p_end_date Date, pemp_id number, p_dept_id number, p_total_days number,p_is_retroactive varchar2, p_id_req out number) as
    p_out_msg varchar2(255);
  begin
    if p_l_type = 'VACATION_LEAVE'  then
        insert into requests
              (id,
               type_of_req,
               status,
               submition_date,
               emp_id,
               dept_id,
               start_date,
               end_date,
               total_no_of_days,
               resolved,
               res_user,
               rejected,
               rejected_user,
               is_retroactive,
               under_review
               )
            values
              ( REQ_ID_SEQ.NEXTVAL,
                p_l_type,
                'SUBMITTED',
                trunc(sysdate),
                pemp_id,
                p_dept_id,
                p_start_date,
                p_end_date,
                p_total_days,
                'N',
                null,
                'N',
                null,
                p_is_retroactive,
                'N');
        p_id_req := req_id_seq.currval;
    else
          insert into requests
              (id,
               type_of_req,
               status,
               submition_date,
               emp_id,
               dept_id,
               start_date,
               end_date,
               total_no_of_days,
               resolved,
               res_user,
               rejected,
               rejected_user,
               is_retroactive,
               under_review
               )
            values
              ( REQ_ID_SEQ.NEXTVAL,
                p_l_type,
                'SUBMITTED',
                trunc(sysdate),
                pemp_id,
                p_dept_id,
                p_start_date,
                p_end_date,
                p_total_days,
                'N',
                null,
                'N',
                null,
                p_is_retroactive,
                'N');
      p_id_req := req_id_seq.currval;
    end if;
  exception
    when others then
      rollback;
      p_out_msg := substr(sqlerrm, 1, 500);
      raise_application_error(-20155, p_out_msg);
  end insert_request;


  procedure insert_rq_from_db(p_l_type varchar, p_start_date Date, p_end_date Date, pemp_id number, p_dept_id number, p_is_retroactive varchar2, p_id_req out number) is
      p_out_msg varchar2(255);
      number_of_days number;
  begin
    number_of_days := num_days_in_interval(pst_date => p_start_date, pend_Date => p_end_date);

    if p_l_type = 'VACATION_LEAVE'  then
        insert into requests
              (id,
               type_of_req,
               status,
               submition_date,
               emp_id,
               dept_id,
               start_date,
               end_date,
               total_no_of_days,
               resolved,
               res_user,
               rejected,
               rejected_user,
               is_retroactive,
               under_review
               )
            values
              ( REQ_ID_SEQ.NEXTVAL,
                p_l_type,
                'SUBMITTED',
                trunc(sysdate),
                pemp_id,
                p_dept_id,
                p_start_date,
                p_end_date,
                number_of_days,
                'N',
                null,
                'N',
                null,
                p_is_retroactive,
                'N');
        p_id_req := req_id_seq.currval;
    else
          insert into requests
              (id,
               type_of_req,
               status,
               submition_date,
               emp_id,
               dept_id,
               start_date,
               end_date,
               total_no_of_days,
               resolved,
               res_user,
               rejected,
               rejected_user,
               is_retroactive,
               under_review
               )
            values
              ( REQ_ID_SEQ.NEXTVAL,
                p_l_type,
                'SUBMITTED',
                trunc(sysdate),
                pemp_id,
                p_dept_id,
                p_start_date,
                p_end_date,
                number_of_days,
                'N',
                null,
                'N',
                null,
                p_is_retroactive,
                'N');
      p_id_req := req_id_seq.currval;
    end if;
  exception
    when others then
      rollback;
      p_out_msg := substr(sqlerrm, 1, 500);
      raise_application_error(-20155, p_out_msg);
  end insert_rq_from_db;


  procedure delete_this_request(pid_req number, pemp_id number) is
    --  no need for additional checks here as we will have a procedure that calculates all of the possible actions on a request
    errm varchar2(500);
    PARAMTERII_NULI exception;
  begin
    if (pid_req is not null and pemp_id is not null)then
      delete requests rq where rq.id = pid_req and rq.emp_id = pemp_id;
    else
      raise PARAMTERII_NULI;
    end if;
  exception
    when PARAMTERII_NULI then
      raise_application_error(-20155, 'Could not determine which request to delete');
    when others then
      errm := substr(sqlerrm, 1, 500);
      raise_application_error(-20154, 'Error deleting request: ' || errm);
  end;

  procedure update_this_request(pid_req number, p_req_type varchar, p_start_date date, p_end_date date, p_total_days number) is
    -- all other checks before updating are done in the trigger
    reqFound number;
    errm varchar2(500);
  begin
    select count(*) into reqFound from requests rq where rq.id = pid_req;
    if(reqFound = 1) then
      update requests rq
         set rq.type_of_req      = p_req_type,
             rq.start_date       = p_start_date,
             rq.end_date         = p_end_date,
             rq.total_no_of_days = p_total_days
       where rq.id = pid_req;
       commit;
    else
      raise_application_error(-20157, 'Request to update NOT Found! ');
    end if;
  exception
    when others then
      rollback;
      errm := substr(sqlerrm, 1, 500);
      raise_application_error(-20157, 'Error in updating request: ' || errm);
  end;

  function pending_vacation_req(pemp_id number, pdept_id number) return number as

    /*Returns an info message saying there are other pending requests as well*/
    -- we search for all unprocessed requests
    cursor c_get_pend_vac_leave is
      select count(*) "TOATE"
        from requests rq
       where exists (select 1 from status_types st where st.stat_code = rq.status and st.final = 'N')
         and rq.resolved = 'N'
         and rq.rejected = 'N'
         and rq.emp_id = pemp_id
         and rq.dept_id = pdept_id
         and rq.type_of_req <> 'MEDICAL_LEAVE';
    rez number;
  begin
    for x in c_get_pend_vac_leave loop
      rez := x.TOATE;
    end loop;
    return rez;
  end;

  function get_submitted_overlapped_days(preq_id number) return col_overlapped_days as
    od col_overlapped_days := col_overlapped_days();
    od_distinct col_overlapped_days := col_overlapped_days();

    currDate date;
    D number;
    Mnth varchar2(30);
    REQ_NOT_FOUND EXCEPTION;
    errm varchar2(255);
    cursor getRequest is
      select * from requests rq where rq.id = preq_id;
    gr getRequest%rowtype;
  begin
    Mnth := '';
    open getRequest;
    fetch getRequest into gr;

    if getRequest%found then
      -- we go through all submitted requests(except the one in question) to see if it may overlap
      for x in(select * from requests rq where rq.status = 'SUBMITTED' and rq.resolved != 'D' and rq.type_of_req != 'MEDICAL_LEAVE' and rq.id != preq_id  and (trunc(rq.start_date) <= trunc(gr.end_date) and trunc(rq.end_date) >= trunc(gr.start_date))) loop
        dbms_output.put_line('found submitted');
        currDate := x.start_date;
        loop
          exit when currDate > x.end_date;
            if (is_working_day(currDate)) then
              if(trunc(currDate) >= gr.start_date and trunc(currDate) <= gr.end_date) then
                D := to_number(extract(DAY from currDate));
                Mnth := trim(to_char(to_date(to_number(extract(month from currDate)), 'MM'), 'MONTH'));

                od.extend;
                od(od.last) := (overlap_day(D, Mnth));
              end if;
            else
              currDate := currDate + 1;
              continue;
            end if;
          currDate := currDate + 1;
        end loop;
      end loop;
    else
      raise REQ_NOT_FOUND;
    end if;
    close getRequest;
   --we go through the collection and get all distinct values so we don't repeat an overlapped day
    -- in case of multiple overlaps
    for x in (select distinct * from table(od) order by day_overlapped asc) loop
      od_distinct.extend;
      od_distinct(od_distinct.last) := (overlap_day(x.DAY_OVERLAPPED, x.MONTH_OF_DAY));
    end loop;

    return od_distinct;
  exception
    when REQ_NOT_FOUND then
      raise_application_error(-20150, 'No such req found when checking for overlapps');
    when others then
      errm := substr(sqlerrm, 1, 500);
      raise_application_error(-20150, errm);
  end;

  function get_resolved_overlapped_days(preq_id number) return col_overlapped_days as
    od col_overlapped_days := col_overlapped_days();
    od_distinct col_overlapped_days := col_overlapped_days();

    currDate date;
    D number;
    Mnth varchar2(30);
    REQ_NOT_FOUND EXCEPTION;
    errm varchar2(255);
    cursor getRequest is
      select * from requests rq where rq.id = preq_id;
    gr getRequest%rowtype;
  begin
    Mnth := '';
    open getRequest;
    fetch getRequest into gr;

    if getRequest%found then
      -- we go through all resolved requests to see if it may overlap
      for x in (select * from requests rq where rq.resolved = 'D' and rq.status = 'RESOLVED' and rq.type_of_req != 'MEDICAL_LEAVE' and rq.dept_id  = gr.dept_id and (trunc(rq.start_date) <= trunc(gr.end_date) and trunc(rq.end_date) >= trunc(gr.start_date))) loop
        dbms_output.put_line('found resolvedd');
        currDate := x.start_date;
        loop
          exit when currDate > x.end_date;
            if (is_working_day(currDate)) then
              if(trunc(currDate) >= gr.start_date and trunc(currDate) <= gr.end_date) then
                D := to_number(extract(DAY from currDate));
                Mnth := trim(to_char(to_date(to_number(extract(month from currDate)), 'MM'), 'MONTH'));
                od.extend;
                od(od.last) := (overlap_day(D, Mnth));
              end if;
            else
              currDate := currDate + 1;
              continue;
            end if;
          currDate := currDate + 1;
        end loop;
      end loop;
    else
      raise REQ_NOT_FOUND;
    end if;
    close getRequest;
    --we go through the collection and get all distinct values so we don't repeat an overlapped day
    -- in case of multiple overlaps
    for x in (select distinct * from table(od) order by day_overlapped asc) loop
      od_distinct.extend;
      od_distinct(od_distinct.last) := (overlap_day(x.DAY_OVERLAPPED, x.MONTH_OF_DAY));
    end loop;

    return od_distinct;
  exception
    when REQ_NOT_FOUND then
      raise_application_error(-20150, 'No such req found when checking for overlapps');
    when others then
      errm := substr(sqlerrm, 1, 500);
      raise_application_error(-20150, errm);
  end;

  -- Function that checks all resolved and submitted requests for overlapped days. This will be called when manually resolving
  function get_all_overlapped_days(preq_id number) return col_overlapped_days as
    od col_overlapped_days := col_overlapped_days();
    od_distinct col_overlapped_days := col_overlapped_days();

    currDate date;
    D number;
    Mnth varchar2(30);
    REQ_NOT_FOUND EXCEPTION;
    errm varchar2(255);
    cursor getRequest is
      select * from requests rq where rq.id = preq_id;
    gr getRequest%rowtype;
  begin
    Mnth := '';
    open getRequest;
    fetch getRequest into gr;

    if getRequest%found then
      -- we go through all resolved requests to see if it may overlap
      for x in (select * from requests rq where rq.resolved = 'D' and rq.status = 'RESOLVED' and rq.type_of_req != 'MEDICAL_LEAVE'  and rq.dept_id  = gr.dept_id and (trunc(rq.start_date) <= trunc(gr.end_date) and trunc(rq.end_date) >= trunc(gr.start_date))) loop
        dbms_output.put_line('found resolvedd');
        currDate := x.start_date;
        loop
          exit when currDate > x.end_date;
            if (is_working_day(currDate)) then
              if(trunc(currDate) >= gr.start_date and trunc(currDate) <= gr.end_date) then
                D := to_number(extract(DAY from currDate));
                Mnth := trim(to_char(to_date(to_number(extract(month from currDate)), 'MM'), 'MONTH'));
                od.extend;
                od(od.last) := (overlap_day(D, Mnth));
              end if;
            else
              currDate := currDate + 1;
              continue;
            end if;
          currDate := currDate + 1;
        end loop;
      end loop;
      -- we go through all submitted requests(except the one in question) to see if it may overlap
      for x in(select * from requests rq where rq.status = 'SUBMITTED' and rq.resolved != 'D' and rq.type_of_req != 'MEDICAL_LEAVE' and rq.id != preq_id  and (trunc(rq.start_date) <= trunc(gr.end_date) and trunc(rq.end_date) >= trunc(gr.start_date))) loop
        dbms_output.put_line('found submitted');
        currDate := x.start_date;
        loop
          exit when currDate > x.end_date;
            if (is_working_day(currDate)) then
              if(trunc(currDate) >= gr.start_date and trunc(currDate) <= gr.end_date) then
                D := to_number(extract(DAY from currDate));
                Mnth := trim(to_char(to_date(to_number(extract(month from currDate)), 'MM'), 'MONTH'));

                od.extend;
                od(od.last) := (overlap_day(D, Mnth));
              end if;
            else
              currDate := currDate + 1;
              continue;
            end if;
          currDate := currDate + 1;
        end loop;
      end loop;
    else
      raise REQ_NOT_FOUND;
    end if;
    close getRequest;
    --we go through the collection and get all distinct values so we don't repeat an overlapped day
    -- in case of multiple overlaps
    for x in (select distinct * from table(od) order by day_overlapped asc) loop
      od_distinct.extend;
      od_distinct(od_distinct.last) := (overlap_day(x.DAY_OVERLAPPED, x.MONTH_OF_DAY));
    end loop;

    return od_distinct;
  exception
    when REQ_NOT_FOUND then
      raise_application_error(-20150, 'No such req found when checking for overlapps');
    when others then
      errm := substr(sqlerrm, 1, 500);
      raise_application_error(-20150, errm);
  end;
end AC_req_actions;