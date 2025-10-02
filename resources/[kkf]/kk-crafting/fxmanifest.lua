fx_version 'cerulean'
game 'gta5'

ui_page 'web/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

files {
    '@ox_inventory/web/images/**',
    'web/**'
}

lua54 'yes'