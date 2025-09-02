fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Kakarot'
description 'Provides police tools, evidence, job and more functionality for players to use as a cop'
version '1.3.5'

shared_scripts {
	'config.lua',
	'@qb-core/shared/locale.lua',
	'locales/en.lua',
	'locales/*.lua',
	'@ox_lib/init.lua'
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
	'client/main.lua',
	'client/camera.lua',
	'client/interactions.lua',
	'client/job.lua',
	'client/heli.lua',
	'client/anpr.lua',
	'client/evidence.lua',
	'client/objects.lua',
	'client/tracker.lua',
	'cl_khaza/shop.lua',
	--'cl_khaza/surveillance.lua',
	'cl_khaza/spikes.lua',
	'cl_khaza/interactions.lua',
	'cl_khaza/anklet.lua',
	'cl_khaza/search.lua',
	'cl_khaza/mugshot.lua',
	'cl_khaza/photo.lua',
	'cl_khaza/fingerprint.lua',
	'cl_khaza/detention.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
	'server/commands.lua',
	'server/interactions.lua',
	'server/evidence.lua',
	'server/objects.lua',
	'server/vehicle.lua',
	'sv_khaza/shop.lua',
	'sv_khaza/spikes.lua',
	'sv_khaza/anklet.lua',
	'sv_khaza/search.lua',
	'sv_khaza/mugshot.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/vue.min.js',
	'html/script.js',
	'html/tablet-frame.png',
	'html/fingerprint.png',
	'html/main.css',
	'html/vcr-ocd.ttf'
}

dependencies {
	'ox_lib',
	'ox_inventory'
}