fx_version 'cerulean'
game 'gta5'

shared_script '@ox_lib/init.lua'

client_scripts {
    'client/lib.lua',
    'client/main.lua'
}

server_script 'server.lua'

lua54 'yes'