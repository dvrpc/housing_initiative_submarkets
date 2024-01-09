CREATE FOREIGN TABLE lrp_2050_planningareas (
        objectid int4,
        state_name varchar(15),
        co_name varchar(35),
        mun_name varchar(40),
        mun_label varchar(35),
        geoid varchar(10),
        st_area_sh numeric(38, 8),
        st_perimet numeric(38, 8),
        pa_2050 varchar(35),
        gdb_geomattr_data bytea,
        shape geometry
)
        SERVER foreign_server
        OPTIONS (schema_name 'planning', table_name 'lrp_2050_planningareas');