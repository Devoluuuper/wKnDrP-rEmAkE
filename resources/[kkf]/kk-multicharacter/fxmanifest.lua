fx_version 'cerulean'
game 'gta5'

author 'KKasutaja'

ui_page 'ui/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
}

client_scripts {
    'client/main.lua',
    'client/appearance.lua'
} 

files {
	'ui/index.html',
	'ui/app.js',
}

lua54 'yes'