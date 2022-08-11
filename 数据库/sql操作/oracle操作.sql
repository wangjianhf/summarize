sqlplus / as sysdba

--当前的数据库连接数
select count(*) from v$process;

select count(*) from v$session;

select value from v$parameter where name = 'processes';

alter system set processes = 4000 scope = spfile;

show parameter processes;
 
shutdown abort;
shutdown immediate;

startup;

---linux杀死所有oracle进程
ipcs -m|grep oracle | awk '{print$2}'|xargs ipcrm shm

ps -ef|grep $ORACLE_SID|grep -v grep|awk '{print$2}'|xargs kill -9

--导数据
 --1.在数据库服务器建立真实目录
[oracle@localhost oracle]$ mkdir dmp
 
--2.用管理员账号登录数据库
[oracle@localhost dmp]$ sqlplus / as sysdba

--3.创建逻辑目录
drop directory dmp_dir; 

create directory dmp_dir as '/home/oracle/oradata/dmp';

--4.给要导出的用户的赋予该目录的操作权限
grant read,write on directory dmp_dir to wangjian; 

--4.5 tuichu SQL 界面
exit;

--5.导出数据，按用户导出
[oracle@localhost ~]$ expdp 用户名/密码@实例名 schemas=用户名 dumpfile=xxx.dmp logfile=xxx.log directory=dmp_dir job_name=xxx_job;
 
--6.导入数据，按用户导入
[oracle@localhost ~]$ impdp 新库用户名/新库密码@新库实例名 remap_schema=旧库用户名:新库用户名 remap_tablespace=旧库表空间名:新库表空间名 dumpfile=xxx.dmp logfile=xxx.log directory=dmp_dir exclude=grant table_exists_action=replace;

--查看表空间
select tablespace_name from user_tablespaces;

--查看表空间下的用户
select distinct owner from dba_segments where tablespace_name = 'ORA_19C';

--查看用户所属表空间

select default_tablespace from dba_users where username = 'TBSPREPORT';

--建立表空间
create tablespace orcl logging datafile '/oradata/datafile/orcl.dbf' size 10240m autoextend on next 10240m maxsize unlimited extent management local;
--查看实例名
select instance_name from v$instance;

--查看用户
select username from all_users;
select username from user_users;
select username from dba_users;

select * from all_users  where username = 'wangjian';

--新建用户
create user wangjian identified by wangjian default tablespace USERS;
grant connect,resource,sysdba to wangjian;
grant create view to wangjian;

--修改密码
alter user wangjian identified by 新密码;

--解锁用户
alter user wangjian account unlock;

--新建表空间
create tablespace orcl datafile '/oradata/datafile/ORCL_DF.dbf' size 10M autoextend on next 10M maxsize unlimited;

--增加表空间文件
alter tablespace orcl  add  datafile  '/oradata/datafile/ORCL_DF.dbf' size 10M autoextend on next 10M maxsize unlimited;

--删除表空间文件
alter tablespace orcl  drop  datafile  '/oradata/datafile/ORCL_DF.dbf';

--删除表空间和表空间文件
drop tablespace orcl INCLUDING CONTENTS AND DATAFILES;

--删除用户
drop user wangjian cascade;

--创建用户
create user wangjian identified by wangjian default tablespace orcl ACCOUNT UNLOCK;

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

alter user wangjian default tablespace orcl;
alter user wangjian quota unlimited on orcl;