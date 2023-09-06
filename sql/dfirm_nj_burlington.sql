CREATE FOREIGN TABLE dfirm_nj_burlington (
        objectid int4, 
        dfirm_id varchar(6), 
        version_id varchar(11), 
        fld_ar_id varchar(32), 
        study_typ varchar(28), 
        fld_zone varchar(17), 
        zone_subty varchar(72), 
        sfha_tf varchar(1), 
        static_bfe numeric(38, 8), 
        v_datum varchar(17), 
        "depth" numeric(38, 8), 
        len_unit varchar(16), 
        velocity numeric(38, 8), 
        vel_unit varchar(20), 
        ar_revert varchar(17), 
        ar_subtrv varchar(57), 
        bfe_revert numeric(38, 8), 
        dep_revert numeric(38, 8), 
        dual_zone varchar(1), 
        source_cit varchar(21), 
        zone_desc varchar(40), 
        gdb_geomattr_data bytea, 
        shape geometry

)
        SERVER foreign_server
        OPTIONS (schema_name 'hydrography', table_name 'dfirm_nj_burlington');