REM ########################################################################
REM ##
REM ##   fkeys.sql
REM ##
REM ##   Displays the foreign key relationships
REM ##
REM #######################################################################

CLEAR BREAK
CLEAR COL
SET LINES 200
SET PAGES 54
SET NEWPAGE 0
SET WRAP OFF
SET VERIFY OFF
SET FEEDBACK OFF

break on table_name skip 2 on constraint_name on r_table_name skip 1

column CHILDCOL format a60 head 'CHILD COLUMN'
column PARENTCOL format a60 head 'PARENT COLUMN'
column constraint_name format a30 head 'FK CONSTRAINT NAME'
column delete_rule format a15
column bt noprint
column bo noprint

TTITLE LEFT _DATE CENTER 'FOREIGN KEY RELATIONSHIPS ON &new_prompt' RIGHT 'PAGE:'FORMAT 999 SQL.PNO SKIP 2

SPOOL C:\SQLRPTS\FKeys_&new_prompt
ACCEPT OWNER_NAME PROMPT 'Enter Table Owner (or blank for all): '
ACCEPT PARENT_TABLE_NAME PROMPT 'Enter Parent Table or leave blank for all: '
ACCEPT CHILD_TABLE_NAME PROMPT 'Enter Child Table or leave blank for all: '

  select b.owner || '.' || b.table_name || '.' || b.column_name CHILDCOL,
         b.position,
         c.owner || '.' || c.table_name || '.' || c.column_name PARENTCOL,
         a.constraint_name,
         a.delete_rule,
         b.table_name bt,
         b.owner bo
    from all_cons_columns b,
         all_cons_columns c,
         all_constraints a
   where b.constraint_name = a.constraint_name
     and a.owner           = b.owner
     and b.position        = c.position
     and c.constraint_name = a.r_constraint_name
     and c.owner           = a.r_owner
     and a.constraint_type = 'R'
     and c.owner      like case when upper('&OWNER_NAME') is null then '%'
                                else upper('&OWNER_NAME') end
     and c.table_name like case when upper('&PARENT_TABLE_NAME') is null then '%'
                                else upper('&PARENT_TABLE_NAME') end
     and b.table_name like case when upper('&CHILD_TABLE_NAME') is null then '%'
                                else upper('&CHILD_TABLE_NAME') end
order by 7,6,4,2
/
SPOOL OFF
TTITLE OFF
SET FEEDBACK ON
SET VERIFY ON
CLEAR BREAK
CLEAR COL
SET PAGES 24
SET LINES 100
SET NEWPAGE 1
UNDEF OWNER