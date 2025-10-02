fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'@ox_lib/init.lua',
	'@kk-core/imports.lua',
	'config.lua'
}

client_scripts {
    '@kk-sync/client/lib.lua',
    'client/main.lua',
	'client/blips.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
	'server/blips.lua',
	'server/houses.lua'
}

lua54 'yes'