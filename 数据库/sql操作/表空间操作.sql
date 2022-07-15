--新建表空间
create tablespace ORA19C datafile '/oradata/datafile/ORACLR_19C_DF.dbf' size 10M autoextend on next 10M maxsize unlimited;

--增加表空间文件
alter tablespace ORA19C  add  datafile  '/oradata/datafile/ORACLR_19C_DF.dbf' size 10M autoextend on next 10M maxsize unlimited;

--删除表空间文件
alter tablespace ORA19C  drop  datafile  '/oradata/datafile/ORACLR_19C_DF.dbf';

--删除表空间和表空间文件
drop tablespace ORA19C INCLUDING CONTENTS AND DATAFILES;

--删除用户
drop user wangjian cascade;

--创建用户
create user wangjian identified by wangjian default tablespace ORA19C ACCOUNT UNLOCK;

--用户赋权
grant connect to wangjian;
grant resource to wangjian;
grant sysdba to wangjian;
grant exp_full_database to wangjian;
grant imp_full_database to wangjian;
grant create user to wangjian;
grant create view to wangjian;
grant create any index to wangjian;
grant create any table to wangjian;
grant create session,
create table,select any table,update any table,insert any table,delete any table to wangjian;
commit;

alter user wangjian default tablespace ORA19C;
commit;

alter user wangjian quota unlimited on ORA19C;
commit;









