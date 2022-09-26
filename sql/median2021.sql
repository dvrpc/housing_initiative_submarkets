drop table if exists twg.deeds_21_geoms;
-- join lat/longs from properties tables to deeds table and create geoms in deeds
create table twg.deeds_21_geoms as
select
	deeds.*,
	ST_SetSRID(ST_MakePoint(props."LON",
	props."LAT"),
	4326) as geom
from
	twg.twg_deeds_2021 deeds
join (
	select
		"PROPID",
		"LON",
		"LAT"
	from
		twg.twg_properties_20220715
union
	select
		"PROPID",
		"LON",
		"LAT"
	from
		twg.twg_properties_20220722) as props
on
	props."PROPID" = deeds."PROPID"
where
	"PRICE" > 0 AND "DEEDTYPE" IN ('14', '15', '27', '55') AND "PROPUSE" IN (1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009);
--create spatial index on deeds
drop index if exists idx_deeds_21;
create index idx_deeds_21 on
twg.deeds_21_geoms
	using gist(geom);

drop table if exists twg.deeds_21_census;
--spatial join deeds with census tracts and add geoid to deeds
create table twg.deeds_21_census as 
select
	dg.*,
	tracts.geoid
from
	twg.deeds_21_geoms dg
join census.census_tracts_2020 tracts on
	st_intersects(st_transform(tracts.shape,
	4326),
	dg.geom);

drop table if exists twg.deeds_21_median;
--calculate median price by census tract
create table twg.deeds_21_median as
select
	geoid,
	percentile_cont(0.5) within group(
	order by "PRICE")
from
	twg.deeds_21_census
group by
	geoid;