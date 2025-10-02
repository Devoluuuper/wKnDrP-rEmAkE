fx_version 'cerulean'
game 'gta5'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua'
}

client_scripts {
    'client/tattooshop.lua',
	'client/config.lua',
	'client/skins.lua',
	'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

ui_page 'client/html/index.html'

files {
    'client/html/index.html',
    'client/html/script.js'
}

lua54 'yes'
