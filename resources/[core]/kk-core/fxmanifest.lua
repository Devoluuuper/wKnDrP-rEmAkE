fx_version 'cerulean'
game 'gta5'

version '1.0'

ui_page 'web/index.html'

shared_scripts {
	'@ox_lib/init.lua',
	'locale.lua',
	'locales/en.lua',

	'config.lua',
	'config.weapons.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',

	'server/common.lua',
	'server/functions.lua',
	'server/main.lua',

	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua'
}

client_scripts {
	'client/functions.lua',
	'client/wrapper.lua',
	'client/main.lua',
	'client/events.lua',

	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua'
}

files {
	'imports.lua',
	'web/**'
}

exports {
	'getSharedObject'
}

server_exports {
	'getSharedObject'
}

lua54 'yes'
