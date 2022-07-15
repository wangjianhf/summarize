--查看当前环境的所在的容器
select sys_context ('USERENV', 'CON_NAME') from dual; 

--查看容器名称
select con_id,dbid,NAME,OPEN_MODE from v$pdbs;

--可以发现ORCLPDB 的OPEN_MODEL 从MOUNTED （已挂载）变成 READ WRITE（可以读写）了
select con_id,dbid,NAME,OPEN_MODE from v$pdbs;