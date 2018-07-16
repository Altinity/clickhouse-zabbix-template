# Zabbix template for ClickHouse

How to set up server with Zabbiz agent:
  * Ensure `xmllint` is installed.
  * Ensure `clickhouse-client` is installed.
  * Clone this repo.
  * Edit `params.sh` script. Change hostname `CH_HOST="ch.example.com"` to host where clickhouse installed. 
  * Edit `/etc/zabbix/zabbix_agentd.conf`. Add the following line:
```bash
	UserParameter=ch_params[*],sh /PATH/TO/params.sh "$1"
```
where `/PATH/TO/params.sh` depends on where you've cloned this repo.
  * Import `zbx_clickhouse_template.xml` in zabbix (**zabbix -> Configuration -> Templates -> Import**).

