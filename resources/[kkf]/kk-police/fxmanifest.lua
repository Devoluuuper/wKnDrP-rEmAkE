fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'@ox_lib/init.lua',
	'@kk-core/imports.lua',
	'config.lua'
} 

ui_page 'web/index.html'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
	'modules/**/server.lua'
}

client_scripts {
	'client.lua',
	'modules/**/client.lua',
}

files {
	'web/**'
}

lua54 'yes'