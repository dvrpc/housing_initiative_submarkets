drop table if exists twg.deeds_25_geoms;
-- join lat/longs from properties tables to deeds table and create geoms in deeds
create table twg.deeds_25_geoms as
select
	*,
	ST_SetSRID(ST_MakePoint("lon",
	"lat"),
	4326) as geom
from
	twg.dvrpctrans05062026;
--create spatial index on deeds
drop index if exists idx_deeds_25;
create index idx_deeds_25 on
twg.deeds_25_geoms
	using gist(geom);

drop table if exists twg.deeds_25_census;
--spatial join deeds with census tracts and add geoid to deeds
create table twg.deeds_25_census as 
select
	dg.*,
	tracts.geoid
from
	twg.deeds_25_geoms dg
join rhi.census_tracts_2020 tracts on
	st_intersects(st_transform(tracts.shape,
	4326),
	dg.geom);

drop table if exists twg.deeds_25_median;
--calculate median price by census tract
create table twg.deeds_25_median as
select
	geoid,
	percentile_cont(0.5) within group(
	order by "price")
from
	twg.deeds_25_census
group by
	geoid;