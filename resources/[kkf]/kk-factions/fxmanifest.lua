fx_version 'cerulean'
game 'gta5'

ui_page 'web/index.html'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
    '@kk-core/imports.lua'
}

client_scripts {
    '@kk-sync/client/lib.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
} 

files {
    'web/**'
}

lua54 'yes'