fx_version 'adamant'
game 'gta5'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua',
    'config.lua'
} 

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',

    '@kk-core/locale.lua',
    'locales/ee.lua',
    'client/*.lua'
} 

server_scripts {
    '@kk-core/locale.lua',
    'locales/ee.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

lua54 'yes'