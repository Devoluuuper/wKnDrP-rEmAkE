fx_version 'cerulean'
game 'gta5'

ui_page 'ui/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

client_script 'client.lua'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}

lua54 'yes'