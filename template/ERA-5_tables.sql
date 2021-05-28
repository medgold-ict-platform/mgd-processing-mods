CREATE EXTERNAL TABLE IF NOT EXISTS ${table_name} (latitude double,longitude double,time string,${variable} double) ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'WITH SERDEPROPERTIES ('serialization.format' = '1') LOCATION 's3://data.med-gold.eu/era5/p/parquet/${variable}/${type}' TBLPROPERTIES ('has_encrypted_data'='false');