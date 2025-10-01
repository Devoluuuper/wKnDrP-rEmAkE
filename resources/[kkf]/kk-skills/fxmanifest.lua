fx_version 'cerulean'
game 'gta5'
author 'SLA'
ui_page 'web/index.html'

shared_scripts {
    '@kk-core/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client.lua'
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

files {
    'web/**'
}

server_exports {
    'GetSkillLevel',
    'AddSkillProgress'
}

exports {
    'GetSkillLevel',
    'AddSkillProgress'
}

lua54 'yes'