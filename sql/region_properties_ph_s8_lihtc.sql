drop materialized view if exists nhpd.total_subsidized_units_by_tract cascade;

create materialized view nhpd.total_subsidized_units_by_tract as 

select
	geoid,
	sum(coalesce("S8_1_AssistedUnits",
	0) + coalesce("S8_2_AssistedUnits",
	0)) as total_s8,
	sum((coalesce("PH_1_AssistedUnits",
	0) + coalesce("PH_2_AssistedUnits",
	0))) as total_ph,
	sum((coalesce("LIHTC_1_AssistedUnits",
	0) + coalesce("LIHTC_2_AssistedUnits",
	0))) as total_lihtc,
	sum(coalesce("S8_1_AssistedUnits",
	0) + coalesce("S8_2_AssistedUnits", 0) + coalesce("LIHTC_1_AssistedUnits",
	0) + coalesce("LIHTC_2_AssistedUnits", 0) + coalesce("LIHTC_1_AssistedUnits",
	0) + coalesce("LIHTC_2_AssistedUnits", 0)) as total_subsidized_units
from
	nhpd.region_subsidizedhousing_tracts
where
		left(geoid,
		5) in ('34005', '34007', '34015', '34021', '42017', '42029', '42045', '42091', '42101')
group by geoid
