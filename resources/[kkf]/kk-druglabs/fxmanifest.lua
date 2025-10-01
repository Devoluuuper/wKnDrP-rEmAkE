fx_version 'cerulean'
game 'gta5'

ui_page 'ui/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
} 

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

files {
    'ui/**',
    'ui/img/**',
}

lua54 'yes'