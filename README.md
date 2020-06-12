# Zabbix template for ClickHouse
Required Zabbix Server version - 3.0+
For zabbix 5.0+ please use [official Zabbix ClickHouse integration used http_agent](https://www.zabbix.com/integrations/clickhouse) 

How to set up server with Zabbix agent:
  * Ensure `xmllint` is installed 
    - for Debian\Ubuntu `apt-get install -y libxml2-utils`
    - for CentOS / Fedora `yum install -y libxml2` 
    - for OpenSUSE `yum install -y libxml2-tools` 
  * Ensure `clickhouse-client` is installed and allow access to monitored ClickHouse server
    - https://clickhouse.tech/docs/en/getting_started/install/
  * Clone this repo.
  * Edit `/etc/zabbix/zabbix_agentd.conf`. Add the following line:
```bash
	UserParameter=ch_params[*],bash /PATH/TO/zbx_clickhouse_monitor.sh "$1" "HOST_WHERE_CH_IS_RUNNING" "ADDITIONAL CLICKHOUSE-CLIENT PARAMS"
```
  where:
  * `/PATH/TO/zbx_clickhouse_monitor.sh` depends on where you've cloned this repo.
  * `HOST_WHERE_CH_IS_RUNNING` is optional parameter, in case none specified `localhost` would be used
  * `ADDITIONAL CLICKHOUSE-CLIENT PARAMS` is optional string appended to any clickhouse-client call. Useful if authorization or ssl required

And finally
  * Import `zbx_clickhouse_template.xml` in zabbix (**zabbix -> Configuration -> Templates -> Import**).

![image01](img/image01.png)
![image02](img/image02.png)
![image03](img/image03.png)
![image04](img/image04.png)
![image05](img/image05.png)
![dashboard](img/dashboard.png)
