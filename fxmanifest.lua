fx_version 'cerulean'
game 'rdr3'
description 'Gold Panning Script for RedM'
author 'Your Name'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

-- Dependencies
dependencies {
    'vorp_core',
    'vorp_inventory'
}

-- UI
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/*.png'
}
