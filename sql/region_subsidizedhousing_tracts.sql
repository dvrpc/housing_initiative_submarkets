--drop materialized view if exists nhpd.region_subsidizedhousing_tracts;
create materialized view nhpd.region_subsidizedhousing_tracts as 
with nhpd_geom as (
select
	*,
	st_setsrid(st_makepoint("Longitude",
	"Latitude"),
	4326) as geom
from
	nhpd."20260818_nhpd"
where
	left("CensusTract",
	5) in ('34005', '34007', '34015', '34021', '42017', '42029', '42045', '42091', '42101'))
	select
		n.*,
		tracts.geoid
	from
		nhpd_geom n
	join census.census_tracts_2020 tracts on
		st_intersects(tracts.shape,
		st_transform(n.geom,
		26918));