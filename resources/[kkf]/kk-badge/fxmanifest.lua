fx_version 'cerulean'
game 'gta5'

ui_page 'ui/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua'
} 

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

files {
    'ui/css/style.css',
    'ui/js/main.js',
    'ui/images/*.png',
    'ui/index.html'
}

lua54 'yes'