fx_version 'adamant'

game 'gta5'

description 'KK Society'

ui_page 'ui/index.html'

shared_scripts {
	'@ox_lib/init.lua',
    'config.lua',
	'@kk-core/imports.lua',
} 

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    -- '@kk-core/locale.lua',
    -- 'locales/en.lua',
    'server/*.lua'
}

client_scripts {
    -- '@kk-core/locale.lua',
    -- 'locales/en.lua',
    'client/*.lua'
}

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}

lua54 'yes'