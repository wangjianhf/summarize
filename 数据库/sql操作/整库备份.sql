sqlplus / as sysdba

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



--交易银行综合金融服务平台数据库

--导数据
 --1.在数据库服务器建立真实目录
 --[oracle@localhost oracle]$ mkdir dmp
 
 --2.用管理员账号登录数据库
 --[oracle@localhost dmp]$ sqlplus / as sysdba

 --3.创建逻辑目录
 drop directory dmp_dir;
 
 commit;
 
 
 create directory dmp_dir as '/home/oracle/dmp';
 
 create directory dmp_dir as '/oradata/dmp';
 
 commit;
 
 
 --4.给要导出的用户的赋予该目录的操作权限
 grant read,write on directory dmp_dir to TBSP20;
 
 grant read,write on directory dmp_dir to TBSPREPORT;
 
 grant read,write on directory dmp_dir to TBSPHIS;
 
 commit; 
 

 
 --4.5 tuichu SQL 界面
  exit;
 
 --5.导出数据，按用户导出
 expdp 用户名/密码@实例名 schemas=用户名 dumpfile=xxx.dmp logfile=xxx.log directory=dmp_dir job_name=xxx_job;
 



--6.导入数据，按用户导入


impdp 新库用户名/新库密码@新库实例名 remap_schema=旧库用户名:新库用户名 remap_tablespace=旧库表空间名:新库表空间名 dumpfile=xxx.dmp logfile=xxx.log directory=dmp_dir exclude=grant table_exists_action=replace;

impdp TBSPHIS/TBSPHIS@cfsp remap_schema=tbsphis:TBSPHIS dumpfile=tbsphis.dmp logfile=tbsphis.log directory=dmp_dir remap_tablespace=TBSPDB:TBSPHISDB exclude=grant table_exists_action=replace;

impdp TBSPREPORT/TBSPREPORT@cfsp remap_schema=tbspreport:TBSPREPORT dumpfile=tbspreport.dmp logfile=tbspreport.log directory=dmp_dir remap_tablespace=TBSPDB:TBSPREPORTDB exclude=grant table_exists_action=replace;







--查看表空间
select tablespace_name from user_tablespaces;

--查看表空间下的用户
select distinct owner from dba_segments where tablespace_name = 'ORA_19C';

--查看用户所属表空间
select default_tablespace from dba_users where username = 'TBSP20';
select default_tablespace from dba_users where username = 'TBSPHIS';
select default_tablespace from dba_users where username = 'TBSPREPORT';

--建立表空间
create tablespace TBSPDB logging datafile '/oradata/CFSP/datafile/TBSPDB.dbf' size 10240m autoextend on next 10240m maxsize unlimited extent management local;
alter tablespace TBSPDB  add  datafile '/oradata/CFSP/datafile/TBSPDB.dbf' size 10240m autoextend on next 10240m maxsize unlimited;

--查看实例名
select instance_name from v$instance;


--查看用户
select username from all_users;
select username from user_users;
select username from dba_users;

select * from all_users  where username = 'TBSP20';
select * from all_users  where username = 'TBSPHIS';
select * from all_users  where username = 'TBSPREPORT';



--新建用户
create user TBSP20 identified by TBSP20 default tablespace USERS;
grant connect,resource,sysdba to TBSP20;
grant create view to TBSP20;

create user TBSPHIS identified by TBSPHIS default tablespace TBSPDB;
grant connect,resource,sysdba to TBSPHIS;
grant create view to TBSPHIS;

create user TBSPREPORT identified by TBSPREPORT default tablespace TBSPDB;
grant connect,resource,sysdba to TBSPREPORT;
grant create view to TBSPREPORT;


--修改密码
alter user TBSP20 identified by TBSP20;
alter user TBSPHIS identified by TBSPHIS;
alter user TBSPREPORT identified by TBSPREPORT;
commit;

alter user tbsp20 identified by Jyyh_2015;
alter user tbsphis identified by Jyyh_2015;
alter user tbspreport identified by Jyyh_2015;
commit;

alter user tbsp20 identified by tbsp20;
alter user tbsphis identified by tbsphis;
alter user tbspreport identified by tbspreport;
commit;


--解锁用户
alter user TBSP20 account unlock;
alter user TBSPHIS account unlock;
alter user TBSPREPORT account unlock;
alter user esbdata account unlock;
commit;


