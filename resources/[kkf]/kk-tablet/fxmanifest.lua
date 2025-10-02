fx_version 'cerulean'
game 'gta5'

ui_page 'web/index.html'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
    '@kk-core/imports.lua'
} 

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    -- 'server/*.lua'
    'server/main.lua',
    'server/food.lua',
    'server/selling.lua',

}

client_scripts {
    -- 'client/*.lua',
    'client/main.lua',
    'client/food.lua',
    'client/selling.lua',
} 

files {
    '@ox_inventory/web/images/**',
    'web/**'
}

lua54 'yes'