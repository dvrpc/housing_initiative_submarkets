drop materialized view if exists rhi.region_subsidizedhousing_unitsbytract;
create materialized view rhi.region_subsidizedhousing_unitsbytract as
select
	tracts.geoid,
	sum("totalunits") as "Total Subsidized Units"
from  rhi.census_tracts_2020 tracts
left join rhi.region_subsidizedhousing_tracts a on
	tracts.geoid = a.geoid
group by tracts.geoid;