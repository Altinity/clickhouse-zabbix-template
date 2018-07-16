# Zabbix template for ClickHouse

How to set up:
  * Ensure `xmllint` is installed on the server.
  * Copy `params.sh` to the server with zabbix_agent.
  * Change hostname variable `CH_HOST="ch.example.com"` in `params.sh` script to host where clickhouse installed. 
  * Add to `/etc/zabbix/zabbix_agentd.conf` the following string:
```bash
	UserParameter=ch_params[*],sh /PATH/TO/params.sh "$1"
```
  * Import `zbx_clickhouse_template.xml` in zabbix (**zabbix -> Configuration -> Templates -> Import**)
