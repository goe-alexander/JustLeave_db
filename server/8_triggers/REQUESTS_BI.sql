create or replace trigger REQUESTS_BI
  BEFORE Insert on REQUESTS for each row

DECLARE
  err varchar2(255);
  cursor cemp_from_dept is
    select 1 from departments dp
      join employees emp on emp.dep_id = dp.dep_id
      where dp.dep_id = :new.dept_id
        and emp.emp_id = :new.emp_id
        and dp.active = 'D';
  ced cemp_from_dept%rowtype;

BEGIN
  open cemp_from_dept;
  fetch cemp_from_dept into ced;
  if cemp_from_dept%notfound then
    raise_application_error(-20155, 'department of employee not a match');
  end if;

  if :new.is_retroactive != 'D' then
    if :new.submition_date >= :new.start_date then
      raise_application_error(-20155, 'Start Date is in the past. Please make retroactive Request. ');
    end if;

  end if;

  if :new.total_no_of_days = 0 then
    raise_application_error(-20155, 'Days in interval can not be 0!');
  end if;
EXCEPTION
  when others then
    err := substr(sqlerrm, 1, 500);
    raise_application_error(-20155, err);
END;