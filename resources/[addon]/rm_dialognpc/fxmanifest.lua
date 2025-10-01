fx_version "cerulean"
game "gta5"

lua54 'yes'

shared_script "config.lua"

client_scripts {
    "editable_client.lua",
    "client.lua",
}

ui_page 'ui/dist/index.html'

files {
    "ui/dist/*.html",
    'ui/dist/*.*',
    'ui/dist/assets/*.*',
}

escrow_ignore {
    'client.lua',
    'config.lua',
    'editable_client.lua',
}
dependency '/assetpacks'