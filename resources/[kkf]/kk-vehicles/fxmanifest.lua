fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua',
	'@kk-core/imports.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}

client_scripts {
	'client/tools/*.lua',
	'client/controllers/*.lua',
	'client/*.lua'
}

lua54 'yes'