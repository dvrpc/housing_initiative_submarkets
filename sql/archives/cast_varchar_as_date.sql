CREATE VIEW "twg"."twg_leftjoin_deeds2021_properties20220715_datefinal"
AS
SELECT *, CAST("LASTSLVARCHAR" AS DATE) AS "LSTSLDATE_FINAL" FROM "twg"."twg_leftjoin_deeds2021_properties20220715";