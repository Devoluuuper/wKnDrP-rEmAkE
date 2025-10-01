fx_version 'cerulean'
game 'gta5'

ui_page 'web/index.html'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
    '@kk-core/imports.lua'
} 

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

client_scripts {
    'client/*.lua'
}

files {
        'web/**',
    	'cdn/**'
}

lua54 'yes'