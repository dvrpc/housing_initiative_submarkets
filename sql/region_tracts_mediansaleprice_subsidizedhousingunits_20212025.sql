drop table if exists rhi.region_tracts_mediansaleprice_subsidizedhousingunits_20212025;
create table rhi.region_tracts_mediansaleprice_subsidizedhousingunits_20212025 as
select
	dtm.geoid,
	rsu."Total Subsidized Units",
	dtm.med25,
	dtm.pct_diff
from  rhi.deeds_tracts_mediansaleprice_20212025 dtm 
left join rhi.region_subsidizedhousing_unitsbytract rsu on
	dtm.geoid = rsu.geoid;