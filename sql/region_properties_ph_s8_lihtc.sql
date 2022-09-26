DROP TABLE IF EXISTS nhpd.region_properties_ph_s8_lihtc;
CREATE TABLE nhpd.region_properties_ph_s8_lihtc AS
SELECT * FROM nhpd."102022_nhpd"
WHERE "County Code" IN (34005, 34007, 34015, 34021, 42017, 42029, 42045, 42091, 42101) AND
("NumberActiveSection8" > 0 OR
"NumberActiveLihtc" > 0 OR
"NumberActivePublicHousing" > 0);