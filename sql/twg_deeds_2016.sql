drop table if exists twg.twg_deeds_2016;
create table twg.twg_deeds_2016 as
select * from twg_raw.twg_deeds_2016 td;
UPDATE twg.twg_deeds_2016
SET
"PROPID" = REPLACE("PROPID", 'TRAN', 'PROP');