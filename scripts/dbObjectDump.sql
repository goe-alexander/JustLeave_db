-----------------------------------------------------
-- Export file for user APPCON                     --
-- Created by Alexandru on 22-10-2016, 10:48:50 AM --
-----------------------------------------------------

set define off
spool dbDump.log

prompt
prompt Creating table DEPARTMENTS
prompt ==========================
prompt
create table APPCON.DEPARTMENTS
(
  dep_id          NUMBER(18) not null,
  code            VARCHAR2(60),
  active          VARCHAR2(1),
  no_of_main_emp  NUMBER(30),
  no_of_res       NUMBER(30),
  tm_id           NUMBER,
  description     VARCHAR2(60),
  no_of_employees NUMBER(30)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index APPCON.IDX_TM_ID_DEPARTMENTS on APPCON.DEPARTMENTS (TM_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.DEPARTMENTS
  add primary key (DEP_ID)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.DEPARTMENTS
  add foreign key (TM_ID)
  references APPCON.EMPLOYEES (EMP_ID);
alter table APPCON.DEPARTMENTS
  add constraint CHECK_ACTIV_DEP
  check (active in ('D', 'N') );

prompt
prompt Creating table EMPLOYEES
prompt ========================
prompt
create table APPCON.EMPLOYEES
(
  emp_id       NUMBER not null,
  f_name       VARCHAR2(60),
  l_name       VARCHAR2(60),
  email        VARCHAR2(60),
  hire_date    DATE,
  tm_id        NUMBER,
  dep_id       NUMBER,
  trial_period VARCHAR2(1)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.EMPLOYEES
  add primary key (EMP_ID)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.EMPLOYEES
  add constraint FK_DEPT_ID foreign key (DEP_ID)
  references APPCON.DEPARTMENTS (DEP_ID);
alter table APPCON.EMPLOYEES
  add constraint FK_MANAGER_ID foreign key (TM_ID)
  references APPCON.EMPLOYEES (EMP_ID);

prompt
prompt Creating table APP_USERS
prompt ========================
prompt
create table APPCON.APP_USERS
(
  id     NUMBER,
  code   VARCHAR2(60) not null,
  emp_id NUMBER(10),
  active VARCHAR2(1) default 'D'
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.APP_USERS
  add constraint PK_USR_NM_CODE primary key (CODE)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.APP_USERS
  add constraint UQ_ID_COL unique (ID)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.APP_USERS
  add constraint FK_EMP_ID foreign key (EMP_ID)
  references APPCON.EMPLOYEES (EMP_ID);
alter table APPCON.APP_USERS
  add constraint CK_ACTIV_IN_VAL
  check (active in ('D', 'N'));

prompt
prompt Creating table REQUEST_TYPES
prompt ============================
prompt
create table APPCON.REQUEST_TYPES
(
  type_id         NUMBER,
  req_code        VARCHAR2(60) not null,
  active          VARCHAR2(1),
  requires_flux   VARCHAR2(1) default 'N',
  req_description VARCHAR2(60)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.REQUEST_TYPES
  add constraint PK_REQ_CODE primary key (REQ_CODE)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.REQUEST_TYPES
  add constraint CHCK_ACTIVE_REQ
  check (active in ('D','N'));
alter table APPCON.REQUEST_TYPES
  add constraint CHCK_NECESITA_FLUX
  check (requires_flux in ('D', 'N'));

prompt
prompt Creating table DAYS_PER_MONTH
prompt =============================
prompt
create table APPCON.DAYS_PER_MONTH
(
  req_code   VARCHAR2(30),
  no_of_days NUMBER(10)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.DAYS_PER_MONTH
  add constraint FK_REQ_DAY_P_MONTH foreign key (REQ_CODE)
  references APPCON.REQUEST_TYPES (REQ_CODE);

prompt
prompt Creating table DAYS_PER_YEAR
prompt ============================
prompt
create table APPCON.DAYS_PER_YEAR
(
  req_code    VARCHAR2(60),
  max_no_days NUMBER(10)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.DAYS_PER_YEAR
  add constraint UQ_REQ_NO_DAYS unique (REQ_CODE, MAX_NO_DAYS)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table DEPT_REQUIREMENTS
prompt ================================
prompt
create table APPCON.DEPT_REQUIREMENTS
(
  code             VARCHAR2(60),
  start_date       DATE,
  end_date         DATE,
  required_people  NUMBER,
  accepted_deficit NUMBER
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table LEGAL_DAYS
prompt =========================
prompt
create table APPCON.LEGAL_DAYS
(
  legal_date DATE not null,
  in_year    VARCHAR2(10) not null
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.LEGAL_DAYS
  add constraint PK_LEG_DAYS primary key (LEGAL_DATE, IN_YEAR)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table PASSED_ATTRIBUTIONS
prompt ==================================
prompt
create table APPCON.PASSED_ATTRIBUTIONS
(
  giver_id      NUMBER,
  department_id NUMBER,
  receiver_id   NUMBER,
  accepted      VARCHAR2(1) default 'N'
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.PASSED_ATTRIBUTIONS
  add constraint UK_COMPOSITE_KEY unique (GIVER_ID, DEPARTMENT_ID, RECEIVER_ID)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.PASSED_ATTRIBUTIONS
  add constraint FK_DEPARTMENT_ID foreign key (DEPARTMENT_ID)
  references APPCON.DEPARTMENTS (DEP_ID);
alter table APPCON.PASSED_ATTRIBUTIONS
  add constraint FK_GIVER_ID foreign key (GIVER_ID)
  references APPCON.EMPLOYEES (EMP_ID);
alter table APPCON.PASSED_ATTRIBUTIONS
  add constraint FK_RECEIVER_ID foreign key (RECEIVER_ID)
  references APPCON.EMPLOYEES (EMP_ID);
alter table APPCON.PASSED_ATTRIBUTIONS
  add constraint CHCK_ACCEPTED
  check (accepted in ('D', 'N'));

prompt
prompt Creating table STATUS_TYPES
prompt ===========================
prompt
create table APPCON.STATUS_TYPES
(
  stat_code   VARCHAR2(60) not null,
  description VARCHAR2(30),
  active      VARCHAR2(1),
  final       VARCHAR2(1)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.STATUS_TYPES
  add primary key (STAT_CODE)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table POSSIBLE_STATUS_CHANGE
prompt =====================================
prompt
create table APPCON.POSSIBLE_STATUS_CHANGE
(
  current_state VARCHAR2(30),
  future_state  VARCHAR2(30)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.POSSIBLE_STATUS_CHANGE
  add constraint FK_CURR_STATE foreign key (CURRENT_STATE)
  references APPCON.STATUS_TYPES (STAT_CODE) on delete cascade;
alter table APPCON.POSSIBLE_STATUS_CHANGE
  add constraint FK_FUTURE_STATE foreign key (FUTURE_STATE)
  references APPCON.STATUS_TYPES (STAT_CODE) on delete cascade;

prompt
prompt Creating table REQUESTS
prompt =======================
prompt
create table APPCON.REQUESTS
(
  id               NUMBER(10) not null,
  type_of_req      VARCHAR2(60),
  status           VARCHAR2(60),
  submition_date   DATE,
  emp_id           NUMBER,
  dept_id          NUMBER,
  start_date       DATE,
  end_date         DATE,
  total_no_of_days NUMBER(10),
  resolved         VARCHAR2(1) default 'N',
  res_user         NUMBER,
  rejected         VARCHAR2(1) default 'N',
  rejected_user    NUMBER,
  is_retroactive   VARCHAR2(1) default 'N',
  under_review     VARCHAR2(1) default 'N'
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.REQUESTS
  add constraint REQ_ID_PK primary key (ID)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.REQUESTS
  add constraint REJ_USR_FK foreign key (REJECTED_USER)
  references APPCON.EMPLOYEES (EMP_ID);
alter table APPCON.REQUESTS
  add constraint RES_USR_FK foreign key (RES_USER)
  references APPCON.EMPLOYEES (EMP_ID);
alter table APPCON.REQUESTS
  add constraint STATUS_REQ_FK foreign key (TYPE_OF_REQ)
  references APPCON.REQUEST_TYPES (REQ_CODE);
alter table APPCON.REQUESTS
  add constraint CHK_REJECTED_VALUE
  check (rejected in ('D', 'N'));
alter table APPCON.REQUESTS
  add constraint CHK_RESOLVED_VALUE
  check (resolved in ('D', 'N'));
alter table APPCON.REQUESTS
  add constraint CHK_UNDER_REVIEW_VALUE
  check (under_review in ('D', 'N'));

prompt
prompt Creating table RESTANT_DAYS
prompt ===========================
prompt
create table APPCON.RESTANT_DAYS
(
  empl_id        NUMBER,
  remaining_days NUMBER,
  remaining_year VARCHAR2(10)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index APPCON.EMPL_ID_IDX on APPCON.RESTANT_DAYS (EMPL_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.RESTANT_DAYS
  add constraint UQ_ROW unique (EMPL_ID, REMAINING_DAYS, REMAINING_YEAR)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table ROLE_TYPES
prompt =========================
prompt
create table APPCON.ROLE_TYPES
(
  role_id          NUMBER(10) not null,
  role_code        VARCHAR2(30),
  role_description VARCHAR2(60),
  active           VARCHAR2(1) default 'D',
  priority         NUMBER(3)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.ROLE_TYPES
  add constraint PK_ROL_ID primary key (ROLE_ID)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.ROLE_TYPES
  add constraint CHCK_IS_ACTV
  check (active in ('D', 'N'));

prompt
prompt Creating table SKILL_TYPES
prompt ==========================
prompt
create table APPCON.SKILL_TYPES
(
  skill_code        VARCHAR2(60) not null,
  skill_description VARCHAR2(80)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.SKILL_TYPES
  add primary key (SKILL_CODE)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table SKILL_MATRIX
prompt ===========================
prompt
create table APPCON.SKILL_MATRIX
(
  emp_id NUMBER,
  skill  VARCHAR2(60),
  lvl    NUMBER
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.SKILL_MATRIX
  add constraint FK_EMP_ID_SKMATRIX foreign key (EMP_ID)
  references APPCON.EMPLOYEES (EMP_ID);
alter table APPCON.SKILL_MATRIX
  add constraint FK_SKILL_CODE foreign key (SKILL)
  references APPCON.SKILL_TYPES (SKILL_CODE);
alter table APPCON.SKILL_MATRIX
  add constraint CHCK_LVL_VALUES
  check (lvl in (1, 2, 3, 4, 5 ));

prompt
prompt Creating table SL_ERRORS
prompt ========================
prompt
create table APPCON.SL_ERRORS
(
  cod_err         VARCHAR2(10) not null,
  err_description VARCHAR2(250),
  active          VARCHAR2(1) default 'D'
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index APPCON.ERR_DESCR_IDX on APPCON.SL_ERRORS (ERR_DESCRIPTION)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.SL_ERRORS
  add constraint COR_ERR_PK primary key (COD_ERR)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table STANDARD_NOTIFICATIONS
prompt =====================================
prompt
create table APPCON.STANDARD_NOTIFICATIONS
(
  cod_notif      VARCHAR2(10) not null,
  mesaj_notif    VARCHAR2(100) not null,
  target_for_msg VARCHAR2(60) not null
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index APPCON.STANDARD_NOTIF_IDX on APPCON.STANDARD_NOTIFICATIONS (COD_NOTIF)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.STANDARD_NOTIFICATIONS
  add constraint COUMPOUND_PK primary key (COD_NOTIF, MESAJ_NOTIF, TARGET_FOR_MSG)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt
prompt Creating table USER_ATRIBUTIONS
prompt ===============================
prompt
create table APPCON.USER_ATRIBUTIONS
(
  acc_id  NUMBER(10) not null,
  role_id NUMBER(10) not null
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index APPCON.IDX_ATTRIB_ACC_ID on APPCON.USER_ATRIBUTIONS (ACC_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.USER_ATRIBUTIONS
  add constraint PK primary key (ACC_ID, ROLE_ID)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.USER_ATRIBUTIONS
  add foreign key (ACC_ID)
  references APPCON.APP_USERS (ID);
alter table APPCON.USER_ATRIBUTIONS
  add foreign key (ROLE_ID)
  references APPCON.ROLE_TYPES (ROLE_ID);

prompt
prompt Creating table USER_CREDENTIALS
prompt ===============================
prompt
create table APPCON.USER_CREDENTIALS
(
  user_nm   VARCHAR2(60),
  pass_word VARCHAR2(256)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table APPCON.USER_CREDENTIALS
  add constraint FK_USER_CRED_NAME_FK foreign key (USER_NM)
  references APPCON.APP_USERS (CODE);

prompt
prompt Creating sequence APP_USERS_SEQ
prompt ===============================
prompt
create sequence APPCON.APP_USERS_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence EMP_ID_SEQ
prompt ============================
prompt
create sequence APPCON.EMP_ID_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 49
increment by 1
nocache;

prompt
prompt Creating sequence REQ_ID_SEQ
prompt ============================
prompt
create sequence APPCON.REQ_ID_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 132
increment by 1
nocache;

prompt
prompt Creating sequence REQ_TYPE_GENERATOR
prompt ====================================
prompt
create sequence APPCON.REQ_TYPE_GENERATOR
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence ROLE_TYPES_SEQ
prompt ================================
prompt
create sequence APPCON.ROLE_TYPES_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 7
increment by 1
nocache;

prompt
prompt Creating sequence STAT_TYPE_SEQ
prompt ===============================
prompt
create sequence APPCON.STAT_TYPE_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating type OVERLAP_DAY
prompt =========================
prompt
create or replace type appcon.overlap_day as object(
  day_overlapped number,
  month_of_day varchar2(10)

)
/

prompt
prompt Creating type COL_OVERLAPPED_DAYS
prompt =================================
prompt
create or replace type appcon.col_overlapped_days is table of overlap_day
/

prompt
prompt Creating package AC_REQ_ACTIONS
prompt ===============================
prompt
create or replace package appcon.AC_req_actions as

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
/

prompt
prompt Creating package ADMIN_UTILS
prompt ============================
prompt
create or replace package appcon.ADMIN_UTILS as

  -- admin procedure for registering new accounts.
  procedure insert_new_employee(pf_name varchar2, pl_name varchar2, p_email varchar2, phire_date date, p_tm_id number, pdep_id number, ptrial_period varchar2, out_emp_id OUT number);
  function insert_new_employee(pf_name varchar2, pl_name varchar2, p_email varchar2, phire_date date, p_tm_id number, pdep_id number, ptrial_period boolean )  return number;
  function create_new_user(p_user_name varchar2, p_password varchar2, pemp_id number, p_department varchar2, ptm_id number) return number;
  
  -- when deleting an employee all app users tied to that account( which should be one ) need to also be removed 
   procedure delete_empl(pid_empl number);
   procedure edit_empl(pemp_id number, pf_name varchar2, pl_name varchar2, pemail varchar2, phire_date date, pTm_ID number, pDep_id number);
   
   -- get all app-users tied to an employee
   procedure get_emp_appuser(pid_empl number);
   
   -- add user Roles and revoke them 
   procedure remove_user_role(pacc_id number, prole_id number);
   procedure add_user_role(pacc_id number, prole_id number);
end ADMIN_UTILS;
/

prompt
prompt Creating type EMP_DETAILS_TYPE
prompt ==============================
prompt
create or replace type appcon.emp_details_type as object(
  acc_id number,
  emp_id number,
  f_name varchar2(80),
  l_name varchar2(80),
  dep_id number,
  tm_id number,
  email varchar2(80),
  hire_date date
)
/

prompt
prompt Creating package EMP_DETAILS
prompt ============================
prompt
create or replace package appcon.EMP_details as
  procedure get_emp_details(p_acc_name in varchar2, p_emp_out out emp_details_type);
  -- we create another procedure to check the users role
  procedure get_users_role(papp_user_code varchar2, out_usr_role out varchar2);
  procedure give_skill(pemp_id number, pskill_id number, plevel number);
  procedure define_skill(pskill_code varchar2, pskill_description varchar2);
end EMP_details;
/

prompt
prompt Creating package REMAINING_DAYS
prompt ===============================
prompt
create or replace package appcon.REMAINING_DAYS as
  -- admin procedure for registering new accounts.
  procedure get_vacation_ballance(pemp_id number, pdept_id number, pnow_interval number,rem_days out number, days_taken out number);
  procedure get_restant_ballance(pemp_id number, pdept_id number, pnow_interval number, rem_days out number, days_taken out number);
  
  procedure get_default_vacation_ballance(pemp_id  number, pdept_id number, rem_days out number, days_taken out number);
  procedure get_default_restant_vb(pemp_id  number, pdept_id number, rem_days out number, days_taken out number);
  
end REMAINING_DAYS;
/

prompt
prompt Creating type BULK_REQUESTS
prompt ===========================
prompt
create or replace type appcon.bulk_requests as object(
  req_id number(20),
  emp_id number(20),
  mng_id number(20)
)
/

prompt
prompt Creating type BULK_REQUESTS_ARRAY
prompt =================================
prompt
create or replace type appcon.bulk_requests_array is table of   bulk_requests
/

prompt
prompt Creating package TM_UTILS
prompt =========================
prompt
create or replace package appcon.TM_UTILS as
 
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
/

prompt
prompt Creating type INTEGET_NUMBER
prompt ============================
prompt
create or replace type appcon.integet_number as object (req_id number(20));
/

prompt
prompt Creating type INT_ARRAY
prompt =======================
prompt
create or replace type appcon.int_array as varray(400) of NUMBER
/

prompt
prompt Creating type NEW_EMPLOYEE_TYPE
prompt ===============================
prompt
create or replace type appcon.new_employee_type as object(
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
)
/

prompt
prompt Creating function NUM_DAYS_IN_INTERVAL
prompt ======================================
prompt
create or replace function appcon.num_days_in_interval(pst_date date, pend_Date date) return number as
    -- we choose all legal days that are not in a weekend
    cursor c_legal_day is
      select legal_date from legal_days ld
        where ld.in_year = to_char(sysdate,'YYYY')
          and (MOD(TO_CHAR(legal_date, 'J'), 7) + 1 NOT IN (6, 7));
    init_number number;
    curr_Date date; -- cursor date that we use to go through the interval
    err_m varchar2(500);
  begin
   -- we calculate the default number of days between the interval
    select (trunc(pend_date + 1) - trunc(pst_date)) into init_number from dual;
     dbms_output.put_line('starting point ->' || init_number);
    curr_date := pst_Date;
    -- we firstly exclude weekend days if there are any
    loop
       --dbms_output.put_line('data -> ' || curr_date);
      if (MOD(TO_CHAR(curr_date, 'J'), 7) + 1 IN (6, 7)) then
        init_number := init_number -1;
        /*dbms_output.put_line('este weekend');*/
      end if;
      curr_date := curr_date+1;
      exit when curr_date > pend_date;
    end loop;
    -- now we exclude legal days that have already been checked for weekend overlap
    for x in c_legal_day loop
      if ((x.legal_date >= pst_date) and (x.legal_date <= pend_date)) then
        init_number := init_number - 1;
      end if;
    end loop;

    return init_number;
  exception
    when others then
      err_m := substr(sqlerrm, 1, 500);
      raise_application_error(-20150, err_m);
  end num_days_in_interval;
/

prompt
prompt Creating function VALIDATE_PERIOD
prompt =================================
prompt
create or replace function appcon.validate_period(p_st_date date, p_end_date date, pdpt_id number) return varchar2 as
      -- we search for how many days of the interval are already covered
    rez varchar2(60);
    existing_req_per_int number;
    accepted_final_no number;
    reserves number;
    deficit number;
    exm varchar2(500);
  begin
    existing_req_per_int := 0;
    for k in (select * from requests rq where rq.resolved = 'D' and rq.dept_id  = pdpt_id and (trunc(rq.start_date) <= trunc(p_st_date) or trunc(rq.end_date) >= trunc(p_end_date))) loop
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
      rez := 'Overlap beyond accepted number';
      return rez;
    end if;
  exception
    when no_data_found then
      exm := substr(sqlerrm, 1, 500);
        raise_application_error(-20155, exm);
  end validate_period;
/

prompt
prompt Creating procedure CLEAR_ALL_TB_IN_DB
prompt =====================================
prompt
create or replace procedure appcon.clear_All_tb_in_db as
  i number;
begin
i:=0;
  for x in (select table_name from user_tables) loop
    execute immediate 'drop table ' || x.table_name;
    i := i+1;
    dbms_output.put_line('Dropped table: ' || x.table_name);
  end loop;
  dbms_output.put_line('Nr tabele sterse: ' || i);
end;
/

prompt
prompt Creating package body AC_REQ_ACTIONS
prompt ====================================
prompt
create or replace package body appcon.AC_req_actions as
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
/

prompt
prompt Creating package body ADMIN_UTILS
prompt =================================
prompt
create or replace package body appcon.ADMIN_UTILS as
  -- internal procedure to delete an app user when an employee is deleted
  -- tables in question: app_users, user_attribtions, user_credentials 
  procedure delete_app_user(pid_app_user number, pempl_id number) as
    cursor c_get_user is
      select apu.code, apu.id, apu.emp_id
        from app_users apu
       where apu.id = pid_app_user
         and apu.emp_id = pempl_id;
  
    errMsg varchar2(255);
  begin
    -- we need to firstly delete the user credentials then attributes
    for x in c_get_user loop
      BEGIN
        delete user_credentials uc where uc.user_nm = x.code;
        delete user_atributions ua where ua.acc_id = x.id;
      
      EXCEPTION
        when others then
          rollback;
          errMsg := substr(sqlerrm, 1, 500);
          raise_application_error(-21500, errMsg);
      END;
    end loop;
    delete app_users a
     where a.id = pid_app_user
       and a.emp_id = pempl_id;
  exception
    when others then
      raise;
  end;

  procedure delete_empl(pid_empl number) as
    errMsg varchar2(255);
    -- cursor that checks if there is an application user to delete it also
    cursor c_check_user is
      select * from app_users au where au.emp_id = pid_empl;
  
    cursor c_exists_empl is
      select 1 from employees emp where emp.emp_id = pid_empl;
    cee c_exists_empl%rowtype;
  
    NO_SUCH_EMPLOYEE Exception;
    OTHER_ROLES      EXCEPTION;
    cursor c_dept_attributions is
      select 1 from departments dep where dep.tm_id = pid_empl;
    cda c_dept_attributions%rowtype;
  
  BEGIN
    -- if any user found then we call internal procedure to delete the user
    open c_exists_empl;
    fetch c_exists_empl
      into cee;
    if c_exists_empl%found then
      open c_dept_attributions;
      fetch c_dept_attributions
        into cda;
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

  procedure insert_new_employee(pf_name       varchar2,
                                pl_name       varchar2,
                                p_email       varchar2,
                                phire_date    date,
                                p_tm_id       number,
                                pdep_id       number,
                                ptrial_period varchar2,
                                out_emp_id    OUT number) as
    errMsg varchar2(255);
    empId  number;
  begin
    begin
      insert into employees
        (emp_id,
         f_name,
         l_name,
         email,
         hire_date,
         tm_id,
         dep_id,
         trial_period)
      values
        (emp_id_seq.nextval,
         pf_name,
         pl_name,
         p_email,
         trunc(phire_date),
         p_tm_id,
         pdep_id,
         ptrial_period);
      commit;
      dbms_output.put_line('inserted the employee');
      empId := emp_id_seq.currval;
    exception
      when others then
        errMsg := substr(sqlerrm, 1, 255);
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
      errMsg := substr(sqlerrm, 1, 255);
      raise_application_error(-20157, errMsg);
  end;

  function insert_new_employee(pf_name       varchar2,
                               pl_name       varchar2,
                               p_email       varchar2,
                               phire_date    date,
                               p_tm_id       number,
                               pdep_id       number,
                               ptrial_period boolean) return number as
    errMsg      varchar2(255);
    empId       number;
    is_on_trial varchar2(1);
  begin
    if ptrial_period then
      is_on_trial := 'D';
    else
      is_on_trial := 'N';
    end if;
    begin
      insert into employees
        (emp_id,
         f_name,
         l_name,
         email,
         hire_date,
         tm_id,
         dep_id,
         trial_period)
      values
        (emp_id_seq.nextval,
         pf_name,
         pl_name,
         p_email,
         trunc(phire_date),
         p_tm_id,
         pdep_id,
         is_on_trial);
      commit;
      empId := emp_id_seq.currval;
    exception
      when others then
        errMsg := substr(sqlerrm, 1, 500);
    end;
    if errMsg is null and empId is not null then
      return empId;
    else
      return - 1;
    end if;
  exception
    when others then
      raise;
  end;

  function create_new_user(p_user_name  varchar2,
                           p_password   varchar2,
                           pemp_id      number,
                           p_department varchar2,
                           ptm_id       number) return number as
    cursor c_user_already_exits is
      select 1 from app_users au where au.code = p_user_name;
    cae c_user_already_exits%Rowtype;
  
    errMsg varchar2(255);
  begin
    open c_user_already_exits;
    fetch c_user_already_exits
      into cae;
    if c_user_already_exits%found then
      -- if username already found we return -1
      return - 1;
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
  procedure edit_empl(pemp_id    number,
                      pf_name    varchar2,
                      pl_name    varchar2,
                      pemail     varchar2,
                      phire_date date,
                      pTm_ID     number,
                      pDep_id    number) as
    cursor c_get_empl is
      select 1 from employees emp where emp.emp_id = pemp_id;
    cge c_get_empl%rowtype;
  
    errM varchar2(255);
    NO_SUCH_USER EXCEPTION;
  BEGIN
    open c_get_empl;
    fetch c_get_empl
      into cge;
    if c_get_empl%found then
      update Employees emp
         set Emp_Id    = pemp_id,
             f_Name    = pf_name,
             l_Name    = pl_name,
             Email     = pemail,
             Hire_Date = phire_date,
             Tm_Id     = pTm_ID,
             Dep_Id    = pDep_id
       where emp.emp_id = pemp_id;
      commit;
    else
      raise NO_SUCH_USER;
    end if;
  EXCEPTION
    when NO_SUCH_USER then
      raise_application_error(-20155, 'Users ID not FOUND !');
    when others then
      rollback;
      errM := substr(sqlerrm, 1, 500);
      raise_application_error(-20155, errM);
  END;

  procedure get_emp_appuser(pid_empl number) as
  BEGIN
    null;
  END;

  -- add user Roles and revoke them 
  procedure remove_user_role(pacc_id number, prole_id number) as
    errM varchar2(255);
    -- each role has to be unique
    unq number;
    NO_ROLE_FOUND EXCEPTION;
  BEGIN
    -- what checks do we need before removing a role 
    -- the id in the dept has to be tightly corelated with the  role, only that role has a trigger action 
    select count(*) into unq from user_atributions ua where ua.acc_id = pacc_id and ua.role_id = prole_id;
    if(unq = 1) then
      delete user_atributions ua where ua.acc_id = pacc_id and ua.role_id = prole_id;
      -- This is for testing purposes transaction will commit all changes if successfull
      /*commit;*/
    elsif(unq = 0) then 
      raise NO_ROLE_FOUND;
    end if;
  EXCEPTION
    when NO_ROLE_FOUND then 
      raise_application_error(-20155, 'No such role found for the account');  
    when others then

      rollback;
      errM := substr(sqlerrm, 1, 255);
      raise_application_error(-20155, errM);  
  END;

  procedure add_user_role(pacc_id number, prole_id number) as
    errM varchar2(255);
  BEGIN
    insert into user_atributions
      (acc_id, role_id)
    values
      (pacc_id, prole_id);  
  EXCEPTION
    when others then
      rollback;
      errM := substr(sqlerrm, 1, 255);
      raise_application_error(-20155, errM);
  END;
end;
/

prompt
prompt Creating package body EMP_DETAILS
prompt =================================
prompt
create or replace package body appcon.EMP_details as
  procedure get_emp_details(p_acc_name in varchar2, p_emp_out out emp_details_type) as
    cursor cget_emp_det is
      select nvl(au.id, '') id,
             nvl(au.emp_id, '') emp_id,
             nvl(emp.f_name, '') f_name,
             nvl(emp.l_name,'') l_name,
             nvl(emp.dep_id,'') dep_id,
             nvl(emp.tm_id,'') tm_id,
             nvl(emp.email,'') email,
             nvl(emp.hire_date, '') hire_date
        from app_users au
        join employees emp
          on au.emp_id = emp.emp_id
       where upper(au.code) = upper(p_acc_name)
         and rownum = 1;
    ced cget_emp_det%rowtype;
  begin
    open cget_emp_det;
    fetch cget_emp_det into ced;
    if cget_emp_det%found then
      p_emp_out := emp_details_type(ced.id, ced.emp_id, ced.f_name, ced.l_name, ced.dep_id, ced.tm_id, ced.email, ced.hire_date);
    end if;
    close cget_emp_det;
  end;


  --This procedure will return the users role in the login backing bean
  -- immediately after validating login credentials

  procedure get_users_role(papp_user_code varchar2, out_usr_role out varchar2) as
    cursor c_get_usr_role is
      select rt.role_code from user_atributions ua
											join role_types rt on ua.role_id = rt.role_id
												where ua.acc_id = (select au.id from app_users au where au.code = upper(papp_user_code));

    errm varchar2(250);
    
    no_role_found exception;
  begin
    out_usr_role := '';
    for x in c_get_usr_role loop
      out_usr_role := out_usr_role ||  x.role_code;     end loop;
  
    if out_usr_role is null then 
      raise no_role_found;
    end if;
  exception
    when no_role_found then 
      raise_application_error(-20155, 'No role found for specified userName'); 
  
    when others then
      errm := substr(sqlerrm, 1, 250);
      out_usr_role := 'Issue in determining role: ' || errm;
  end;
  
  -- theese two procedures will be used only from within sql. 
  -- 
  procedure give_skill(pemp_id number, pskill_id number, plevel number) as
    errm varchar2(255);  
  BEGIN 
    insert into skill_matrix(emp_id, skill, lvl) values(pemp_id, pskill_id, plevel); 
    commit;
  EXCEPTION
    when others then 
      rollback;
      errm := substr(sqlerrm, 1, 255);
      raise_application_error(-20155, errm);
  END;
  
  procedure define_skill(pskill_code varchar2, pskill_description varchar2) as
    errm varchar2(255);
  BEGIN

    insert into skill_types(skill_code, skill_description) values (pskill_code, pskill_description);
    commit;
  EXCEPTION 
    when others then 
      rollback;
      errm := substr(sqlerrm, 1, 255);
      raise_application_error(-20155, errm);
  END;
end  EMP_details;
/

prompt
prompt Creating package body REMAINING_DAYS
prompt ====================================
prompt
create or replace package body appcon.REMAINING_DAYS as

-- all private parameters start with pp,  they will be all initialized by the private procedure init_pp()
  pp_emp_id number;
  pp_trial_period varchar2(1) := 'N';
  pp_hired_this_year boolean := false;
  pp_total_leave_days days_per_year.max_no_days%type;
  pp_dept_code varchar2(60);
  pp_days_per_month number;
  
  procedure init_pp(pemp_id number, pdept_id number) is
    cursor c_get_emp is
      select 1 from employees emp where emp.emp_id = pemp_id;
    cge c_get_emp%rowtype;
    init_err varchar2(500);
  begin
    open c_get_emp;
    fetch c_get_emp into cge;
    if c_get_emp%found then
      begin
        select dp.max_no_days into pp_total_leave_days from days_per_year dp where dp.req_code = 'VACATION_LEAVE';
        select dpm.no_of_days into pp_days_per_month from days_per_month dpm where dpm.req_code = 'VACATION_LEAVE';
        select emp.trial_period into  pp_trial_period  from employees emp where emp.emp_id = pemp_id;
        select dt.code into pp_dept_code from departments dt where dt.dep_id = pdept_id;
        for x in (select 1 from employees emp where emp.emp_id = pemp_id and extract(YEAR from emp.hire_date) = extract(year from sysdate) and rownum = 1) loop
          pp_hired_this_year := true;
        end loop;
      exception
        when no_data_found then
          pp_trial_period := 'X';
          raise_application_error(-20100, 'Unable to determine if in trial_period');
      end;
    else
      -- the employee was not found
      raise_application_error(-20155, 'Unable to determine employee id');
    end if;
    close c_get_emp;
  exception
    when others then
      init_err := substr(sqlerrm, 1, 500);
      raise_application_error(-20156, init_err);
  end;

  -- calculates dates for employees that are in trial period and are hired recently based on what he has left to the end of the year
  function days_for_emp_hired_recently(pemp_id number) return number as
    mb number;
    errm varchar2(500);
    calc_days number;
  begin
    begin
      select months_between((add_months(trunc(sysdate, 'YEAR'), 12) - 1),
                            (select hire_date
                               from employees e
                              where e.emp_id = pemp_id))
        into mb
        from dual;
    exception
      when no_data_found then
        errm := substr(sqlerrm, 1, 500);
        raise_application_error( -20150, errm);
    end;
    -- we multiply the months between with the standard number per month
    calc_days := round((mb * pp_days_per_month), 0 );
    return calc_days;
  exception
    when others then
      errm := substr(sqlerrm, 1, 500);
      raise_application_error( -20100, errm);
  end;


  --Calculates the total number of days 
  procedure get_vacation_ballance(pemp_id number, pdept_id number, pnow_interval number, rem_days out number, days_taken out number) as
    cursor c_get_taken_days is
    select rq.total_no_of_days
        from requests rq
       where rq.emp_id = pemp_id
         and rq.dept_id = pdept_id
         and rq.status <> 'REJECTED'
         and extract(YEAR FROM rq.start_date) = extract(YEAR from sysdate)
         and rq.rejected = 'N'
         and rq.rejected_user is null
         and rq.type_of_req = 'VACATION_LEAVE';
    total_days_taken number := 0;
    remaining_result number;
    errm varchar2(580);
  begin
  -- we initialize the package variables
    init_pp(pemp_id, pdept_id );
  -- we get what was already taken
    for x in c_get_taken_days  loop
      total_days_taken := total_days_taken + x.total_no_of_days;
    end loop;
  
    if (pp_trial_period = 'N' and  pp_hired_this_year = false) then
       -- standard number of days apply
       -- pnow_interval = number of days in selected interval
       remaining_result :=  pp_total_leave_days - (total_days_taken + pnow_interval);
    elsif(pp_trial_period = 'N' and pp_hired_this_year = true) then
      -- we calculate the ammount of legal leaves the emo has and extract from that what he has already taken (from approved requests)
      remaining_result := days_for_emp_hired_recently(pp_emp_id);
      remaining_result := remaining_result - (total_days_taken + pnow_interval);
    elsif (pp_trial_period = 'D') then
      -- assuming standard contract is 3 months then we have
      remaining_result := (3 * pp_days_per_month) - (total_days_taken + pnow_interval);
    end if;
    rem_days := remaining_result;
    days_taken := total_days_taken + pnow_interval;
  exception
    when others then
      errm := substr(sqlerrm,1,500);
      --in case there's an exception we set the values to -1 and display the error message incalculating the data objects
      rem_days := -1;
      days_taken := -1;
      raise_application_error(-20150, errm);
  end;

  procedure get_default_vacation_ballance(pemp_id number, pdept_id number, rem_days out number, days_taken out number) as
    cursor c_get_taken_days is
     select rq.total_no_of_days
        from requests rq
       where rq.emp_id = pemp_id
         and rq.dept_id = pdept_id
         and rq.status <> 'REJECTED'
         and extract(YEAR FROM rq.start_date) = extract(YEAR from sysdate)
         and rq.rejected = 'N'
         and rq.rejected_user is null
         and rq.type_of_req ='VACATION_LEAVE';
    def_rem_days number;
    total_days_taken number;
  begin
    init_pp(pemp_id, pdept_id );
    def_rem_days := 0;
    total_days_taken := 0;
    for x in c_get_taken_days loop
      total_days_taken := total_days_taken + x.total_no_of_days;
    end loop;
    if (total_days_taken <> 0) then
        dbms_output.put_line('we have taken days and all leave days ammount to: ' || pp_total_leave_days);
        if (pp_trial_period = 'N' and  pp_hired_this_year = false) then
           -- standard number of days apply
           def_rem_days :=  pp_total_leave_days - total_days_taken;
           dbms_output.put_line('angajat > 1an : ' || def_rem_days);
        elsif(pp_trial_period = 'N' and pp_hired_this_year = true) then
          -- we calculate the ammount of legal leaves the emo has and extract from that what he has already taken (from approved requests)
          def_rem_days := days_for_emp_hired_recently(pp_emp_id);
          def_rem_days := def_rem_days - total_days_taken;
          dbms_output.put_line('angajat anul asta' || def_rem_days);
        elsif (pp_trial_period = 'D') then
          -- assuming standard contract is 3 months then we have
          def_rem_days := (3 * pp_days_per_month) - total_days_taken;
        end if;
    else
        if (pp_trial_period = 'N' and  pp_hired_this_year = false) then
           -- standard number of days apply
           def_rem_days :=  pp_total_leave_days;
        elsif(pp_trial_period = 'N' and pp_hired_this_year = true) then
          -- we calculate the ammount of legal leaves the emo has and extract from that what he has already taken (from approved requests)
          def_rem_days := days_for_emp_hired_recently(pp_emp_id);
        elsif (pp_trial_period = 'D') then
          -- assuming standard contract is 3 months then we have
          def_rem_days := (3 * pp_days_per_month);
        end if;
    end if;
    rem_days := def_rem_days;
    days_taken := total_days_taken;
  exception
    when others then
      rem_days := -1;
      days_taken := -1;
      raise_application_error(-20150, 'Issue getting taken_days');
  end;
  
  --Gets remaining Days from Last Year
  procedure get_default_restant_vb(pemp_id  number, pdept_id number, rem_days out number, days_taken out number) as
    -- If request is not rejected then it is taken into consideration in VacationBallance
    cursor c_get_taken_days is
     select rq.total_no_of_days
        from requests rq
       where rq.emp_id = pemp_id
         and rq.dept_id = pdept_id
         and rq.status <> 'REJECTED'
         and extract(YEAR FROM rq.start_date) = extract(YEAR from sysdate)
         and rq.rejected = 'N'
         and rq.rejected_user is null
         and rq.type_of_req ='RESTANT_LEAVE';  

    total_days_taken number;  
    total_rem_last_year number;    
    cnt number;
    to_many_rows_in_year EXCEPTION; 
  BEGIN 
    total_days_taken := 0;
    for x in c_get_taken_days loop
      total_days_taken := total_days_taken  + x.total_no_of_days;
    end loop;
    
    cnt := 0;
    -- we go and check how many requests for remaining_leave days have been made
    for x in (select * from restant_days yrd where yrd.empl_id = pemp_id and yrd.remaining_year = extract(YEAR from sysdate) - 1) loop
      cnt := cnt + 1;
      if cnt > 1 then 
        raise to_many_rows_in_year;
      end if;
      total_rem_last_year := x.remaining_days;  
    end loop;
     
    rem_days := total_rem_last_year - total_days_taken;
    days_taken := total_days_taken;
  EXCEPTION
    when to_many_rows_in_year then 
      raise_application_error(-20150, 'To Many Values for remaining Days in last Year');
  END;
  
  procedure get_restant_ballance(pemp_id number, pdept_id number, pnow_interval number, rem_days out number, days_taken out number) as 
    cursor c_get_taken_days is
     select rq.total_no_of_days
        from requests rq
       where rq.emp_id = pemp_id
         and rq.dept_id = pdept_id
         and rq.status <> 'REJECTED'
         and extract(YEAR FROM rq.start_date) = extract(YEAR from sysdate)
         and rq.rejected = 'N'
         and rq.rejected_user is null
         and rq.type_of_req ='RESTANT_LEAVE';
    total_days_taken number;   
    total_rem_last_year number;    
    errm varchar2(255);      
    
    cnt number;
    to_many_rows_in_year EXCEPTION;    
  BEGIN 
    total_days_taken := 0;
    for x in c_get_taken_days loop
      total_days_taken := total_days_taken  + x.total_no_of_days;
    end loop;    
    
    for x in (select * from restant_days yrd where yrd.empl_id = pemp_id and yrd.remaining_year = extract(YEAR from sysdate) - 1) loop
      cnt := cnt + 1;
      if cnt > 1 then 
        raise to_many_rows_in_year;
      end if;
      total_rem_last_year := x.remaining_days;  
    end loop;   
    
    rem_days := total_rem_last_year - pnow_interval;
    days_taken := pnow_interval;
  EXCEPTION
    when to_many_rows_in_year then 
      raise_application_error(-20150, 'To Many Values for remaining Days in last Year'); 
    when others then 
      errm := substr(sqlerrm,1,500);
      --in case there's an exception we set the values to -1 and display the error message incalculating the data objects
      rem_days := -1;
      days_taken := -1;
      raise_application_error(-20150, errm);          
  END;  

  function get_max_sick_days_year return number as

  begin
    null;
  end;
end REMAINING_DAYS;
/

prompt
prompt Creating package body TM_UTILS
prompt ==============================
prompt
create or replace package body appcon.TM_UTILS as
  
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
    update departments dp 
      set dp.tm_id = preceiver
      where dp.dep_id = pdept_id;
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
/

prompt
prompt Creating trigger DEPARTMENTS_BI
prompt ===============================
prompt
create or replace trigger appcon.DEPARTMENTS_BI
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
/

prompt
prompt Creating trigger DEPARTMENTS_BU
prompt ===============================
prompt
create or replace trigger appcon.DEPARTMENTS_BU
  before insert on departments for each row

DECLARE
    cursor c_receiver_is_tm(ptm_id number) is
      select 1 from user_atributions ua
        join app_users au on au.id = ua.acc_id
        join role_types rt on rt.role_id = ua.role_id
        where au.emp_id = ptm_id
          and rt.role_code = 'TEAM_LEAD';          
                    
    crt c_receiver_is_tm%rowtype;
    errm varchar2(250);

    NOT_TEAM_MANAGER exception;
BEGIN
  if(:new.tm_id != :old.tm_id) then  
    open c_receiver_is_tm(:new.tm_id);
    fetch c_receiver_is_tm into crt;
    if c_receiver_is_tm%found then
      null;
    else
      raise NOT_TEAM_MANAGER;
    end if;
    close c_receiver_is_tm;
  end if;  
EXCEPTION
  when NOT_TEAM_MANAGER then
    raise_application_error(-20150, 'Employee does not have a manager role');
  when others then
    errm := substr(sqlerrm, 1, 500);
    raise_application_error(-20151, errm);
END;
/

prompt
prompt Creating trigger REQUESTS_BI
prompt ============================
prompt
create or replace trigger appcon.REQUESTS_BI
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
/

prompt
prompt Creating trigger REQUESTS_BU
prompt ============================
prompt
create or replace trigger appcon.REQUESTS_BU
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
/


spool off
