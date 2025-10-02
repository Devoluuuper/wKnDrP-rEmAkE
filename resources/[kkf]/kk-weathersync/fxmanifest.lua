fx_version 'cerulean'
game 'gta5'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua',
    'shared/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_script {
    'server/*.lua'
}

lua54 'yes'