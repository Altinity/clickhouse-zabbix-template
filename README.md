# Zabbix template for ClickHouse

How to set up.

1. Ensure `xmllint` is installed on the server. It usually it is installed

2. Copy script "params.sh" to the server with zabbix_agent.

3. Change hostname variable 'CH_HOST="ch.example.com"' into "params.sh" script to currently using host where clickhouse installed. 

4. Add to /etc/zabbix/zabbix_agentd.conf following string:
	UserParameter=ch_params[*],sh /boardreader/admin_scripts/zabbix_scripts/clickhouse/params.sh "$1"

5. Import "zbx_clickhouse_template.xml" in zabbix (zabbix -> Configuration -> Templates -> Import)
