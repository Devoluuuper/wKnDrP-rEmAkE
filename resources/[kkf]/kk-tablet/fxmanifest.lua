fx_version 'cerulean'
game 'gta5'
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
ui_page 'web/index.html'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
    '@kk-core/imports.lua'
} 

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

client_scripts {
    'client/*.lua'
} 

files {
    '@ox_inventory/web/images/**',
    'web/**'
}

lua54 'yes'