drop table if exists public.region_tracts_mediansaleprice_subsidizedhousingunits;
create table public.region_tracts_mediansaleprice_subsidizedhousingunits as
select
	dtm.geoid,
	rsu."Total Subsidized Units",
	dtm.med21,
	dtm.pct_diff
from  twg.deeds_tracts_mediansaleprice_20162021 dtm 
left join nhpd.region_subsidizedhousing_unitsbytract rsu on
	dtm.geoid = rsu.geoid;