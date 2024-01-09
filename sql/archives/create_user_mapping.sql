CREATE USER MAPPING if not exists for public
        SERVER foreign_server
        OPTIONS (user 'dvrpc_viewer', password 'viewer');