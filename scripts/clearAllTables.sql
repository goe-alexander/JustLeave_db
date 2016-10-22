create or replace procedure clear_All_tb_in_db as
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