fx_version 'cerulean'
game 'gta5'

ui_page 'web/index.html'

shared_scripts {
	'@ox_lib/init.lua',
	'@kk-core/imports.lua',
	'config.lua'
} 

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
	'server/register.lua'
}

client_scripts {
	'client/main.lua',
	'client/job.lua',
	'client/register.lua',
	'client/intensive.lua'
}

files {
	'web/**'
}

lua54 'yes'