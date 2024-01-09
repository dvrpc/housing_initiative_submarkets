CREATE FOREIGN TABLE dvrpc_protectedopenspace2020 (
        objectid int4,
        state varchar(20),
        county varchar(20),
        os_type varchar(20),
        acres numeric(38, 8),
        gdb_geomattr_data bytea,
        shape geometry
)
        SERVER foreign_server
        OPTIONS (schema_name 'planning', table_name 'dvrpc_protectedopenspace2020');