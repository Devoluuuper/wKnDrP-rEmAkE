fx_version 'cerulean'
game 'gta5'

description 'Start scratching! Odds Are Meant To Be Beaten'
author 'Dream Resources' -- https://forum.cfx.re/u/xDreamLand/summary
version '3.3.0'
repository 'https://github.com/xDreamLand/dr-scratching'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    '@kk-core/imports.lua',
    'config.lua',
}

server_scripts {
    'server/s_main.lua',
}

client_scripts {
    'client/c_main.lua',
    'client/c_nui.lua',
}

ui_page "html/index.html"

files {
    'html/index.html',
    'html/js/*.js',
    'html/css/*.css',
    'html/img/*.png',
    'html/img/*.jpg'
}
