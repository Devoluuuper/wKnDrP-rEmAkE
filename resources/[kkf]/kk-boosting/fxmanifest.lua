fx_version 'cerulean'
game 'gta5'

ui_page 'ui/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua',
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',

    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

files {
    'ui/index.html',
    'ui/script.js'
}

lua54 'yes'