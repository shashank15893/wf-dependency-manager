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

CALL InsertRowsBasedOnCount();


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


SELECT COUNT(*) from
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

INSERT INTO dependency_data (ORG_NAME, DOMAIN_NM, PRODUCT_NM, APP_ID, INSTANCE_ID, PRIORITY, SLA, APP_STATUS, APP_RUN_ID, TASK_ID, TASK_STATUS, APP_EXECUTION_TS, TASK_EXECUTION_TS, PARENT_APP_ID, PARENT_INSTANCE_ID, PARENT_TASK_ID,PARENT_PRODUCT_NM)
VALUES
('DCA', 'Supply Chain', 'Ecomm', 'dag-20', 'abc-101', 'P1', 'Daily', 'running', 1, 'ts-1', 'running', '2025-03-21 08:00:00', '2025-03-21 08:00:00', null, null, null,null);

INSERT INTO dependency_data (ORG_NAME, DOMAIN_NM, PRODUCT_NM, APP_ID, INSTANCE_ID, PRIORITY, SLA, APP_STATUS, APP_RUN_ID, TASK_ID, TASK_STATUS, APP_EXECUTION_TS, TASK_EXECUTION_TS, PARENT_APP_ID, PARENT_INSTANCE_ID, PARENT_TASK_ID,PARENT_PRODUCT_NM)
VALUES
('DCA', 'Supply Chain', 'Returns', 'dag-15', 'qwe-101', 'P1', 'Daily', 'running', 1, 'ts-1', 'running', '2025-03-21 08:00:00', '2025-03-21 08:00:00', 'dag-20', 'abc-101', 'ts-1','Ecomm');

INSERT INTO dependency_data (ORG_NAME, DOMAIN_NM, PRODUCT_NM, APP_ID, INSTANCE_ID, PRIORITY, SLA, APP_STATUS, APP_RUN_ID, TASK_ID, TASK_STATUS, APP_EXECUTION_TS, TASK_EXECUTION_TS, PARENT_APP_ID, PARENT_INSTANCE_ID, PARENT_TASK_ID,PARENT_PRODUCT_NM)
VALUES
('DCA', 'Supply Chain', 'Ecomm', 'dag-20', 'abc-101', 'P1', 'Daily', 'running', 1, 'ts-1', 'running', '2025-03-21 08:00:00', '2025-03-21 08:00:00', null, null, null,null);


INSERT INTO dependency_data (ORG_NAME, DOMAIN_NM, PRODUCT_NM, APP_ID, INSTANCE_ID, PRIORITY, SLA, APP_STATUS, APP_RUN_ID, TASK_ID, TASK_STATUS, APP_EXECUTION_TS, TASK_EXECUTION_TS, PARENT_APP_ID, PARENT_INSTANCE_ID, PARENT_TASK_ID,PARENT_PRODUCT_NM)
VALUES
('DCA', 'Supply Chain', 'Returns', 'dag-13', 'qwe-101', 'P1', 'Daily', 'running', 1, 'ts-1', 'running', '2025-03-21 08:00:00', '2025-03-21 08:00:00', 'dag-2', 'def-101', 'ts-3','ODS');

INSERT INTO dependency_data (ORG_NAME, DOMAIN_NM, PRODUCT_NM, APP_ID, INSTANCE_ID, PRIORITY, SLA, APP_STATUS, APP_RUN_ID, TASK_ID, TASK_STATUS, APP_EXECUTION_TS, TASK_EXECUTION_TS, PARENT_APP_ID, PARENT_INSTANCE_ID, PARENT_TASK_ID,PARENT_PRODUCT_NM)
VALUES
('DCA', 'Supply Chain', 'FIN', 'dag-12', 'pqr-101', 'P1', 'Daily', 'running', 1, 'ts-1', 'running', '2025-03-21 08:00:00', '2025-03-21 08:00:00', 'dag-10', 'qwe-101', 'ts-1','Returns');

++++++++++++++++++++++++++++++++

select * from
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

_____

union all
select distinct PARENT_ID,PRODUCT_NM NODE_NM,TASK_STATUS STATUS,SLA SLA,TASK_EXECUTION_TS EXECUTION_DT,'Downstream' NODE_DESCRIPTION
from (select CONCAT(PRODUCT_NM, '->', INSTANCE_ID, '->', APP_ID, '->', TASK_ID) PRODUCT_NM,b.NODE_ID as PARENT_ID,
a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS  
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on CONCAT(PRODUCT_NM, '->', INSTANCE_ID, '->', APP_ID, '->', TASK_ID) COLLATE utf8mb4_0900_ai_ci =b.NODE_NM )x
;

union all
select distinct PARENT_ID,PRODUCT_NM NODE_NM,TASK_STATUS STATUS,SLA SLA,TASK_EXECUTION_TS EXECUTION_DT,'Downstream' NODE_DESCRIPTION
from (select CONCAT(PRODUCT_NM, '->', INSTANCE_ID, '->', APP_ID, '->', TASK_ID) PRODUCT_NM,b.NODE_ID as PARENT_ID,
a.TASK_STATUS,a.SLA,a.TASK_EXECUTION_TS  
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on CONCAT(PARENT_PRODUCT_NM, '->', PARENT_INSTANCE_ID, '->', PARENT_APP_ID, '->', PARENT_TASK_ID) COLLATE utf8mb4_0900_ai_ci =b.NODE_NM )x

union all
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
select distinct PARENT_ID,INSTANCE_ID NODE_NM,'' STATUS,'' SLA,'' EXECUTION_DT,'Downstream Instance' NODE_DESCRIPTION
from (select a.INSTANCE_ID,b.NODE_ID as PARENT_ID 
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on a.PRODUCT_NM COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
and b.NODE_DESCRIPTION='Downstream Product')x;

+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+---------+-----------+---------+--------+------+--------------+--------------------+
| id | ORG_NAME | DOMAIN_NM    | PRODUCT_NM | APP_ID | INSTANCE_ID | PRIORITY | SLA   | APP_STATUS | APP_RUN_ID | TASK_ID | TASK_STATUS | APP_EXECUTION_TS    | TASK_EXECUTION_TS   | PARENT_APP_ID | PARENT_INSTANCE_ID | PARENT_TASK_ID | CREATED_AT          | UPDATED_AT          | NODE_ID | PARENT_ID | NODE_NM | STATUS | SLA  | EXECUTION_DT | NODE_DESCRIPTION   |
+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+---------+-----------+---------+--------+------+--------------+--------------------+
|  3 | DCA      | Supply Chain | ODS        | dag-2  | def-101     | P1       | Daily | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      17 |         8 | ODS     |        |      |              | Downstream Product |
|  3 | DCA      | Supply Chain | ODS        | dag-2  | def-101     | P1       | Daily | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      16 |         9 | ODS     |        |      |              | Downstream Product |
|  3 | DCA      | Supply Chain | ODS        | dag-2  | def-101     | P1       | Daily | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      15 |        11 | ODS     |        |      |              | Downstream Product |
|  5 | DCA      | Supply Chain | ODS        | dag-4  | def-101     | P1       | Daily | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      17 |         8 | ODS     |        |      |              | Downstream Product |
|  5 | DCA      | Supply Chain | ODS        | dag-4  | def-101     | P1       | Daily | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      16 |         9 | ODS     |        |      |              | Downstream Product |
|  5 | DCA      | Supply Chain | ODS        | dag-4  | def-101     | P1       | Daily | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      15 |        11 | ODS     |        |      |              | Downstream Product |
|  6 | DCA      | Supply Chain | ODS        | dag-5  | def-101     | P1       | Daily | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      17 |         8 | ODS     |        |      |              | Downstream Product |
|  6 | DCA      | Supply Chain | ODS        | dag-5  | def-101     | P1       | Daily | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      16 |         9 | ODS     |        |      |              | Downstream Product |
|  6 | DCA      | Supply Chain | ODS        | dag-5  | def-101     | P1       | Daily | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      15 |        11 | ODS     |        |      |              | Downstream Product |
|  8 | DCA      | Supply Chain | ODS        | dag-7  | def-101     | P1       | Daily | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      17 |         8 | ODS     |        |      |              | Downstream Product |
|  8 | DCA      | Supply Chain | ODS        | dag-7  | def-101     | P1       | Daily | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      16 |         9 | ODS     |        |      |              | Downstream Product |
|  8 | DCA      | Supply Chain | ODS        | dag-7  | def-101     | P1       | Daily | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      15 |        11 | ODS     |        |      |              | Downstream Product |
+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+---------+-----------+---------+--------+------+--------------+--------------------+



select a.PRODUCT_NM,b.NODE_ID as PARENT_ID 
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on PARENT_TASK_ID COLLATE utf8mb4_0900_ai_ci =b.NODE_NM 


insert into supply_chain_dashboard.dependency(PARENT_ID,NODE_NM,STATUS,SLA,EXECUTION_DT,NODE_DESCRIPTION)
select distinct PARENT_ID,APP_ID NODE_NM,APP_STATUS STATUS,SLA SLA,APP_EXECUTION_TS EXECUTION_DT,'Downstream Application' NODE_DESCRIPTION
from (select a.APP_ID,b.NODE_ID as PARENT_ID,a.APP_STATUS,a.SLA,a.APP_EXECUTION_TS 
select *
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on a.INSTANCE_ID COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
and  b.NODE_DESCRIPTION='Downstream Instance'
)x
join 
(select distinct a.INSTANCE_ID,b.NODE_ID as PARENT_ID 
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on a.PRODUCT_NM COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
and b.NODE_DESCRIPTION='Downstream Product')y
on x.PARENT_ID=y.PARENT_ID;

and PARENT_APP_ID ='Supply Chain' 
and PARENT_TASK_ID='Ecomm';

+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+---------+-----------+---------+--------+------+--------------+---------------------+
| id | ORG_NAME | DOMAIN_NM    | PRODUCT_NM | APP_ID | INSTANCE_ID | PRIORITY | SLA   | APP_STATUS | APP_RUN_ID | TASK_ID | TASK_STATUS | APP_EXECUTION_TS    | TASK_EXECUTION_TS   | PARENT_APP_ID | PARENT_INSTANCE_ID | PARENT_TASK_ID | CREATED_AT          | UPDATED_AT          | NODE_ID | PARENT_ID | NODE_NM | STATUS | SLA  | EXECUTION_DT | NODE_DESCRIPTION    |
+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+---------+-----------+---------+--------+------+--------------+---------------------+
|  3 | DCA      | Supply Chain | ODS        | dag-2  | def-101     | P1       | Daily | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      40 |        15 | def-101 |        |      |              | Downstream Instance |
|  3 | DCA      | Supply Chain | ODS        | dag-2  | def-101     | P1       | Daily | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      39 |        16 | def-101 |        |      |              | Downstream Instance |
|  3 | DCA      | Supply Chain | ODS        | dag-2  | def-101     | P1       | Daily | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      38 |        17 | def-101 |        |      |              | Downstream Instance |
|  5 | DCA      | Supply Chain | ODS        | dag-4  | def-101     | P1       | Daily | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      40 |        15 | def-101 |        |      |              | Downstream Instance |
|  5 | DCA      | Supply Chain | ODS        | dag-4  | def-101     | P1       | Daily | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      39 |        16 | def-101 |        |      |              | Downstream Instance |
|  5 | DCA      | Supply Chain | ODS        | dag-4  | def-101     | P1       | Daily | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      38 |        17 | def-101 |        |      |              | Downstream Instance |
|  6 | DCA      | Supply Chain | ODS        | dag-5  | def-101     | P1       | Daily | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      40 |        15 | def-101 |        |      |              | Downstream Instance |
|  6 | DCA      | Supply Chain | ODS        | dag-5  | def-101     | P1       | Daily | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      39 |        16 | def-101 |        |      |              | Downstream Instance |
|  6 | DCA      | Supply Chain | ODS        | dag-5  | def-101     | P1       | Daily | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      38 |        17 | def-101 |        |      |              | Downstream Instance |
|  8 | DCA      | Supply Chain | ODS        | dag-7  | def-101     | P1       | Daily | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      40 |        15 | def-101 |        |      |              | Downstream Instance |
|  8 | DCA      | Supply Chain | ODS        | dag-7  | def-101     | P1       | Daily | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      39 |        16 | def-101 |        |      |              | Downstream Instance |
|  8 | DCA      | Supply Chain | ODS        | dag-7  | def-101     | P1       | Daily | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      38 |        17 | def-101 |        |      |              | Downstream Instance |
+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+---------+-----------+---------+--------+------+--------------+---------------------+

+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+
| id | ORG_NAME | DOMAIN_NM    | PRODUCT_NM | APP_ID | INSTANCE_ID | PRIORITY | SLA   | APP_STATUS | APP_RUN_ID | TASK_ID | TASK_STATUS | APP_EXECUTION_TS    | TASK_EXECUTION_TS   | PARENT_APP_ID | PARENT_INSTANCE_ID | PARENT_TASK_ID | CREATED_AT          | UPDATED_AT          |
+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+
|  3 | DCA      | Supply Chain | ODS        | dag-2  | def-101     | P1       | Daily | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  3 | DCA      | Supply Chain | ODS        | dag-2  | def-101     | P1       | Daily | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  3 | DCA      | Supply Chain | ODS        | dag-2  | def-101     | P1       | Daily | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  5 | DCA      | Supply Chain | ODS        | dag-4  | def-101     | P1       | Daily | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  5 | DCA      | Supply Chain | ODS        | dag-4  | def-101     | P1       | Daily | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  5 | DCA      | Supply Chain | ODS        | dag-4  | def-101     | P1       | Daily | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  6 | DCA      | Supply Chain | ODS        | dag-5  | def-101     | P1       | Daily | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  6 | DCA      | Supply Chain | ODS        | dag-5  | def-101     | P1       | Daily | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  6 | DCA      | Supply Chain | ODS        | dag-5  | def-101     | P1       | Daily | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  8 | DCA      | Supply Chain | ODS        | dag-7  | def-101     | P1       | Daily | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  8 | DCA      | Supply Chain | ODS        | dag-7  | def-101     | P1       | Daily | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  8 | DCA      | Supply Chain | ODS        | dag-7  | def-101     | P1       | Daily | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+


+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+---------+-----------+---------+--------+------+--------------+---------------------+
| id | ORG_NAME | DOMAIN_NM    | PRODUCT_NM | APP_ID | INSTANCE_ID | PRIORITY | SLA   | APP_STATUS | APP_RUN_ID | TASK_ID | TASK_STATUS | APP_EXECUTION_TS    | TASK_EXECUTION_TS   | PARENT_APP_ID | PARENT_INSTANCE_ID | PARENT_TASK_ID | CREATED_AT          | UPDATED_AT          | NODE_ID | PARENT_ID | NODE_NM | STATUS | SLA  | EXECUTION_DT | NODE_DESCRIPTION    |
+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+---------+-----------+---------+--------+------+--------------+---------------------+
|  3 | DCA      | Supply Chain | ODS        | dag-2  | def-101     | P1       | Daily | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      40 |        15 | def-101 |        |      |              | Downstream Instance |
|  3 | DCA      | Supply Chain | ODS        | dag-2  | def-101     | P1       | Daily | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      39 |        16 | def-101 |        |      |              | Downstream Instance |
|  3 | DCA      | Supply Chain | ODS        | dag-2  | def-101     | P1       | Daily | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      38 |        17 | def-101 |        |      |              | Downstream Instance |
|  5 | DCA      | Supply Chain | ODS        | dag-4  | def-101     | P1       | Daily | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      40 |        15 | def-101 |        |      |              | Downstream Instance |
|  5 | DCA      | Supply Chain | ODS        | dag-4  | def-101     | P1       | Daily | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      39 |        16 | def-101 |        |      |              | Downstream Instance |
|  5 | DCA      | Supply Chain | ODS        | dag-4  | def-101     | P1       | Daily | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      38 |        17 | def-101 |        |      |              | Downstream Instance |
|  6 | DCA      | Supply Chain | ODS        | dag-5  | def-101     | P1       | Daily | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      40 |        15 | def-101 |        |      |              | Downstream Instance |
|  6 | DCA      | Supply Chain | ODS        | dag-5  | def-101     | P1       | Daily | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      39 |        16 | def-101 |        |      |              | Downstream Instance |
|  6 | DCA      | Supply Chain | ODS        | dag-5  | def-101     | P1       | Daily | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      38 |        17 | def-101 |        |      |              | Downstream Instance |
|  8 | DCA      | Supply Chain | ODS        | dag-7  | def-101     | P1       | Daily | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      40 |        15 | def-101 |        |      |              | Downstream Instance |
|  8 | DCA      | Supply Chain | ODS        | dag-7  | def-101     | P1       | Daily | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      39 |        16 | def-101 |        |      |              | Downstream Instance |
|  8 | DCA      | Supply Chain | ODS        | dag-7  | def-101     | P1       | Daily | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |      38 |        17 | def-101 |        |      |              | Downstream Instance |
+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+---------+-----------+---------+--------+------+--------------+---------------------+

+---------+-----------+--------------+-----------+-------+---------------------+---------------------+
| NODE_ID | PARENT_ID | NODE_NM      | STATUS    | SLA   | EXECUTION_DT        | NODE_DESCRIPTION    |
+---------+-----------+--------------+-----------+-------+---------------------+---------------------+
|       1 |      NULL | DCA          |           |       |                     | Organisation        |
|       2 |         1 | Supply Chain |           |       |                     | Domain              |
|       3 |         2 | Ecomm        |           |       |                     | Product             |
|       4 |         3 | abc-101      |           |       |                     | Instance            |
|       5 |         4 | dag-6        | failed    | Daily | 2025-03-21 14:00:00 | Application         |
|       6 |         4 | dag-3        | completed | Daily | 2025-03-21 11:00:00 | Application         |
|       7 |         4 | dag-1        | running   | Daily | 2025-03-21 08:00:00 | Application         |
|       8 |         5 | ts-7         | failed    | Daily | 2025-03-21 14:00:00 | Task                |
|       9 |         6 | ts-4         | completed | Daily | 2025-03-21 11:00:00 | Task                |
|      10 |         7 | ts-2         | completed | Daily | 2025-03-21 09:00:00 | Task                |
|      11 |         7 | ts-1         | running   | Daily | 2025-03-21 08:00:00 | Task                |
|      15 |        11 | ODS          |           |       |                     | Downstream Product  |
|      16 |         9 | ODS          |           |       |                     | Downstream Product  |
|      17 |         8 | ODS          |           |       |                     | Downstream Product  |
|      38 |        17 | def-101      |           |       |                     | Downstream Instance |
|      39 |        16 | def-101      |           |       |                     | Downstream Instance |
|      40 |        15 | def-101      |           |       |                     | Downstream Instance |
+---------+-----------+--------------+-----------+-------+---------------------+---------------------+

select * from supply_chain_dashboard.dependency
where 

select distinct a.INSTANCE_ID,b.NODE_ID as PARENT_ID 
from supply_chain_dashboard.dependency_data a
inner join supply_chain_dashboard.dependency b 
on a.PRODUCT_NM COLLATE utf8mb4_0900_ai_ci = b.NODE_NM
and b.NODE_DESCRIPTION='Downstream Product'

+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+
| id | ORG_NAME | DOMAIN_NM    | PRODUCT_NM | APP_ID | INSTANCE_ID | PRIORITY | SLA   | APP_STATUS | APP_RUN_ID | TASK_ID | TASK_STATUS | APP_EXECUTION_TS    | TASK_EXECUTION_TS   | PARENT_APP_ID | PARENT_INSTANCE_ID | PARENT_TASK_ID | CREATED_AT          | UPDATED_AT          |
+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+
|  3 | DCA      | Supply Chain | ODS        | dag-2  | def-101     | P1       | Daily | queued     |          3 | ts-3    | queued      | 2025-03-21 10:00:00 | 2025-03-21 10:00:00 | dag-1         | abc-101            | ts-1           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  5 | DCA      | Supply Chain | ODS        | dag-4  | def-101     | P1       | Daily | running    |          5 | ts-5    | running     | 2025-03-21 12:00:00 | 2025-03-21 12:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  6 | DCA      | Supply Chain | ODS        | dag-5  | def-101     | P1       | Daily | completed  |          6 | ts-6    | completed   | 2025-03-21 13:00:00 | 2025-03-21 13:00:00 | dag-3         | abc-101            | ts-4           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
|  8 | DCA      | Supply Chain | ODS        | dag-7  | def-101     | P1       | Daily | queued     |          8 | ts-8    | queued      | 2025-03-21 15:00:00 | 2025-03-21 15:00:00 | dag-6         | abc-101            | ts-7           | 2025-03-22 19:13:50 | 2025-03-22 19:13:50 |
+----+----------+--------------+------------+--------+-------------+----------+-------+------------+------------+---------+-------------+---------------------+---------------------+---------------+--------------------+----------------+---------------------+---------------------+

+-----------+---------+-----------+-------+---------------------+------------------------+
| PARENT_ID | NODE_NM | STATUS    | SLA   | EXECUTION_DT        | NODE_DESCRIPTION       |
+-----------+---------+-----------+-------+---------------------+------------------------+
|        40 | dag-2   | queued    | Daily | 2025-03-21 10:00:00 | Downstream Application |
|        39 | dag-2   | queued    | Daily | 2025-03-21 10:00:00 | Downstream Application |
|        38 | dag-2   | queued    | Daily | 2025-03-21 10:00:00 | Downstream Application |
|        40 | dag-4   | running   | Daily | 2025-03-21 12:00:00 | Downstream Application |
|        39 | dag-4   | running   | Daily | 2025-03-21 12:00:00 | Downstream Application |
|        38 | dag-4   | running   | Daily | 2025-03-21 12:00:00 | Downstream Application |
|        40 | dag-5   | completed | Daily | 2025-03-21 13:00:00 | Downstream Application |
|        39 | dag-5   | completed | Daily | 2025-03-21 13:00:00 | Downstream Application |
|        38 | dag-5   | completed | Daily | 2025-03-21 13:00:00 | Downstream Application |
|        40 | dag-7   | queued    | Daily | 2025-03-21 15:00:00 | Downstream Application |
|        39 | dag-7   | queued    | Daily | 2025-03-21 15:00:00 | Downstream Application |
|        38 | dag-7   | queued    | Daily | 2025-03-21 15:00:00 | Downstream Application |
+-----------+---------+-----------+-------+---------------------+------------------------+


+--------+-----------+------------+-------+---------------------+---------+-----------+---------+--------+------+--------------+---------------------+
| APP_ID | PARENT_ID | APP_STATUS | SLA   | APP_EXECUTION_TS    | NODE_ID | PARENT_ID | NODE_NM | STATUS | SLA  | EXECUTION_DT | NODE_DESCRIPTION    |
+--------+-----------+------------+-------+---------------------+---------+-----------+---------+--------+------+--------------+---------------------+
| dag-2  |        40 | queued     | Daily | 2025-03-21 10:00:00 |      40 |        15 | def-101 |        |      |              | Downstream Instance |
| dag-2  |        39 | queued     | Daily | 2025-03-21 10:00:00 |      39 |        16 | def-101 |        |      |              | Downstream Instance |
| dag-2  |        38 | queued     | Daily | 2025-03-21 10:00:00 |      38 |        17 | def-101 |        |      |              | Downstream Instance |
| dag-4  |        40 | running    | Daily | 2025-03-21 12:00:00 |      40 |        15 | def-101 |        |      |              | Downstream Instance |
| dag-4  |        39 | running    | Daily | 2025-03-21 12:00:00 |      39 |        16 | def-101 |        |      |              | Downstream Instance |
| dag-4  |        38 | running    | Daily | 2025-03-21 12:00:00 |      38 |        17 | def-101 |        |      |              | Downstream Instance |
| dag-5  |        40 | completed  | Daily | 2025-03-21 13:00:00 |      40 |        15 | def-101 |        |      |              | Downstream Instance |
| dag-5  |        39 | completed  | Daily | 2025-03-21 13:00:00 |      39 |        16 | def-101 |        |      |              | Downstream Instance |
| dag-5  |        38 | completed  | Daily | 2025-03-21 13:00:00 |      38 |        17 | def-101 |        |      |              | Downstream Instance |
| dag-7  |        40 | queued     | Daily | 2025-03-21 15:00:00 |      40 |        15 | def-101 |        |      |              | Downstream Instance |
| dag-7  |        39 | queued     | Daily | 2025-03-21 15:00:00 |      39 |        16 | def-101 |        |      |              | Downstream Instance |
| dag-7  |        38 | queued     | Daily | 2025-03-21 15:00:00 |      38 |        17 | def-101 |        |      |              | Downstream Instance |
+--------+-----------+------------+-------+---------------------+---------+-----------+---------+--------+------+--------------+---------------------+
12 rows in set (0.00 sec)


CREATE PROCEDURE InsertRowsBasedOnCount()
BEGIN
    DECLARE count INT;
    DECLARE i INT DEFAULT 0;

    -- Get the count from your SQL statement
    SELECT COUNT(*) INTO count FROM your_table WHERE your_condition;

    -- Iteratively insert new rows based on the count
    WHILE i < count DO
        INSERT INTO example_table (column1, column2) VALUES ('value1', 'value2');
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

CALL InsertRowsBasedOnCount();