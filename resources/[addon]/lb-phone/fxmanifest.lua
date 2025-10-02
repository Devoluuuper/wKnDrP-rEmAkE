fx_version "cerulean"
game "gta5"
lua54 "yes"

version "2.3.7"

shared_script {
    "config/*.lua",
    "shared/**/*.lua"
}

client_script {
    "lib/client/**.lua",
    "client/**.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "lib/server/**.lua",
    "server/**/*.lua",
}

files {
    "ui/dist/**/*",
    "ui/components.js",
    "config/**/*"
}

ui_page "ui/dist/index.html"

dependency "oxmysql"

escrow_ignore {
    "config/**/*",

    "client/apps/framework/**/*.lua",
    "server/apps/framework/**/*.lua",
    "shared/*.lua",

    "client/custom/**/*.lua",
    "server/custom/**/*.lua",

    "client/misc/debug.lua",
    "server/misc/debug.lua",

    "server/misc/functions.lua",
    "server/misc/databaseChecker/*.lua",

    "server/apiKeys.lua",

    "types.lua",

    "client/apps/default/weather.lua",

    "lib/**/*",
}

dependency '/assetpacks'