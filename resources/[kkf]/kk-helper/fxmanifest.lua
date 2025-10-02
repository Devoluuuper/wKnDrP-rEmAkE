fx_version 'cerulean'
game 'gta5'

shared_scripts { 
    '@ox_lib/init.lua',
    '@kk-core/imports.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'

