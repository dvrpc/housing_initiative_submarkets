drop server if exists foreign_server cascade;
create server foreign_server
	foreign data wrapper postgres_fdw
	options (host 'gis-db', port '5432', dbname 'gis');