/*

drop table ORGSYS_LOAD_DOCUMENTS;
drop table FIRMSYS_LOAD_DOCUMENTS;
drop table FIRM1SYS_LOAD_DOCUMENTS;

create table --if not exists 
  ORGSYS_LOAD_DOCUMENTS (
   FILE_ID int
    , FILENAME varchar2(255)
    , FILE_EXT varchar2(255)
    , FILE_SIZE int
    , CREATOR varchar2(255)
    , DATE_MODIFY date
    , OBJECT_ID int
    , "COMMENT" varchar2(255)
    , PK_TABLE_ID  int
, PRIMARY KEY (FILE_ID)
  );
 
 create table --if not exists  
 FIRMSYS_LOAD_DOCUMENTS (
    FILE_ID int
    , FILENAME varchar2(255)
    , FILE_EXT varchar2(255)
    , FILE_SIZE int
    , CREATOR varchar2(255)
    , DATE_MODIFY date
    , OBJECT_ID int
    , "COMMENT" varchar2(255)
    , PK_TABLE_ID  int
, PRIMARY KEY (FILE_ID)
  );

create table --if not exists  
 FIRM1SYS_LOAD_DOCUMENTS (
    FILE_ID int
    , FILENAME varchar2(255)
    , FILE_EXT varchar2(255)
    , FILE_SIZE int
    , CREATOR varchar2(255)
    , DATE_MODIFY date
    , OBJECT_ID int
    , "COMMENT" varchar2(255)
    , PK_TABLE_ID  int
, PRIMARY KEY (FILE_ID)
  );

*/
delete from ORGSYS_LOAD_DOCUMENTS;
delete from FIRMSYS_LOAD_DOCUMENTS;
--delete from FIRM1SYS_LOAD_DOCUMENTS;

insert all
into ORGSYS_LOAD_DOCUMENTS values (1, 'name11','1',1,'1',to_date('01/01/2023','dd/mm/yyyy'),1,'comm11',1)
into ORGSYS_LOAD_DOCUMENTS values (2, 'name12','1',1,'1',to_date('02/01/2023','dd/mm/yyyy'),1,'comm12',1)
into ORGSYS_LOAD_DOCUMENTS values (7, 'name17','1',1,'1',to_date('07/01/2023','dd/mm/yyyy'),1,'comm17',1)
into ORGSYS_LOAD_DOCUMENTS values (8, 'name18','1',1,'1',to_date('08/01/2023','dd/mm/yyyy'),1,'comm18',1)
into ORGSYS_LOAD_DOCUMENTS values (11, 'name111','1',1,'1',to_date('11/01/2023','dd/mm/yyyy'),1,'comm111',1)
into ORGSYS_LOAD_DOCUMENTS values (12, 'name112','1',1,'1',to_date('12/01/2023','dd/mm/yyyy'),1,'comm112',1)
SELECT * FROM dual;

insert all
into FIRMSYS_LOAD_DOCUMENTS values (5, 'name52','1',1,'1',to_date('05/02/2023','dd/mm/yyyy'),1,'comm25',1)
into FIRMSYS_LOAD_DOCUMENTS values (2, 'name22','1',1,'1',to_date('02/02/2023','dd/mm/yyyy'),1,'comm22',1)
into FIRMSYS_LOAD_DOCUMENTS values (3, 'name23','1',1,'1',to_date('03/02/2023','dd/mm/yyyy'),1,'comm23',1)
into FIRMSYS_LOAD_DOCUMENTS values (4, 'name24','1',1,'1',to_date('04/02/2023','dd/mm/yyyy'),1,'comm24',1)
into FIRMSYS_LOAD_DOCUMENTS values (8, 'name38','1',1,'1',to_date('08/03/2023','dd/mm/yyyy'),1,'comm38',1)
into FIRMSYS_LOAD_DOCUMENTS values (9, 'name39','1',1,'1',to_date('09/03/2023','dd/mm/yyyy'),1,'comm39',1)
SELECT * FROM dual;

/*insert all
into FIRM1SYS_LOAD_DOCUMENTS values (7, 'name37','1',1,'1',to_date('07/03/2023','dd/mm/yyyy'),1,'comm37',1)
into FIRM1SYS_LOAD_DOCUMENTS values (8, 'name38','1',1,'1',to_date('08/03/2023','dd/mm/yyyy'),1,'comm38',1)
into FIRM1SYS_LOAD_DOCUMENTS values (9, 'name39','1',1,'1',to_date('09/03/2023','dd/mm/yyyy'),1,'comm39',1)
into FIRM1SYS_LOAD_DOCUMENTS values (10, 'name310','1',1,'1',to_date('10/03/2023','dd/mm/yyyy'),1,'comm310',1)
SELECT * FROM dual;
*/

/*

-- delete
delete from ORGSYS_LOAD_DOCUMENTS
where (file_id) in (
select (o.file_id)
from ORGSYS_LOAD_DOCUMENTS o
left  join  FIRMSYS_LOAD_DOCUMENTS f
on (f.FILE_ID) = (o.FILE_ID)
where (f.FILE_ID) is NULL
) ;

*/

-- вариант 1 добавления и обновления строк
/*
insert into  ORGSYS_LOAD_DOCUMENTS 
select f.* 
from FIRMSYS_LOAD_DOCUMENTS f
left  join ORGSYS_LOAD_DOCUMENTS o
on (f.FILE_ID) = (o.FILE_ID)
where (o.FILE_ID) is NULL; -- add

update ORGSYS_LOAD_DOCUMENTS o1
set (file_id, filename, file_ext, file_size, creator, date_modify, object_id, "COMMENT", pk_table_id) = (select f.* 
from FIRMSYS_LOAD_DOCUMENTS f
where (f.FILE_ID) = (o1.FILE_ID)
)
where exists (
select 1 
from FIRMSYS_LOAD_DOCUMENTS f
where (f.FILE_ID) = (o1.FILE_ID)
); --update
*/

/*
-- вариант 2 обновления и добавления строк
MERGE INTO ORGSYS_LOAD_DOCUMENTS o
    using (select * from FIRMSYS_LOAD_DOCUMENTS) f
    on ((f.FILE_ID) = (o.FILE_ID))
    when matched THEN 
        update set o.filename = f.filename, o.file_ext = f.file_ext, 
            o.file_size = f.file_size, o.creator = f.creator, 
            o.date_modify = f.date_modify, o.object_id = f.object_id, 
            o."COMMENT" = f."COMMENT", o.pk_table_id = f.pk_table_id

    when not matched then insert (o.file_id, o.filename, o.file_ext, o.file_size, o.creator, o.date_modify, o.object_id, o."COMMENT", o.pk_table_id)
    values (f.file_id, f.filename, f.file_ext, f.file_size, f.creator, f.date_modify, f.object_id, f."COMMENT", f.pk_table_id);

*/

/*
select file_id, filename, file_ext, file_size, creator, date_modify, object_id, "COMMENT", pk_table_id,
    case 
      when file_id in (
        
        select o.file_id from ORGSYS_LOAD_DOCUMENTS o
        join FIRMSYS_LOAD_DOCUMENTS f
        on o.file_id = f.FILE_ID

      ) then 'update'
      else 'delete'
    end as action_type
  from ORGSYS_LOAD_DOCUMENTS

*/

/*

DECLARE
    schemaName VARCHAR2(30) := 'HR';
    tableName VARCHAR2(30) := 'FIRM%SYS_LOAD_DOCUMENTS';
--    stmt CLOB;
--    do_action BOOLEAN;
BEGIN
    FOR tr IN (
        SELECT t.OWNER, t.TABLE_NAME
        FROM ALL_TABLES t
        where t.owner = schemaName and t.table_name like tableName
        order by 1, 2
    )
    LOOP
            select file_id, filename, file_ext, file_size, creator, date_modify, object_id, "COMMENT", pk_table_id,
                case 
                  when file_id in (
                    select o.file_id from ORGSYS_LOAD_DOCUMENTS o
                    join tr f
                    on o.file_id = f.FILE_ID
                  ) then 1
                  else 0
                end as action_type
            from ORGSYS_LOAD_DOCUMENTS;
            execute immediate stmt;
    END LOOP;
END;
/

*/

--select * from ORGSYS_LOAD_DOCUMENTS


select file_id, filename, file_ext, file_size, creator, date_modify, object_id, "COMMENT", pk_table_id, 
  case 
        when file_id in (
        select o.file_id from ORGSYS_LOAD_DOCUMENTS o
        join FIRMSYS_LOAD_DOCUMENTS f
        on o.file_id = f.FILE_ID
      ) and file_level = 'org' then '0'                       -- row for update in "org"
        
        when file_id in (
        select o.file_id from ORGSYS_LOAD_DOCUMENTS o
        join FIRMSYS_LOAD_DOCUMENTS f
        on o.file_id = f.FILE_ID
      ) and file_level = 'firm' then '1'                      -- updated row in "firm" 
        
        when file_id in (
        select f.file_id from FIRMSYS_LOAD_DOCUMENTS f
        left join ORGSYS_LOAD_DOCUMENTS o
        on (f.FILE_ID) = (o.FILE_ID)
        where (o.FILE_ID) is NULL
      ) and file_level = 'firm' then '2'                      -- add row to "org"
      
      else '-1'                                               -- delete row from "org"
  end as action_type
from (select file_id, filename, file_ext, file_size, creator, date_modify, object_id, "COMMENT", pk_table_id, 'org' as file_level from ORGSYS_LOAD_DOCUMENTS
union all
select file_id, filename, file_ext, file_size, creator, date_modify, object_id, "COMMENT", pk_table_id, 'firm' as file_level from FIRMSYS_LOAD_DOCUMENTS)