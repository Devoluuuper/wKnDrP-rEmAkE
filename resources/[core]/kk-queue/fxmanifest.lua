fx_version 'cerulean'
game 'gta5'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client/cl_main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_main.lua',
    'server/sv_config.lua'
}

lua54 'yes'