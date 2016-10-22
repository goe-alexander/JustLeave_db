create or replace trigger DEPARTMENTS_BI
  before insert on departments
  for each row

DECLARE
  cursor c_receiver_is_tm is
    select 1
      from user_atributions ua
      join app_users au
        on au.id = ua.acc_id
      join role_types rt
        on rt.role_id = ua.role_id
     where au.emp_id = :new.tm_id
       and rt.role_code = 'TEAM_LEAD';
  crt  c_receiver_is_tm%rowtype;
  errm varchar2(250);

  NOT_TEAM_MANAGER exception;
BEGIN
  open c_receiver_is_tm;
  fetch c_receiver_is_tm
    into crt;
  if c_receiver_is_tm%found then
    null;
  else
    raise NOT_TEAM_MANAGER;
  end if;
  close c_receiver_is_tm;
EXCEPTION
  when NOT_TEAM_MANAGER then
    raise_application_error(-20150,
                            'Employee does not have a manager role');
  when others then
    errm := substr(sqlerrm, 1, 500);
    raise_application_error(-20151, errm);
END;