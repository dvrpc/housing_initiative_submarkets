drop table if exists twg.twg_deeds_2021;
create table twg.twg_deeds_2021 as
select * from twg_raw.twg_deeds_2021 td;