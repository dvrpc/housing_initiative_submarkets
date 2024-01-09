ALTER VIEW "twg"."twg_deeds_2016_datefixed" AS
SELECT *, CAST("DATE" AS VARCHAR) AS "VARCHARDATE" FROM "twg"."twg_deeds_2016";