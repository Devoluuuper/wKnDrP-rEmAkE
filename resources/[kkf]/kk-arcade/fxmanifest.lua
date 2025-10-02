fx_version 'adamant'
game 'gta5'

ui_page 'web/index.html'

shared_scripts {
	'@ox_lib/init.lua',
	'@kk-core/imports.lua',
	'config.lua'
}

client_scripts {
	'client/main.lua',
	'client/functions/*.lua'
}

files {
	'web/**'
}

lua54 'yes'