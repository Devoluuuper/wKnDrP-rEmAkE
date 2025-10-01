fx_version 'cerulean'
game 'gta5'
description 'Tablet for selling vehicles'
author 'Atu'

ui_page 'ui/index.html'

shared_scripts {
	'@ox_lib/init.lua',
    '@kk-core/imports.lua',
    'config.lua'
} 
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

client_script 'client.lua'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/*.js',
}

lua54 'yes'