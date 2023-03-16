/*
create table ORGSYS_LOAD_DOCUMENTS (
  FILE_ID clob,
  FILENAME clob,
  FILE_EXT clob,
  FILE_SIZE clob,
  CREATOR clob,
  DATE_MODIFY clob,
  OBJECT_ID clob,
  "COMMENT" clob,
  PK_TABLE_ID  clob);
 
 create table FIRMSYS_LOAD_DOCUMENTS (
  FILE_ID clob,
  FILENAME clob,
  FILE_EXT clob,
  FILE_SIZE clob,
  CREATOR clob,
  DATE_MODIFY clob,
  OBJECT_ID clob,
  "COMMENT" clob,
  PK_TABLE_ID  clob);

*/ 

delete from ORGSYS_LOAD_DOCUMENTS;
delete from FIRMSYS_LOAD_DOCUMENTS;

insert all
into ORGSYS_LOAD_DOCUMENTS values ('1', '1','1','1','1','1','1','1','1')
into ORGSYS_LOAD_DOCUMENTS values ('2', '1','1','1','1','1','1','1','1')
into ORGSYS_LOAD_DOCUMENTS values ('3', '1','1','1','1','1','1','1','1')
into ORGSYS_LOAD_DOCUMENTS values ('4', '1','1','1','1','1','1','1','1')
SELECT * FROM dual;

insert all
into FIRMSYS_LOAD_DOCUMENTS values ('5', '5','1','1','1','1','1','1','1')
into FIRMSYS_LOAD_DOCUMENTS values ('2', '2','1','1','1','1','1','1','1')
into FIRMSYS_LOAD_DOCUMENTS values ('3', '3','1','1','1','1','1','1','1')
into FIRMSYS_LOAD_DOCUMENTS values ('4', '4','1','1','1','1','1','1','1')
SELECT * FROM dual;

-- delete
delete from ORGSYS_LOAD_DOCUMENTS
where to_char(file_id) in (
select to_char(o.file_id)
from ORGSYS_LOAD_DOCUMENTS o
left  join  FIRMSYS_LOAD_DOCUMENTS f
on to_char(f.FILE_ID) = to_char(o.FILE_ID)
where to_char(f.FILE_ID) is NULL
) ;

-- вариант 1 добавления и обновления строк
/*
insert into  ORGSYS_LOAD_DOCUMENTS 
select f.* 
from FIRMSYS_LOAD_DOCUMENTS f
left  join ORGSYS_LOAD_DOCUMENTS o
on to_char(f.FILE_ID) = to_char(o.FILE_ID)
where to_char(o.FILE_ID) is NULL; -- add

update ORGSYS_LOAD_DOCUMENTS o1
set (file_id, filename, file_ext, file_size, creator, date_modify, object_id, "COMMENT", pk_table_id) = (select f.* 
from FIRMSYS_LOAD_DOCUMENTS f
where to_char(f.FILE_ID) = to_char(o1.FILE_ID)
)
where exists (
select 1 
from FIRMSYS_LOAD_DOCUMENTS f
where to_char(f.FILE_ID) = to_char(o1.FILE_ID)
); --update
*/

-- вариант 2 обновления и добавления строк
MERGE INTO ORGSYS_LOAD_DOCUMENTS o
    using (select * from FIRMSYS_LOAD_DOCUMENTS) f
    on (to_char(f.FILE_ID) = to_char(o.FILE_ID))
    when matched THEN 
        update set o.filename = f.filename, o.file_ext = f.file_ext, 
            o.file_size = f.file_size, o.creator = f.creator, 
            o.date_modify = f.date_modify, o.object_id = f.object_id, 
            o."COMMENT" = f."COMMENT", o.pk_table_id = f.pk_table_id

    when not matched then insert (o.file_id, o.filename, o.file_ext, o.file_size, o.creator, o.date_modify, o.object_id, o."COMMENT", o.pk_table_id)
    values (f.file_id, f.filename, f.file_ext, f.file_size, f.creator, f.date_modify, f.object_id, f."COMMENT", f.pk_table_id);

select * from ORGSYS_LOAD_DOCUMENTS