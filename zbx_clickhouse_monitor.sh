#!/bin/bash
#
# Yandex ClickHouse Zabbix template
#
# Copyright (C) Ivinco Ltd
# Copyright (C) Altinity Ltd



# Default host where ClickHouse is expected to be available
# You may want to change this for your installation
CH_HOST="${2:-localhost}"

##
## Write usage info
##
function usage()
{
	echo "Usage: $(basename "$0") Command [ClickHouse Host to Connect]"
}

# Command to execute
ITEM="$1"
if [ -z "$ITEM" ]; then
	echo "Provide command to run"
	usage
	exit 1
fi

# Ensure xmllint is available
xmllint="$(which xmllint)"
if [ "$?" -ne 0 ]; then
	echo "Looks like xmllint is not available. Please install it."
	exit 1
fi

# Extract ClickHouse data directory
# Usually it is /var/lib/clickhouse
CH_PATH="$(xmllint --xpath 'string(/yandex/path)' /etc/clickhouse-server/config.xml)"
if [ "$?" -ne 0 ]; then
	echo "Something went wrong with parsing ClickHouse config. Is xmllist installed? Is ClickHouse config available?"
	exit 1
fi 

##
## Fetch metric by name from ClickHouse
##
function run_ch_metric_command()
{
	# Metric name to fetch
	METRIC=$1
	DATABASE="system"
	SQL="SELECT value FROM metrics WHERE metric = '$METRIC'"
	/usr/bin/clickhouse-client -h "$CH_HOST" -d "$DATABASE" -q "$SQL"
}

##
## Fetch processes info from ClickHouse
##
function run_ch_process_command()
{
	DATABASE="system"
	SQL="SELECT elapsed FROM processes"
	/usr/bin/clickhouse-client -h "$CH_HOST" -d "$DATABASE" -q "$SQL"
}

case "$ITEM" in
	DiskUsage)
		du -sb "$CH_PATH" | awk '{print $1}'
		;;

	Revision)
		cat  "$CH_PATH/status" | grep Revision | awk '{print $2}'
		;;

	LongestRunningQuery)
		run_ch_process_command | sort | tail -1
		;;

	DelayedInserts		| \
	HTTPConnection		| \
	InsertedBytes		| \
	InsertedBytes		| \
	InsertedRows		| \
	InsertQuery		| \
	MaxPartCountForPartition| \
	MemoryTracking		| \
	MergedRows		| \
	MergedUncompressedBytes	| \
	Query			| \
	Read			| \
	ReadCompressedBytes	| \
	ReplicasMaxAbsoluteDelay| \
	ReplicasSumQueueSize	| \
	SelectedParts		| \
	SelectQuery		| \
	TCPConnection		| \
	Uptime			| \
	Write			| \
	ZooKeeperWatch		)
		run_ch_metric_command "$ITEM"
		;;

	*)
		echo "Unknown argument '$ITEM'. Please check command to run"
		exit 1
		;;
esac

