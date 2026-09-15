drop view if exists rhi.tracts_no_sales_transactions;
create view rhi.tracts_no_sales_transactions as 

select
	geoid
from
	rhi.region_tracts_mediansaleprice_subsidizedhousingunits_20212025 rtms
where
	left(geoid,
	5) in ('34005', '34007', '34015', '34021', '42017', '42029', '42045', '42091', '42101')
	and med25 is null