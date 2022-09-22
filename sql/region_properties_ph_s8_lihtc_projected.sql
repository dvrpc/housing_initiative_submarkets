CREATE VIEW nhpd.region_properties_ph_s8_lihtc_projected AS 
SELECT *, ST_AsText(
		ST_Transform(
			ST_SetSRID(geom, 26918),
			4326)
		)
FROM nhpd.region_properties_ph_s8_lihtc;