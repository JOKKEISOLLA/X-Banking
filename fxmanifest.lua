fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.0.1'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    --'@es_extended/imports.lua' -- Only if you use old esx!
}

files {
    'locales/*.json'
}

escrow_ignore {
    'client/main_editable.lua',
    'server/main_editable.lua',
    'config.lua',
    'locales/*.json'
}
