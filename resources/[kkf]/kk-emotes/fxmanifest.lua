fx_version 'cerulean'
game 'gta5'

ui_page 'web/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua',
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'

files {
    'animations.json',
    'web/**'
}

lua54 'yes'