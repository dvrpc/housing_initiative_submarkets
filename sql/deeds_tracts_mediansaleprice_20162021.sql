drop table if exists twg.deeds_tracts_mediansaleprice_20162021;
create table twg.deeds_tracts_mediansaleprice_20162021 as
select
    ct.geoid,
    med16.percentile_cont med16,
    med16.percentile_cont * 1.1273 as infadj16 ,
    med21.percentile_cont as med21,
    med21.percentile_cont - (med16.percentile_cont * 1.1273) as diff,
	(med21.percentile_cont - (med16.percentile_cont * 1.1273))/(med16.percentile_cont*1.1273) * 100 as pct_diff,
    shape as geom
from
    census.census_tracts_2020 ct
full join twg.deeds_16_median med16 on
    med16.geoid = ct.geoid
full join twg.deeds_21_median med21 on
    med21.geoid = ct.geoid;