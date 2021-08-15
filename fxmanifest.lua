fx_version 'cerulean'
game 'gta5'

author 'GTScript discord.gg/fivem-script'
description 'ESX PaintBall With New UI'
version '1.0.0'

ui_page "html/index.html"

files {
	'html/index.html',
	'html/assets/css/style.css',
	'html/assets/imgs/*.jpg',	
	'html/assets/imgs/*.png',					
	'html/assets/js/script.js',
	'html/assets/weapons/*.png'
}
shared_script 'config.lua'

client_scripts {
    'client.lua'
}
server_scripts {
	'@mysql-async/lib/MySQL.lua',
    'server.lua'
}
