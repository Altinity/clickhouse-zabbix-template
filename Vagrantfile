# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.box_check_update = false

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  config.vm.define :clickhouse_zabbix do |clickhouse_zabbix|
    clickhouse_zabbix.vm.network "private_network", ip: "172.16.2.2", nic_type: "virtio"
    clickhouse_zabbix.vm.host_name = "local-altinity-clickhouse-zabbix"
    clickhouse_zabbix.hostmanager.aliases = ["clickhouse-zabbix.local"]
  end

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "2048"
  end

  config.vm.provision "shell", inline: <<-SHELL
    set -xeuo pipefail

    apt-get update
    apt-get install --no-install-recommends -y apt-transport-https ca-certificates software-properties-common curl
    apt-get install --no-install-recommends -y htop ethtool mc curl wget jq socat git

    # yq
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
    add-apt-repository ppa:rmescandon/yq
    apt-get install --no-install-recommends -y yq

    # clickhouse
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E0C56BD4
    add-apt-repository "deb http://repo.yandex.ru/clickhouse/deb/stable/ main/"
    apt-get install --no-install-recommends -y clickhouse-client

    # docker
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8D81803C0EBFCD88
    add-apt-repository "deb https://download.docker.com/linux/ubuntu bionic edge"
    apt-get install --no-install-recommends -y docker-ce

    # docker compose
    apt-get install --no-install-recommends -y python3-pip
    python3 -m pip install -U pip
    rm -rf /usr/bin/pip3
    pip3 install -U setuptools
    pip3 install -U docker-compose
    cd /vagrant
    docker-compose pull
    docker-compose build
    docker-compose up -d
  SHELL
end