<?php
// load ZabbixApi
require_once __DIR__.'/vendor/autoload.php';
use ZabbixApi\ZabbixApi;

// connect to Zabbix API

$url = isset($_ENV['ZBX_API_URL']) ? $_ENV['ZBX_API_URL'] : 'http://zabbix/api_jsonrpc.php';
$user = isset($_ENV['ZBX_API_USER']) ? $_ENV['ZBX_API_USER'] : 'Admin';
$pass = isset($_ENV['ZBX_API_PASS']) ? $_ENV['ZBX_API_PASS'] : 'zabbix';

$http_user = isset($_ENV['ZBX_HTTP_AUTH_USER']) && $_ENV['ZBX_HTTP_AUTH_USER'] ? $_ENV['ZBX_HTTP_AUTH_USER'] : null;
$http_pass = isset($_ENV['ZBX_HTTP_AUTH_PASS']) && $_ENV['ZBX_HTTP_AUTH_USER'] ? $_ENV['ZBX_HTTP_AUTH_USER'] : null;

$templates = isset($_ENV['ZBX_TEMPLATES']) ? explode(',',$_ENV['ZBX_TEMPLATES']) : array('/etc/zabbix/scripts/zbx_clickhouse_template.xml');

$api = new ZabbixApi($url, $user, $pass, $http_user, $http_pass);


foreach ($templates as $template) {
    $api->configurationImport([
        'format'=>'xml',
        'rules'=>[
            'applications'=>[
                'createMissing'=>true,
            ],
            'discoveryRules'=>[
                'createMissing'=>true,
                'updateExisting'=>true,
            ],
            'groups'=>[
                'createMissing'=>true,
            ],
            'graphs'=>[
                'createMissing'=>true,
                'updateExisting'=>true,
            ],
            'items'=>[
                'createMissing'=>true,
                'updateExisting'=>true,
            ],
            'screens'=>[
                'createMissing'=>true,
                'updateExisting'=>true,
            ],
            'templateLinkage'=>[
                'createMissing'=>true,
            ],
            'templates'=>[
                'createMissing'=>true,
                'updateExisting'=>true,
            ],
            'templateScreens'=>[
                'createMissing'=>true,
                'updateExisting'=>true,
            ],
            'triggers'=>[
                'createMissing'=>true,
                'updateExisting'=>true,
            ],
            'valueMaps'=>[
                'createMissing'=>true,
                'updateExisting'=>true,
            ],
        ],
        'source'=>file_get_contents($template),
    ]);
    echo "$template put to $url OK\n";
}
