CREATE VIEW "twg"."twg_deeds_2021_datefinal"
AS
SELECT *, CAST("VARCHARDATE" AS DATE) AS "DATE_FINAL" FROM "twg"."twg_deeds_2021_datefixed";