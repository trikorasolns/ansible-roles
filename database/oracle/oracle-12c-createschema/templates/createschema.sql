-- sqlplus /nolog
-- connect sys@ora12 as sysdba

create user ferromam761 identified by ferromam761;
--Desde el sqlPlus Creamos tablespace
create tablespace ferromam761data datafile '/ora01/app/oracle/oradata/ferromam761data.dbf' size 500M autoextend on;
create tablespace ferromam761idx datafile '/ora01/app/oracle/oradata/ferromam761idx.dbf' size 500M autoextend on;
create temporary tablespace ferromam761temp tempfile '/ora01/app/oracle/oradata/ferromam761temp.dbf' size 1000M autoextend on maxsize unlimited;

--Asignamos tablespace al usuario creado
alter user ferromam761 default tablespace ferromam761data temporary tablespace ferromam761temp;
alter user ferromam761 quota unlimited on ferromam761idx;
ALTER USER ferromam761 QUOTA unlimited ON ferromam761data;

--Damos permisos a los usuarios creados.
grant create trigger to ferromam761;
grant create session to ferromam761;
grant create sequence to ferromam761;
grant create synonym to ferromam761;
grant create table to ferromam761;
grant create view to ferromam761;
grant create procedure to ferromam761;
grant alter session to ferromam761;
grant execute on ctxsys.ctx_ddl to ferromam761;
grant create job to ferromam761;
grant create user to ferromam761;
grant drop user to ferromam761;
grant create session to ferromam761 with ADMIN OPTION;
grant alter user to ferromam761;

-- execute using ferromam761

call ctx_ddl.drop_preference('global_lexer');
call ctx_ddl.drop_preference('default_lexer');
call ctx_ddl.drop_preference('english_lexer');
call ctx_ddl.drop_preference('chinese_lexer');
call ctx_ddl.drop_preference('japanese_lexer');
call ctx_ddl.drop_preference('korean_lexer');
call ctx_ddl.drop_preference('german_lexer');
call ctx_ddl.drop_preference('dutch_lexer');
call ctx_ddl.drop_preference('swedish_lexer');
call ctx_ddl.drop_preference('french_lexer');
call ctx_ddl.drop_preference('italian_lexer');
call ctx_ddl.drop_preference('spanish_lexer');
call ctx_ddl.drop_preference('portu_lexer');
call ctx_ddl.create_preference('default_lexer','basic_lexer');
call ctx_ddl.create_preference('english_lexer','basic_lexer');
call ctx_ddl.create_preference('chinese_lexer','chinese_lexer');
call ctx_ddl.create_preference('japanese_lexer','japanese_lexer');
call ctx_ddl.create_preference('korean_lexer','korean_lexer');
call ctx_ddl.create_preference('german_lexer','basic_lexer');
call ctx_ddl.create_preference('dutch_lexer','basic_lexer');
call ctx_ddl.create_preference('swedish_lexer','basic_lexer');
call ctx_ddl.create_preference('french_lexer','basic_lexer');
call ctx_ddl.create_preference('italian_lexer','basic_lexer');
call ctx_ddl.create_preference('spanish_lexer','basic_lexer');
call ctx_ddl.create_preference('portu_lexer','basic_lexer');
call ctx_ddl.create_preference('global_lexer', 'multi_lexer');
call ctx_ddl.add_sub_lexer('global_lexer','default','default_lexer');
call ctx_ddl.add_sub_lexer('global_lexer','english','english_lexer','en');
call ctx_ddl.add_sub_lexer('global_lexer','simplified chinese','chinese_lexer','zh');
call ctx_ddl.add_sub_lexer('global_lexer','japanese','japanese_lexer',null);
call ctx_ddl.add_sub_lexer('global_lexer','korean','korean_lexer',null);
call ctx_ddl.add_sub_lexer('global_lexer','german','german_lexer','de');
call ctx_ddl.add_sub_lexer('global_lexer','dutch','dutch_lexer',null);
call ctx_ddl.add_sub_lexer('global_lexer','swedish','swedish_lexer','sv');
call ctx_ddl.add_sub_lexer('global_lexer','french','french_lexer','fr');
call ctx_ddl.add_sub_lexer('global_lexer','italian','italian_lexer','it');
call ctx_ddl.add_sub_lexer('global_lexer','spanish','spanish_lexer','es');
call ctx_ddl.add_sub_lexer('global_lexer','portuguese','portu_lexer',null);
