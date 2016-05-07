# Sequences
create sequence req_id_seq
        start with 1
        increment by 1
        NOCYCLE
        NOCACHE;

create sequence stat_type_seq
  start with 1
  increment by 1
  NOCACHE
  NOCYCLE;

create sequence req_type_generator
  start with 1 
  increment by 1
  NOcache
  nocycle; 

create sequence role_types_seq
          start with 1
          increment by 1
          NOCYCLE
          NOCACHE;

create sequence app_users_seq
          start with 1
          increment by 1
          NOCYCLE
          NOCACHE;

create sequence emp_id_seq
          start with 1
          increment by 1
          NOCYCLE
          NOCACHE;