CREATE FOREIGN TABLE circuittrails (
        objectid int4,
        state varchar(10),
        name varchar(50),
        length numeric(8, 3),
        circuit varchar(25),
        county varchar(25),
        main_trail varchar(50),
        sub_trail varchar(35),
        globalid varchar(38),
        opendate timestamp,
        surface varchar(30),
        width numeric(4, 2),
        facility varchar(30),
        facility_gen varchar(30),
        surface_gen varchar(30),
        segment varchar(200),
        length_gen numeric(38, 8),
        width_gen numeric(38, 8),
        sequence varchar(5),
        gdb_geomattr_data bytea,
        shape geometry,
        ecg varchar(1),
        nmt_911 varchar(1)
)
        SERVER foreign_server
        OPTIONS (schema_name 'transportation', table_name 'circuittrails');