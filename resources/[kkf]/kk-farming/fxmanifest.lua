fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'@ox_lib/init.lua',
	'@kk-core/imports.lua',
	'config.lua'
} 

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}

client_scripts {
	'client.lua'
}

lua54 'yes'