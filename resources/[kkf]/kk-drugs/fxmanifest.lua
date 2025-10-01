fx_version 'cerulean'
game 'gta5'

author "KK Growing Script"
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua',
    -- '@es_extended/imports.lua'
    'config.lua'
}

client_scripts {
    'client.lua'
} 

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

lua54 'yes'


escrow_ignore {
    'config.lua',
}