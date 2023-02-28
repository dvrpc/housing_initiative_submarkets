drop table if exists nhpd.region_subsidizedhousing_tracts;
create table nhpd.region_subsidizedhousing_tracts as 
select
    a.*,
    tracts.geoid
from
    nhpd.region_properties_ph_s8_lihtc a
join census.census_tracts_2020 tracts on
    st_intersects(tracts.shape, st_transform(a.geom, 26918));