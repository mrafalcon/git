/*
CREATE USER org
  IDENTIFIED BY org
  DEFAULT TABLESPACE tbs_01
  TEMPORARY TABLESPACE tbs_01
  QUOTA 20M on tbs_01;

GRANT create session TO org;
GRANT create table TO org;
GRANT create view TO org;
GRANT create any trigger TO org;
GRANT create any procedure TO org;
GRANT create sequence TO org;
GRANT create synonym TO org;


CREATE USER firm
  IDENTIFIED BY firm
  DEFAULT TABLESPACE tbs_01
  TEMPORARY TABLESPACE tbs_01
  QUOTA 20M on tbs_01;


GRANT create session TO firm;
GRANT create table TO firm;
GRANT create view TO firm;
GRANT create any trigger TO firm;
GRANT create any procedure TO firm;
GRANT create sequence TO firm;
GRANT create synonym TO firm;

create schema authorization org;
create schema authorization FIRM;
*/

drop table ORGSYS_LOAD_DOCUMENTS;
drop table FIRMSYS_LOAD_DOCUMENTS;


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


delete from ORGSYS_LOAD_DOCUMENTS;
delete from FIRMSYS_LOAD_DOCUMENTS;

insert all
into ORGSYS_LOAD_DOCUMENTS values (1, 'name11','1',1,'1',to_date('01/01/2023','dd/mm/yyyy'),1,'comm11',1)
into ORGSYS_LOAD_DOCUMENTS values (2, 'name12','1',1,'1',to_date('02/01/2023','dd/mm/yyyy'),1,'comm12',1)
into ORGSYS_LOAD_DOCUMENTS values (3, 'name13','1',1,'1',to_date('03/01/2023','dd/mm/yyyy'),1,'comm13',1)
into ORGSYS_LOAD_DOCUMENTS values (4, 'name14','1',1,'1',to_date('04/01/2023','dd/mm/yyyy'),1,'comm14',1)
SELECT * FROM dual;

insert all
into FIRMSYS_LOAD_DOCUMENTS values (5, 'name52','1',1,'1',to_date('05/02/2023','dd/mm/yyyy'),1,'comm25',1)
into FIRMSYS_LOAD_DOCUMENTS values (2, 'name22','1',1,'1',to_date('02/02/2023','dd/mm/yyyy'),1,'comm22',1)
into FIRMSYS_LOAD_DOCUMENTS values (3, 'name23','1',1,'1',to_date('03/02/2023','dd/mm/yyyy'),1,'comm23',1)
into FIRMSYS_LOAD_DOCUMENTS values (4, 'name24','1',1,'1',to_date('04/02/2023','dd/mm/yyyy'),1,'comm24',1)
SELECT * FROM dual;




-- delete
delete from ORGSYS_LOAD_DOCUMENTS
where (file_id) in (
select (o.file_id)
from ORGSYS_LOAD_DOCUMENTS o
left  join  FIRMSYS_LOAD_DOCUMENTS f
on (f.FILE_ID) = (o.FILE_ID)
where (f.FILE_ID) is NULL
) ;



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


select * from ORGSYS_LOAD_DOCUMENTS