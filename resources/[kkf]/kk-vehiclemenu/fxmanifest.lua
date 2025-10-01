fx_version 'cerulean'
game 'gta5'

description 'KKasutaja Vehicle menu'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua'
}

ui_page 'ui/index.html'

client_script 'client.lua'

files {
    'ui/index.html',
    'ui/img/*.png',
    'ui/script.js'
}

lua54 'yes'