fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'@ox_lib/init.lua'
}

server_scripts {
	'@kk-core/imports.lua',
	'@kk-core/locale.lua',
	'config.lua',
	'gabz/*.lua',
	'server/main.lua'
}

client_scripts {
	'@kk-core/imports.lua',
	'@kk-core/locale.lua',
	'config.lua',
	'gabz/*.lua',
	'client/main.lua'
}

dependency 'kk-core'

ui_page {
    'html/door.html',
}

files {
	'html/door.html',
	'html/main.js', 
	'html/style.css',

	'html/sounds/*.ogg',
}

exports {
	'updateDoors'
}

lua54 'yes'