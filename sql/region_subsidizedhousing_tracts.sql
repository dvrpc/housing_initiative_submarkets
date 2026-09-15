--drop materialized view if exists rhi.region_subsidizedhousing_tracts;
create materialized view rhi.region_subsidizedhousing_tracts as 
with nhpd_geom as (
select
	*,
	st_setsrid(st_makepoint("longitude",
	"latitude"),
	4326) as geom
from
	rhi."20260818_nhpd"
where
	left("censustract",
	5) in ('34005', '34007', '34015', '34021', '42017', '42029', '42045', '42091', '42101'))
	select
		n.*,
		tracts.geoid
	from
		nhpd_geom n
	join rhi.census_tracts_2020 tracts on
		st_intersects(tracts.shape,
		st_transform(n.geom,
		26918));