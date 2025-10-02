fx_version 'cerulean'
game 'gta5'

ui_page 'web/index.html'

shared_scripts {
    -- 'config.lua',
    '@ox_lib/init.lua',
    '@kk-core/imports.lua'
}

client_script 'client.lua'

files {
    'web/**',
    'web/img/**'
}

lua54 'yes'