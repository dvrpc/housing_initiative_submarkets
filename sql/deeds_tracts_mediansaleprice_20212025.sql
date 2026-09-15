drop table if exists rhi.deeds_tracts_mediansaleprice_20212025;
create table rhi.deeds_tracts_mediansaleprice_20212025 as
select
    ct.geoid,
    med21.percentile_cont med21,
    med25.percentile_cont as med25,
    med25.percentile_cont - (med21.percentile_cont) as diff,
	(med25.percentile_cont - (med21.percentile_cont))/(med21.percentile_cont*1.1273) * 100 as pct_diff,
    shape as geom
from
    rhi.census_tracts_2020 ct
full join twg.deeds_21_median med21 on
    med21.geoid = ct.geoid
full join twg.deeds_25_median med25 on
    med25.geoid = ct.geoid;