# Zabbix template for ClickHouse

How to set up server with Zabbix agent:
  * Ensure `xmllint` is installed.
  * Ensure `clickhouse-client` is installed.
  * Clone this repo.
  * Edit `/etc/zabbix/zabbix_agentd.conf`. Add the following line:
```bash
	UserParameter=ch_params[*],sh /PATH/TO/zbx_clickhouse_monitor.sh "$1" "HOST_WHERE_CH_IS_RUNNING"
```
  where:
  * `/PATH/TO/zbx_clickhouse_monitor.sh` depends on where you've cloned this repo.
  * `HOST_WHERE_CH_IS_RUNNING` is optional parameter, in case none specified `localhost` would be used

And finally
  * Import `zbx_clickhouse_template.xml` in zabbix (**zabbix -> Configuration -> Templates -> Import**).

![image01](img/image01.png)
![image02](img/image02.png)
![image03](img/image03.png)
![image04](img/image04.png)
![image05](img/image05.png)
![image06](img/image06.png)
![image07](img/image07.png)
![image08](img/image08.png)
![image09](img/image09.png)
![image10](img/image10.png)
![image11](img/image11.png)

