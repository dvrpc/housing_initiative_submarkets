ALTER TABLE "nhpd"."102022_nhpd"
DROP COLUMN "geom";
ALTER TABLE "nhpd"."102022_nhpd"
ADD COLUMN geom geometry(Point, 4326);