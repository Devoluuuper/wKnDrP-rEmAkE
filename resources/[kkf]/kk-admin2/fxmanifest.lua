fx_version 'cerulean'
game 'gta5'

ui_page 'web/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/jail.lua',
    'client/ban.lua',
    'client/chat.lua',
    'client/noclip.lua',
    'client/spectate.lua',
    'client/points.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/jail.lua',
    'server/ban.lua',
    'server/chat.lua',
    'server/spectate.lua',
    'server/points.lua',
    'server/lockdown.lua'
}

files {
    'web/**'
}

lua54 'yes'