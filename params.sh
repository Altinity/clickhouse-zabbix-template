#!/bin/sh

ITEM="$1"
CH_PATH="$(xmllint --xpath 'string(/yandex/path)' /etc/clickhouse-server/config.xml)"
if [ "$?" -ne 0 ];then echo "Something goes wrong"; exit 1 ;fi 
CH_HOST="ch.example.com"
usage() {
echo "
Usage: $(basename "$0") SomeARG
Example: $(basename "$0") Query
"
exit 1
}

if [ -z "$ITEM" ]; then
	echo "There is no argument"
	usage
fi

case "$ITEM" in
	Query)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from metrics where metric = 'Query'"	
	;;
	MemoryTracking)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from metrics where metric = 'MemoryTracking'"	
	;;
	HTTPConnection)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from metrics where metric = 'HTTPConnection'"	
	;;
	TCPConnection)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from metrics where metric = 'TCPConnection'"	
	;;
	ZooKeeperWatch)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from metrics where metric = 'ZooKeeperWatch'"	
	;;
	Read)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from metrics where metric = 'Read'"	
	;;
	Write)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from metrics where metric = 'Write'"	
	;;
	SelectedParts)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from events where event = 'SelectedParts'"	
	;;
	InsertQuery)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from events where event = 'InsertQuery'"	
	;;
	InsertedRows)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from events where event = 'InsertedRows'"	
	;;
	InsertedBytes)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from events where event = 'InsertedBytes'"	
	;;
	SelectQuery)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from events where event = 'SelectQuery'"	
	;;
	MergedRows)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from events where event = 'MergedRows'"	
	;;
	MergedUncompressedBytes)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from events where event = 'MergedUncompressedBytes'"	
	;;
	DelayedInserts)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from metrics where metric = 'DelayedInserts'"	
	;;
	MaxPartCountForPartition)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from asynchronous_metrics where metric = 'MaxPartCountForPartition'"	
	;;
	ReplicasSumQueueSize)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from asynchronous_metrics where metric = 'ReplicasSumQueueSize'"	
	;;
	ReplicasMaxAbsoluteDelay)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from asynchronous_metrics where metric = 'ReplicasMaxAbsoluteDelay'"	
	;;
	Uptime)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from asynchronous_metrics where metric = 'Uptime'"	
	;;
	InsertedBytes)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from events where event = 'InsertedBytes'"	
	;;
	ReadCompressedBytes)
		 /usr/bin/clickhouse-client  -h $CH_HOST -d system -q "select value from events where event = 'ReadCompressedBytes'"	
	;;
	DiskUsage)
		du -sb $CH_PATH | awk '{print $1}'
	;;
	Revision)
		cat  $CH_PATH/status | grep Revision | awk '{print $2}'
	;;
	LongestRunningQuery)
		 /usr/bin/clickhouse-client -h $CH_HOST -q "select elapsed from system.processes" | sort | tail -1
	;;
	*)
		echo "There is no such argument"
		exit 1
	;;
esac

