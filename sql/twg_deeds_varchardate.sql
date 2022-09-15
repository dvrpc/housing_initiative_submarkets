CREATE VIEW "twg"."twg_deeds_2021_datefixed" AS
SELECT *, CAST("DATE" AS DATE) AS "VARCHARDATE" FROM "twg"."twg_deeds_2021";