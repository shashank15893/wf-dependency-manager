mysql> select * from supply_chain_dashboard.dependency_data;
+----+----------+---------------+------------+--------+-------------+----------+--------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+-------------------+
| id | ORG_NAME | DOMAIN_NM     | PRODUCT_NM | APP_ID | INSTANCE_ID | PRIORITY | SLA    | APP_STATUS | APP_RUN_ID | TASK_ID | TASK_STATUS | APP_EXECUTION_TS    | TASK_EXECUTION_TS   | PARENT_APP_ID | PARENT_INSTANCE_ID | PARENT_TASK_ID | CREATED_AT          | UPDATED_AT          | PARENT_PRODUCT_NM |
+----+----------+---------------+------------+--------+-------------+----------+--------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+-------------------+
|  1 | DCA      | Supply Chain  | Ecomm      | dag-1  | abc-101     | P1       | Daily  | running    |          1 | ts-1    | running     | 2025-03-21 08:00:00 | 2025-03-21 08:00:00 | NULL          | NULL               | NULL           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 | NULL              |
|  2 | DCA      | Supply Chain  | Ecomm      | dag-1  | abc-101     | P1       | Daily  | running    |          2 | ts-2    | completed   | 2025-03-21 08:00:00 | 2025-03-21 09:00:00 | NULL          | NULL               | NULL           | 2025-03-22 19:13:50 | 2025-03-23 22:39:01 | NULL              |
|  3 | DCA      | Supply Chain  | ODS        | dag-2  | def-101     | P1       | Daily  | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-24 01:43:17 | Ecomm             |
|  4 | DCA      | Supply Chain  | Ecomm      | dag-3  | abc-101     | P1       | Daily  | completed  |          4 | ts-4    | completed   | 2025-03-21 11:00:00 | 2025-03-21 11:00:00 | NULL          | NULL               | NULL           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 | NULL              |
|  5 | DCA      | Supply Chain  | ODS        | dag-4  | def-101     | P1       | Daily  | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-24 01:43:17 | Ecomm             |
|  6 | DCA      | Supply Chain  | ODS        | dag-5  | def-101     | P1       | Daily  | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-24 01:43:17 | Ecomm             |
|  7 | DCA      | Supply Chain  | Ecomm      | dag-6  | abc-101     | P1       | Daily  | failed     |          7 | ts-7    | failed      | 2025-03-21 14:00:00 | 2025-03-21 14:00:00 | NULL          | NULL               | NULL           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 | NULL              |
|  8 | DCA      | Supply Chain  | ODS        | dag-7  | def-101     | P1       | Daily  | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-24 01:43:17 | Ecomm             |
|  9 | SCM      | Manufacturing | MES        | dag-10 | xyz-101     | P1       | Daily  | running    |          9 | ts-10   | running     | 2025-03-21 08:00:00 | 2025-03-21 08:00:00 | NULL          | NULL               | NULL           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 | NULL              |
| 10 | SCM      | Manufacturing | MES        | dag-10 | xyz-101     | P1       | Daily  | running    |         10 | ts-11   | completed   | 2025-03-21 09:00:00 | 2025-03-21 09:00:00 | NULL          | NULL               | NULL           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 | NULL              |
| 11 | SCM      | Manufacturing | PLM        | dag-11 | xyz-102     | P2       | Daily  | completed  |         11 | ts-12   | completed   | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-10        | xyz-101            | ts-10          | 2025-03-22 19:13:50 | 2025-03-24 01:43:17 | Ecomm             |
| 12 | SCM      | Production    | QMS        | dag-12 | xyz-103     | P1       | Daily  | failed     |         12 | ts-13   | failed      | 2025-03-21 11:00:00 | 2025-03-21 11:00:00 | NULL          | NULL               | NULL           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 | NULL              |
| 13 | SCM      | Production    | QMS        | dag-12 | xyz-103     | P1       | Daily  | queued     |         13 | ts-14   | queued      | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | NULL          | NULL               | NULL           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 | NULL              |
| 14 | FIN      | Accounting    | GL         | dag-20 | fin-101     | P1       | Daily  | completed  |         14 | ts-20   | completed   | 2025-03-21 08:00:00 | 2025-03-21 08:00:00 | NULL          | NULL               | NULL           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 | NULL              |
| 15 | FIN      | Accounting    | GL         | dag-20 | fin-101     | P1       | Daily  | completed  |         15 | ts-21   | completed   | 2025-03-21 09:00:00 | 2025-03-21 09:00:00 | NULL          | NULL               | NULL           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 | NULL              |
| 16 | FIN      | Accounting    | AP         | dag-21 | fin-102     | P2       | Daily  | running    |         16 | ts-22   | running     | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-20        | fin-101            | ts-20          | 2025-03-22 19:13:50 | 2025-03-24 01:43:17 | Ecomm             |
| 17 | FIN      | Reporting     | BI         | dag-22 | fin-103     | P1       | Daily  | queued     |         17 | ts-23   | queued      | 2025-03-21 11:00:00 | 2025-03-21 11:00:00 | dag-20        | fin-101            | ts-20          | 2025-03-22 19:13:50 | 2025-03-24 01:43:17 | Ecomm             |
| 18 | FIN      | Reporting     | BI         | dag-23 | fin-104     | P1       | Weekly | failed     |         18 | ts-24   | failed      | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | NULL          | NULL               | NULL           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 | NULL              |
| 19 | DCA      | Supply Chain  | Returns    | dag-10 | qwe-101     | P1       | Daily  | running    |          1 | ts-1    | running     | 2025-03-21 08:00:00 | 2025-03-21 08:00:00 | dag-2         | def-101            | ts-3           | 2025-03-24 01:49:00 | 2025-03-24 01:49:00 | ODS               |
| 21 | DCA      | Supply Chain  | FIN        | dag-11 | pqr-101     | P1       | Daily  | running    |          1 | ts-1    | running     | 2025-03-21 08:00:00 | 2025-03-21 08:00:00 | dag-10        | qwe-101            | ts-1           | 2025-03-26 02:45:11 | 2025-03-26 02:45:11 | Returns           |
| 22 | DCA      | Supply Chain  | Returns    | dag-13 | qwe-101     | P1       | Daily  | running    |          1 | ts-1    | running     | 2025-03-21 08:00:00 | 2025-03-21 08:00:00 | dag-2         | def-101            | ts-3           | 2025-03-26 03:10:16 | 2025-03-26 03:10:16 | ODS               |
| 23 | DCA      | Supply Chain  | FIN        | dag-12 | pqr-101     | P1       | Daily  | running    |          1 | ts-1    | running     | 2025-03-21 08:00:00 | 2025-03-21 08:00:00 | dag-10        | qwe-101            | ts-1           | 2025-03-26 03:10:16 | 2025-03-26 03:10:16 | Returns           |
| 24 | DCA      | Supply Chain  | Ecomm      | dag-20 | abc-101     | P1       | Daily  | running    |          1 | ts-1    | running     | 2025-03-21 08:00:00 | 2025-03-21 08:00:00 | NULL          | NULL               | NULL           | 2025-03-26 03:31:35 | 2025-03-26 03:31:35 | NULL              |
| 25 | DCA      | Supply Chain  | Returns    | dag-15 | qwe-101     | P1       | Daily  | running    |          1 | ts-1    | running     | 2025-03-21 08:00:00 | 2025-03-21 08:00:00 | dag-20        | abc-101            | ts-1           | 2025-03-26 04:05:53 | 2025-03-26 04:05:53 | Ecomm             |
+----+----------+---------------+------------+--------+-------------+----------+--------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+-------------------+

/* Assumption is you have the above data stored in mysql and you want to build the dependency graph.*/
    
DROP TABLE supply_chain_dashboard.dependency;

CREATE TABLE supply_chain_dashboard.dependency (
    NODE_ID bigint NOT NULL AUTO_INCREMENT,
    PARENT_ID bigint,
    NODE_NM varchar(255),
    STATUS varchar(255),
    SLA varchar(255),
    EXECUTION_DT varchar(255),
    NODE_DESCRIPTION varchar(255),
    PRIMARY KEY (NODE_ID)
);

insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA,EXECUTION_DT,NODE_DESCRIPTION)
select null PARENT_ID,ORG_NAME NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Organisation' NODE_DESCRIPTION
from (select distinct ORG_NAME 
from supply_chain_dashboard.dependency_data
where ORG_NAME ='DCA' 
and DOMAIN_NM ='Supply Chain' 
and PRODUCT_NM='Ecomm')x;

insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA,EXECUTION_DT,NODE_DESCRIPTION)
select distinct PARENT_ID,DOMAIN_NM NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Domain' NODE_DESCRIPTION
from (select a.DOMAIN_NM,b.NODE_ID as PARENT_ID 
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on a.ORG_NAME COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
where ORG_NAME ='DCA' 
and DOMAIN_NM ='Supply Chain' 
and PRODUCT_NM='Ecomm')x;

insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA,EXECUTION_DT,NODE_DESCRIPTION)
select distinct PARENT_ID,PRODUCT_NM NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Product' NODE_DESCRIPTION
from (select a.PRODUCT_NM,b.NODE_ID as PARENT_ID 
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on a.DOMAIN_NM COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
where ORG_NAME ='DCA' 
and DOMAIN_NM ='Supply Chain' 
and PRODUCT_NM='Ecomm')x;

insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA,EXECUTION_DT,NODE_DESCRIPTION)
select distinct PARENT_ID,INSTANCE_ID NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Instance' NODE_DESCRIPTION
from (select a.INSTANCE_ID,b.NODE_ID as PARENT_ID 
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on a.PRODUCT_NM COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
where ORG_NAME ='DCA' 
and DOMAIN_NM ='Supply Chain' 
and PRODUCT_NM='Ecomm')x;

insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA, EXECUTION_DT,NODE_DESCRIPTION)
select distinct PARENT_ID,APP_ID NODE_NM,APP_STATUS STATUS,SLA SLA,APP_EXECUTION_TS EXECUTION_DT,'Application' NODE_DESCRIPTION
from (select a.APP_ID,b.NODE_ID as PARENT_ID,a.APP_STATUS,a.SLA,a.APP_EXECUTION_TS 
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on a.INSTANCE_ID COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
where ORG_NAME ='DCA' 
and DOMAIN_NM ='Supply Chain' 
and PRODUCT_NM='Ecomm')x;

insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA, EXECUTION_DT,NODE_DESCRIPTION)
select distinct PARENT_ID,TASK_ID NODE_NM,TASK_STATUS STATUS,SLA SLA,TASK_EXECUTION_TS EXECUTION_DT,'Task' NODE_DESCRIPTION
from (select a.TASK_ID,b.NODE_ID as PARENT_ID,a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS 
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on a.APP_ID COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
where ORG_NAME ='DCA' 
and DOMAIN_NM ='Supply Chain' 
and PRODUCT_NM='Ecomm')x;


insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA,EXECUTION_DT,NODE_DESCRIPTION)
select distinct PARENT_ID,PRODUCT_NM NODE_NM,TASK_STATUS STATUS,SLA SLA,TASK_EXECUTION_TS EXECUTION_DT,'Downstream' NODE_DESCRIPTION
from (select CONCAT(PRODUCT_NM, '->', INSTANCE_ID, '->', APP_ID, '->', TASK_ID) PRODUCT_NM,b.NODE_ID as PARENT_ID,
a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS  
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on PARENT_TASK_ID COLLATE utf8mb4_0900_ai_ci =b.NODE_NM )x;

insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA,EXECUTION_DT,NODE_DESCRIPTION)
select distinct PARENT_ID,PRODUCT_NM NODE_NM,TASK_STATUS STATUS,SLA SLA,TASK_EXECUTION_TS EXECUTION_DT,'Downstream' NODE_DESCRIPTION
from (select CONCAT(PRODUCT_NM, '->', INSTANCE_ID, '->', APP_ID, '->', TASK_ID) PRODUCT_NM,b.NODE_ID as PARENT_ID,
a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS  
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on CONCAT(PARENT_PRODUCT_NM, '->', PARENT_INSTANCE_ID, '->', PARENT_APP_ID, '->', PARENT_TASK_ID) COLLATE utf8mb4_0900_ai_ci =b.NODE_NM )x;

insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA,EXECUTION_DT,NODE_DESCRIPTION)
select distinct x.PARENT_ID,x.PRODUCT_NM NODE_NM,x.TASK_STATUS STATUS,x.SLA SLA,x.TASK_EXECUTION_TS EXECUTION_DT,'Downstream' NODE_DESCRIPTION
from (select CONCAT(PRODUCT_NM, '->', INSTANCE_ID, '->', APP_ID, '->', TASK_ID) PRODUCT_NM,b.NODE_ID as PARENT_ID,
a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS  
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on CONCAT(PARENT_PRODUCT_NM, '->', PARENT_INSTANCE_ID, '->', PARENT_APP_ID, '->', PARENT_TASK_ID) COLLATE utf8mb4_0900_ai_ci =b.NODE_NM )x
right join supply_chain_dashboard.dependency tgt 
on x.PARENT_ID=tgt.PARENT_ID
and x.PRODUCT_NM COLLATE utf8mb4_0900_ai_ci =tgt.NODE_NM
where tgt.NODE_ID is null;

insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA,EXECUTION_DT,NODE_DESCRIPTION)
select stg.* from
(select distinct b.NODE_ID PARENT_ID,a.PRODUCT_NM NODE_NM,a.TASK_STATUS STATUS,a.SLA SLA,a.TASK_EXECUTION_TS EXECUTION_DT,'Downstream' NODE_DESCRIPTION
from 
(
select CONCAT(a.PRODUCT_NM, '->', a.INSTANCE_ID, '->', a.APP_ID, '->', a.TASK_ID) PRODUCT_NM,
CONCAT(a.PARENT_PRODUCT_NM, '->', a.PARENT_INSTANCE_ID, '->', a.PARENT_APP_ID, '->', a.PARENT_TASK_ID) PARENT_PRODUCT_NM,
a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS  
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency_data b 
on CONCAT(a.PARENT_PRODUCT_NM, '->', a.PARENT_INSTANCE_ID, '->', a.PARENT_APP_ID, '->', a.PARENT_TASK_ID)=CONCAT(b.PRODUCT_NM, '->', b.INSTANCE_ID, '->', b.APP_ID, '->', b.TASK_ID) 
)a
left join supply_chain_dashboard.dependency b 
on a.PARENT_PRODUCT_NM COLLATE utf8mb4_0900_ai_ci=b.NODE_NM
where b.NODE_ID is not null
)stg
left join supply_chain_dashboard.dependency tgt 
on stg.PARENT_ID=tgt.PARENT_ID
and stg.NODE_NM COLLATE utf8mb4_0900_ai_ci =tgt.NODE_NM
where tgt.NODE_ID is null;


    SELECT COUNT(*) from (select CONCAT(PRODUCT_NM, '->', INSTANCE_ID, '->', APP_ID, '->', TASK_ID) PRODUCT_NM,b.NODE_ID as PARENT_ID,
    a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS  
    from supply_chain_dashboard.dependency_data a
    inner join supply_chain_dashboard.dependency b 
    on CONCAT(PARENT_PRODUCT_NM, '->', PARENT_INSTANCE_ID, '->', PARENT_APP_ID, '->', PARENT_TASK_ID) COLLATE utf8mb4_0900_ai_ci =b.NODE_NM )x
    right join supply_chain_dashboard.dependency tgt 
    on x.PARENT_ID=tgt.PARENT_ID
    and x.PRODUCT_NM COLLATE utf8mb4_0900_ai_ci =tgt.NODE_NM
    where tgt.NODE_ID is null;

DELIMITER //
CREATE OR REPLACE PROCEDURE InsertDomainWfs()
BEGIN
    DECLARE c INT;

    -- Get the count from your SQL statement
    SELECT COUNT(*) INTO c from
    (select null PARENT_ID,ORG_NAME NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Organisation' NODE_DESCRIPTION
    from (select distinct ORG_NAME 
    from supply_chain_dashboard.dependency_data
    where ORG_NAME ='DCA' 
    and DOMAIN_NM ='Supply Chain' 
    and PRODUCT_NM='Ecomm')x
    
    union all
    select distinct PARENT_ID,DOMAIN_NM NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Domain' NODE_DESCRIPTION
    from (select a.DOMAIN_NM,b.NODE_ID as PARENT_ID 
    from supply_chain_dashboard.dependency_data a
    inner join supply_chain_dashboard.dependency b 
    on a.ORG_NAME COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
    where ORG_NAME ='DCA' 
    and DOMAIN_NM ='Supply Chain' 
    and PRODUCT_NM='Ecomm')x
    
    union all
    select distinct PARENT_ID,PRODUCT_NM NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Product' NODE_DESCRIPTION
    from (select a.PRODUCT_NM,b.NODE_ID as PARENT_ID 
    from supply_chain_dashboard.dependency_data a
    inner join supply_chain_dashboard.dependency b 
    on a.DOMAIN_NM COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
    where ORG_NAME ='DCA' 
    and DOMAIN_NM ='Supply Chain' 
    and PRODUCT_NM='Ecomm')x
    
    union all
    select distinct PARENT_ID,INSTANCE_ID NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Instance' NODE_DESCRIPTION
    from (select a.INSTANCE_ID,b.NODE_ID as PARENT_ID 
    from supply_chain_dashboard.dependency_data a
    inner join supply_chain_dashboard.dependency b 
    on a.PRODUCT_NM COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
    where ORG_NAME ='DCA' 
    and DOMAIN_NM ='Supply Chain' 
    and PRODUCT_NM='Ecomm')x
    
    union all
    select distinct PARENT_ID,APP_ID NODE_NM,APP_STATUS STATUS,SLA SLA,APP_EXECUTION_TS EXECUTION_DT,'Application' NODE_DESCRIPTION
    from (select a.APP_ID,b.NODE_ID as PARENT_ID,a.APP_STATUS,a.SLA,a.APP_EXECUTION_TS 
    from supply_chain_dashboard.dependency_data a
    inner join supply_chain_dashboard.dependency b 
    on a.INSTANCE_ID COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
    where ORG_NAME ='DCA' 
    and DOMAIN_NM ='Supply Chain' 
    and PRODUCT_NM='Ecomm')x
    
    union all
    select distinct PARENT_ID,TASK_ID NODE_NM,TASK_STATUS STATUS,SLA SLA,TASK_EXECUTION_TS EXECUTION_DT,'Task' NODE_DESCRIPTION
    from (select a.TASK_ID,b.NODE_ID as PARENT_ID,a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS 
    from supply_chain_dashboard.dependency_data a
    inner join supply_chain_dashboard.dependency b 
    on a.APP_ID COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
    where ORG_NAME ='DCA' 
    and DOMAIN_NM ='Supply Chain' 
    and PRODUCT_NM='Ecomm')x)stg
    left join supply_chain_dashboard.dependency tgt 
    on stg.PARENT_ID=tgt.PARENT_ID
    and stg.NODE_NM COLLATE utf8mb4_0900_ai_ci =tgt.NODE_NM
    where tgt.NODE_ID is null
    and stg.PARENT_ID is not null;

    

    -- Iteratively insert new rows based on the count
    WHILE c <> 0 DO
        insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA,EXECUTION_DT,NODE_DESCRIPTION)
        select stg.* from
        (select null PARENT_ID,ORG_NAME NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Organisation' NODE_DESCRIPTION
        from (select distinct ORG_NAME 
        from supply_chain_dashboard.dependency_data
        where ORG_NAME ='DCA' 
        and DOMAIN_NM ='Supply Chain' 
        and PRODUCT_NM='Ecomm')x
        
        union all
        select distinct PARENT_ID,DOMAIN_NM NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Domain' NODE_DESCRIPTION
        from (select a.DOMAIN_NM,b.NODE_ID as PARENT_ID 
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency b 
        on a.ORG_NAME COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
        where ORG_NAME ='DCA' 
        and DOMAIN_NM ='Supply Chain' 
        and PRODUCT_NM='Ecomm')x
        
        union all
        select distinct PARENT_ID,PRODUCT_NM NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Product' NODE_DESCRIPTION
        from (select a.PRODUCT_NM,b.NODE_ID as PARENT_ID 
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency b 
        on a.DOMAIN_NM COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
        where ORG_NAME ='DCA' 
        and DOMAIN_NM ='Supply Chain' 
        and PRODUCT_NM='Ecomm')x
        
        union all
        select distinct PARENT_ID,INSTANCE_ID NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Instance' NODE_DESCRIPTION
        from (select a.INSTANCE_ID,b.NODE_ID as PARENT_ID 
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency b 
        on a.PRODUCT_NM COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
        where ORG_NAME ='DCA' 
        and DOMAIN_NM ='Supply Chain' 
        and PRODUCT_NM='Ecomm')x
        
        union all
        select distinct PARENT_ID,APP_ID NODE_NM,APP_STATUS STATUS,SLA SLA,APP_EXECUTION_TS EXECUTION_DT,'Application' NODE_DESCRIPTION
        from (select a.APP_ID,b.NODE_ID as PARENT_ID,a.APP_STATUS,a.SLA,a.APP_EXECUTION_TS 
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency b 
        on a.INSTANCE_ID COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
        where ORG_NAME ='DCA' 
        and DOMAIN_NM ='Supply Chain' 
        and PRODUCT_NM='Ecomm')x
        
        union all
        select distinct PARENT_ID,TASK_ID NODE_NM,TASK_STATUS STATUS,SLA SLA,TASK_EXECUTION_TS EXECUTION_DT,'Task' NODE_DESCRIPTION
        from (select a.TASK_ID,b.NODE_ID as PARENT_ID,a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS 
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency b 
        on a.APP_ID COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
        where ORG_NAME ='DCA' 
        and DOMAIN_NM ='Supply Chain' 
        and PRODUCT_NM='Ecomm')x)stg
        left join supply_chain_dashboard.dependency tgt 
        on stg.PARENT_ID=tgt.PARENT_ID
        and stg.NODE_NM COLLATE utf8mb4_0900_ai_ci =tgt.NODE_NM
        where tgt.NODE_ID is null
        and stg.PARENT_ID is not null;

        insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA, EXECUTION_DT,NODE_DESCRIPTION)
        select stg.* from 
        (select distinct PARENT_ID,TASK_ID NODE_NM,TASK_STATUS STATUS,SLA SLA,TASK_EXECUTION_TS EXECUTION_DT,'Task' NODE_DESCRIPTION
        from (select a.TASK_ID,b.NODE_ID as PARENT_ID,a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS 
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency b 
        on a.APP_ID COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
        where ORG_NAME ='DCA' 
        and DOMAIN_NM ='Supply Chain' 
        and PRODUCT_NM='Ecomm')x)stg
        left join supply_chain_dashboard.dependency tgt 
        on stg.PARENT_ID=tgt.PARENT_ID
        and stg.NODE_NM COLLATE utf8mb4_0900_ai_ci =tgt.NODE_NM
        where tgt.NODE_ID is null
        and stg.PARENT_ID is not null;

        insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA,EXECUTION_DT,NODE_DESCRIPTION)
        select stg.* from 
        (select distinct PARENT_ID,PRODUCT_NM NODE_NM,TASK_STATUS STATUS,SLA SLA,TASK_EXECUTION_TS EXECUTION_DT,'Downstream' NODE_DESCRIPTION
        from (select CONCAT(PRODUCT_NM, '->', INSTANCE_ID, '->', APP_ID, '->', TASK_ID) PRODUCT_NM,b.NODE_ID as PARENT_ID,
        a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS  
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency b 
        on PARENT_TASK_ID COLLATE utf8mb4_0900_ai_ci =b.NODE_NM 
        where ORG_NAME ='DCA' 
        and PARENT_PRODUCT_NM='Ecomm'
        and )x)stg
        left join supply_chain_dashboard.dependency tgt 
        on stg.PARENT_ID=tgt.PARENT_ID
        and stg.NODE_NM COLLATE utf8mb4_0900_ai_ci =tgt.NODE_NM
        where tgt.NODE_ID is null
        and stg.PARENT_ID is not null;

        SELECT COUNT(*) INTO c from
        (select null PARENT_ID,ORG_NAME NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Organisation' NODE_DESCRIPTION
        from (select distinct ORG_NAME 
        from supply_chain_dashboard.dependency_data
        where ORG_NAME ='DCA' 
        and DOMAIN_NM ='Supply Chain' 
        and PRODUCT_NM='Ecomm')x
        
        union all
        select distinct PARENT_ID,DOMAIN_NM NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Domain' NODE_DESCRIPTION
        from (select a.DOMAIN_NM,b.NODE_ID as PARENT_ID 
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency b 
        on a.ORG_NAME COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
        where ORG_NAME ='DCA' 
        and DOMAIN_NM ='Supply Chain' 
        and PRODUCT_NM='Ecomm')x
        
        union all
        select distinct PARENT_ID,PRODUCT_NM NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Product' NODE_DESCRIPTION
        from (select a.PRODUCT_NM,b.NODE_ID as PARENT_ID 
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency b 
        on a.DOMAIN_NM COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
        where ORG_NAME ='DCA' 
        and DOMAIN_NM ='Supply Chain' 
        and PRODUCT_NM='Ecomm')x
        
        union all
        select distinct PARENT_ID,INSTANCE_ID NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Instance' NODE_DESCRIPTION
        from (select a.INSTANCE_ID,b.NODE_ID as PARENT_ID 
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency b 
        on a.PRODUCT_NM COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
        where ORG_NAME ='DCA' 
        and DOMAIN_NM ='Supply Chain' 
        and PRODUCT_NM='Ecomm')x
        
        union all
        select distinct PARENT_ID,APP_ID NODE_NM,APP_STATUS STATUS,SLA SLA,APP_EXECUTION_TS EXECUTION_DT,'Application' NODE_DESCRIPTION
        from (select a.APP_ID,b.NODE_ID as PARENT_ID,a.APP_STATUS,a.SLA,a.APP_EXECUTION_TS 
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency b 
        on a.INSTANCE_ID COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
        where ORG_NAME ='DCA' 
        and DOMAIN_NM ='Supply Chain' 
        and PRODUCT_NM='Ecomm')x
        
        union all
        select distinct PARENT_ID,TASK_ID NODE_NM,TASK_STATUS STATUS,SLA SLA,TASK_EXECUTION_TS EXECUTION_DT,'Task' NODE_DESCRIPTION
        from (select a.TASK_ID,b.NODE_ID as PARENT_ID,a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS 
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency b 
        on a.APP_ID COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
        where ORG_NAME ='DCA' 
        and DOMAIN_NM ='Supply Chain' 
        and PRODUCT_NM='Ecomm')x)stg
        left join supply_chain_dashboard.dependency tgt 
        on stg.PARENT_ID=tgt.PARENT_ID
        and stg.NODE_NM COLLATE utf8mb4_0900_ai_ci =tgt.NODE_NM
        where tgt.NODE_ID is null
        and stg.PARENT_ID is not null;
    
    END WHILE;
END //

DELIMITER ;

CALL InsertDomainWfs();


DELIMITER //
CREATE OR REPLACE PROCEDURE InsertRowsBasedOnCount()
BEGIN
    DECLARE count INT;
    DECLARE i INT DEFAULT 0;

    -- Get the count from your SQL statement
    SELECT COUNT(*) INTO count from
    (select distinct b.NODE_ID PARENT_ID,a.PRODUCT_NM NODE_NM,a.TASK_STATUS STATUS,a.SLA SLA,a.TASK_EXECUTION_TS EXECUTION_DT,'Downstream' NODE_DESCRIPTION
    from 
    (
    select CONCAT(a.PRODUCT_NM, '->', a.INSTANCE_ID, '->', a.APP_ID, '->', a.TASK_ID) PRODUCT_NM,
    CONCAT(a.PARENT_PRODUCT_NM, '->', a.PARENT_INSTANCE_ID, '->', a.PARENT_APP_ID, '->', a.PARENT_TASK_ID) PARENT_PRODUCT_NM,
    a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS  
    from supply_chain_dashboard.dependency_data a
    inner join supply_chain_dashboard.dependency_data b 
    on CONCAT(a.PARENT_PRODUCT_NM, '->', a.PARENT_INSTANCE_ID, '->', a.PARENT_APP_ID, '->', a.PARENT_TASK_ID)=CONCAT(b.PRODUCT_NM, '->', b.INSTANCE_ID, '->', b.APP_ID, '->', b.TASK_ID) 
    )a
    left join supply_chain_dashboard.dependency b 
    on a.PARENT_PRODUCT_NM COLLATE utf8mb4_0900_ai_ci=b.NODE_NM
    where b.NODE_ID is not null
    )stg
    left join supply_chain_dashboard.dependency tgt 
    on stg.PARENT_ID=tgt.PARENT_ID
    and stg.NODE_NM COLLATE utf8mb4_0900_ai_ci =tgt.NODE_NM
    where tgt.NODE_ID is null;

    -- Iteratively insert new rows based on the count
    WHILE count <> 0 DO
        insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA,EXECUTION_DT,NODE_DESCRIPTION)
        select stg.* from
        (select distinct b.NODE_ID PARENT_ID,a.PRODUCT_NM NODE_NM,a.TASK_STATUS STATUS,a.SLA SLA,a.TASK_EXECUTION_TS EXECUTION_DT,'Downstream' NODE_DESCRIPTION
        from 
        (
        select CONCAT(a.PRODUCT_NM, '->', a.INSTANCE_ID, '->', a.APP_ID, '->', a.TASK_ID) PRODUCT_NM,
        CONCAT(a.PARENT_PRODUCT_NM, '->', a.PARENT_INSTANCE_ID, '->', a.PARENT_APP_ID, '->', a.PARENT_TASK_ID) PARENT_PRODUCT_NM,
        a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS  
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency_data b 
        on CONCAT(a.PARENT_PRODUCT_NM, '->', a.PARENT_INSTANCE_ID, '->', a.PARENT_APP_ID, '->', a.PARENT_TASK_ID)=CONCAT(b.PRODUCT_NM, '->', b.INSTANCE_ID, '->', b.APP_ID, '->', b.TASK_ID) 
        )a
        left join supply_chain_dashboard.dependency b 
        on a.PARENT_PRODUCT_NM COLLATE utf8mb4_0900_ai_ci=b.NODE_NM
        where b.NODE_ID is not null
        )stg
        left join supply_chain_dashboard.dependency tgt 
        on stg.PARENT_ID=tgt.PARENT_ID
        and stg.NODE_NM COLLATE utf8mb4_0900_ai_ci =tgt.NODE_NM
        where tgt.NODE_ID is null;

        SELECT COUNT(*) INTO count from
        (select distinct b.NODE_ID PARENT_ID,a.PRODUCT_NM NODE_NM,a.TASK_STATUS STATUS,a.SLA SLA,a.TASK_EXECUTION_TS EXECUTION_DT,'Downstream' NODE_DESCRIPTION
        from 
        (
        select CONCAT(a.PRODUCT_NM, '->', a.INSTANCE_ID, '->', a.APP_ID, '->', a.TASK_ID) PRODUCT_NM,
        CONCAT(a.PARENT_PRODUCT_NM, '->', a.PARENT_INSTANCE_ID, '->', a.PARENT_APP_ID, '->', a.PARENT_TASK_ID) PARENT_PRODUCT_NM,
        a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS  
        from supply_chain_dashboard.dependency_data a
        inner join supply_chain_dashboard.dependency_data b 
        on CONCAT(a.PARENT_PRODUCT_NM, '->', a.PARENT_INSTANCE_ID, '->', a.PARENT_APP_ID, '->', a.PARENT_TASK_ID)=CONCAT(b.PRODUCT_NM, '->', b.INSTANCE_ID, '->', b.APP_ID, '->', b.TASK_ID) 
        )a
        left join supply_chain_dashboard.dependency b 
        on a.PARENT_PRODUCT_NM COLLATE utf8mb4_0900_ai_ci=b.NODE_NM
        where b.NODE_ID is not null
        )stg
        left join supply_chain_dashboard.dependency tgt 
        on stg.PARENT_ID=tgt.PARENT_ID
        and stg.NODE_NM COLLATE utf8mb4_0900_ai_ci =tgt.NODE_NM
        where tgt.NODE_ID is null;
    
    END WHILE;
END //

DELIMITER ;

CALL InsertRowsBasedOnCount();


---Sample data 
mysql> select * from supply_chain_dashboard.dependency;
+---------+-----------+--------------------------------+-----------+-------+---------------------+------------------+
| NODE_ID | PARENT_ID | NODE_NM                        | STATUS    | SLA   | EXECUTION_DT        | NODE_DESCRIPTION |
+---------+-----------+--------------------------------+-----------+-------+---------------------+------------------+
|       1 |      NULL | DCA                            |           |       |                     | Organisation     |
|       2 |         1 | Supply Chain                   |           |       |                     | Domain           |
|       3 |         2 | Ecomm                          |           |       |                     | Product          |
|       4 |         3 | abc-101                        |           |       |                     | Instance         |
|       5 |         4 | dag-6                          | failed    | Daily | 2025-03-21 14:00:00 | Application      |
|       6 |         4 | dag-3                          | completed | Daily | 2025-03-21 11:00:00 | Application      |
|       7 |         4 | dag-1                          | running   | Daily | 2025-03-21 08:00:00 | Application      |
|       8 |         5 | ts-7                           | failed    | Daily | 2025-03-21 14:00:00 | Task             |
|       9 |         6 | ts-4                           | completed | Daily | 2025-03-21 11:00:00 | Task             |
|      10 |         7 | ts-2                           | completed | Daily | 2025-03-21 09:00:00 | Task             |
|      11 |         7 | ts-1                           | running   | Daily | 2025-03-21 08:00:00 | Task             |
|      15 |        11 | ODS->def-101->dag-2->ts-3      | queued    | Daily | 2025-03-21 10:00:00 | Downstream       |
|      16 |         9 | ODS->def-101->dag-4->ts-5      | running   | Daily | 2025-03-21 12:00:00 | Downstream       |
|      17 |         9 | ODS->def-101->dag-5->ts-6      | completed | Daily | 2025-03-21 13:00:00 | Downstream       |
|      18 |         8 | ODS->def-101->dag-7->ts-8      | queued    | Daily | 2025-03-21 15:00:00 | Downstream       |
|      22 |        15 | Returns->qwe-101->dag-10->ts-1 | running   | Daily | 2025-03-21 08:00:00 | Downstream       |
|      23 |        22 | FIN->pqr-101->dag-11->ts-1     | running   | Daily | 2025-03-21 08:00:00 | Downstream       |
|      24 |        15 | Returns->qwe-101->dag-13->ts-1 | running   | Daily | 2025-03-21 08:00:00 | Downstream       |
|      25 |        22 | FIN->pqr-101->dag-12->ts-1     | running   | Daily | 2025-03-21 08:00:00 | Downstream       |
|      26 |         4 | dag-20                         | running   | Daily | 2025-03-21 08:00:00 | Application      |
|      27 |        26 | ts-1                           | running   | Daily | 2025-03-21 08:00:00 | Task             |
+---------+-----------+--------------------------------+-----------+-------+---------------------+------------------+
