fx_version 'cerulean'
game 'gta5'

ui_page 'client/ui/index.html'

files {
    'client/ui/index.html',
    'client/ui/js/script.js',
    'client/ui/css/index.css'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua',
    'config.lua'
} 

client_script 'client/*.lua'
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
} 

lua54 'yes'