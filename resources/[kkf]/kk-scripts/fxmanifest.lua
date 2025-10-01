fx_version 'adamant'
game 'gta5'

ui_page 'ui/index.html'

shared_scripts {
	'@ox_lib/init.lua',
	'@kk-core/imports.lua',
	'config.lua'
} 

client_scripts {
	'client/*.lua',
	'client/*.js'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
	'server/*.js'
}

exports {
	'fuelCurrent',
	'fixCurrent',
	'saveAmmo'
}

files {
	'ui/index.html',
	'ui/img/map.png',
	'ui/script.js'
}

provide 'kk'
lua54 'yes'