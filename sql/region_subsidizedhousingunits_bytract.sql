drop table if exists nhpd.region_subsidizedhousing_unitsbytract;
create table nhpd.region_subsidizedhousing_unitsbytract as
select
	tracts.geoid,
	sum("Total Units") as "Total Subsidized Units"
from  census.census_tracts_2020 tracts
left join nhpd.region_subsidizedhousing_tracts a on
	tracts.geoid = a.geoid
group by tracts.geoid;

