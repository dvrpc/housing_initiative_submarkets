DROP VIEW IF EXISTS "twg"."twg_leftjoin_deeds2021_properties20220715";
CREATE VIEW "twg"."twg_leftjoin_deeds2021_properties20220715" AS
SELECT "deeds"."PROPID", "TRANID", "DEEDTYPE", "DATE_FINAL", "MORTGAGE", "PRICE", "LSTSLPR", "LSTSLDATE" FROM "twg"."twg_deeds_2021_datefinal" AS "deeds"
LEFT JOIN "twg"."twg_properties_20220715" AS "properties"
ON "deeds"."PROPID" = "properties"."PROPID"
WHERE "deeds"."PROPID" IS NOT NULL AND "DEEDTYPE" = '27';