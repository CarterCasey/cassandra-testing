create keyspace if not exists ycsb
	WITH REPLICATION = {'class' : 'SimpleStrategy', 'replication_factor': 2 };

create table if not exists ycsb.usertable (
	y_id varchar primary key,
	field0 blob,
	field1 blob,
	field2 blob,
	field3 blob,
	field4 blob,
	field5 blob,
	field6 blob,
	field7 blob,
	field8 blob,
	field9 blob
) with compression = {'sstable_compression': ''};

