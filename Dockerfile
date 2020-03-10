# zabbix-agent + php + composer which allow connect to clickhouse server
FROM composer AS composer
FROM php:cli

ENV DOCKERIZE_VERSION v0.6.1
RUN curl -o dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz -sL https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN curl -o zabbix-release_4.4-1+buster_all.deb -sL https://repo.zabbix.com/zabbix/4.4/debian/pool/main/z/zabbix-release/zabbix-release_4.4-1+buster_all.deb \
  && apt-get update \
  && apt-get install --no-install-recommends -y apt-transport-https ca-certificates software-properties-common curl unzip git libxml2-utils gnupg2 \
  && dpkg -i zabbix-release_4.4-1+buster_all.deb \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E0C56BD4 \
  && add-apt-repository "deb http://repo.yandex.ru/clickhouse/deb/stable/ main/" \
  && apt-get update \
  && apt-get install --no-install-recommends -y zabbix-agent  \
  && apt-get install --no-install-recommends -y clickhouse-client \
  && rm -rf zabbix-release_4.4-1+buster_all.deb \
  && apt-get clean && apt-get auto-remove \
  && rm -rf /var/lib/apt/lists/*

ENV ZBX_SERVER=zabbix
ENV ZBX_API_URL=http://zabbix/api_jsonrpc.php
ENV ZBX_API_USER=Admin
ENV ZBX_API_PASS=zabbix
ENV ZBX_HTTP_AUTH_UZER=""
ENV ZBX_HTTP_AUTH_PASS=""
ENV CLICKHOUSE_SERVER=clickhouse
ENV ZBX_TEMPLATES=/etc/zabbix/scripts/zbx_clickhouse_template.xml

RUN mkdir -p /var/run/zabbix
RUN mkdir -p /etc/zabbix/php-zabbix-api
WORKDIR /etc/zabbix/php-zabbix-api
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN composer require confirm-it-solutions/php-zabbix-api
COPY import_zabbix_clickhouse_template.php ./

RUN echo "Server=${ZBX_SERVER}" >> /etc/zabbix/zabbix_agentd.conf
RUN echo "ServerActive=${ZBX_SERVER}" >> /etc/zabbix/zabbix_agentd.conf
RUN echo "Hostname=zabbix-agent" >> /etc/zabbix/zabbix_agentd.conf
RUN echo "DebugLevel=4" >> /etc/zabbix/zabbix_agentd.conf
RUN echo "AllowRoot=1" >> /etc/zabbix/zabbix_agentd.conf

CMD dockerize -timeout 60s -wait tcp://${ZBX_SERVER}:10051 -wait http://${CLICKHOUSE_SERVER}:8123/ping -- bash -xc "php -f /etc/zabbix/php-zabbix-api/import_zabbix_clickhouse_template.php && zabbix_agentd -f -c /etc/zabbix/zabbix_agentd.conf"