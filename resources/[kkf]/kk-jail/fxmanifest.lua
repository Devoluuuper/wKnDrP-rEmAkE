fx_version 'cerulean'
game 'gta5'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua',
    '@kk-sync/client/lib.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/cleaning.lua'
}

server_scripts {
    '@oxmysql/lib/MySQl.lua',
    'server/*.lua'
}

lua54 'yes'