cfg = {}

cfg.pedMessage = 'Tervist, nagu näen siis olete huvitatud prügivedaja töökohast. Tööotsa vastu võttes vastutate kogu prügi kogumise eest, mille tsiviilisikud konteineritesse jätavad. Teile on määratud korjamis ala kust tuleb otsida prügikaste ja tühjendada need töösõidukisse. Töösõiduki täitudes tuleb viia kogutud prügi jäätmejaama. Kui vajate abi, võid kutsuda appi mõne kolleegi ja teenida natukene kiiremini töötasu. NB! Tööks on vajalik, et oled ennast riietanud korrektselt ja kannad helkurvesti. Töö sõidukit on võimalik minu käest küsida.'
cfg.ped = vec4(-355.16, -1513.39, 27.72, 172.92)
cfg.delivery = {
	coords = vec3(-352.25, -1560.5, 26.75),
	size = vec3(12.5, 6.45, 5.15),
	rotation = 15.0,
}

cfg.specialItem = {
    count = 20,
    name = 'spray'
}

cfg.prize = math.random(30, 50)

cfg.models = {
    joaat('prop_dumpster_01a'),
    joaat('prop_dumpster_02a'),
    joaat('prop_dumpster_01b'),
    joaat('prop_dumpster_3a'),
    joaat('prop_dumpster_4a'),
    joaat('prop_dumpster_4b'),
    joaat('prop_bin_14b'),
    joaat('prop_bin_08a'),
    joaat('prop_bin_05a'),
    joaat('prop_bin_07c'),
    joaat('prop_recyclebin_02_c'),
    joaat('prop_recyclebin_02b'),
    joaat('prop_recyclebin_02_d'),
    joaat('prop_recyclebin_02a'),
    joaat('prop_bin_02a'),
    joaat('prop_bin_03a'),
    joaat('prop_bin_06a'),
    joaat('prop_bin_08open'),
    joaat('prop_bin_12a'),
    joaat('prop_cs_bin_01'),
    joaat('prop_cs_bin_01_skinned'),
    joaat('prop_cs_bin_02'),
    joaat('prop_cs_bin_03'),
    joaat('prop_snow_bin_02'),
    joaat('prop_snow_bin_01'),
    joaat('zprop_bin_01a_old'),
    joaat('p_dumpster_t'),
    joaat('prop_cs_dumpster_01a'),
    joaat('prop_dumpster_02b')
}

cfg.zones = {
    {
        id = {'MORN','RICHM','GOLF','ROCKF'},
        label = 'Morningwood',
        bins = {min = 5, max = 15},
		coords = vec2(-1304.98, -47.20)
    },
    {
        id = {'ROCKF','WVINE','BURTON','GOLF'},
        label = 'Rockford Hills',
		bins = {min = 5, max = 15},
		coords = vec2(-883.87, -160.13)
    },
    {
        id = {'DTVINE','ALTA','HAWICK','WVINE'},
        label = 'Downtown Vinewood',
		bins = {min = 5, max = 15},
		coords = vec2(332.44, 53.45)
    },
    {
        id = {'EAST_V','MIRR'},
        label = 'Mirror Park',
		bins = {min = 5, max = 15},
		coords = vec2(1074.40, -432.36)
    },
    {
        id = {'MURRI','LMESA','EBURO'},
        label = 'La Mesa',
		bins = {min = 5, max = 15},
		coords = vec2(996.57, -1338.44)
    },
    {
        id = {'SANAND','MURRI','EBURO','LMESA','CYPRE'},
        label = 'El Burro Heights',
		bins = {min = 5, max = 15},
		coords = vec2(1134.88, -1740.69)
    },
    {
        id = {'STRAW','DAVIS','RANCHO'},
        label = 'Davis',
		bins = {min = 5, max = 15},
		coords = vec2(291.19, -1654.64)
    },
	{
        id = {'PBOX','TEXTI','LEGSQU','SKID','DOWNT'},
        label = 'Pillbox Hill',
		bins = {min = 5, max = 15},
		coords = vec2(182.15, -850.29)
    },
	{
        id = {'KOREAT','VCANA'},
        label = 'Little Seoul',
		bins = {min = 5, max = 15},
		coords = vec2(-787.15, -847.53)
    },
	{
        id = {'MOVIE','VCANA','VESP','SANAND','DELPE','BEACH'},
        label = 'Del Perro',
		bins = {min = 5, max = 15},
		coords = vec2(-1370.17, -784.79)
    },
}

cfg.vehicles = {
    { x = -333.70550537109, y = -1527.8901367188, z = 27.274780273438, h = 0.0},
    { x = -330.64614868164, y = -1527.8901367188, z = 27.240966796875, h = 0.0},
    { x = -327.61318969727, y = -1527.9165039063, z = 27.240966796875, h = 0.0},
    { x = -324.58020019531, y = -1527.7846679688, z = 27.240966796875, h = 0.0},
    { x = -329.32745361328, y = -1518.9626464844, z = 27.240966796875, h = 181.41732788086},
    { x = -325.93844604492, y = -1519.1999511719, z = 27.240966796875, h = 184.25196838379},
    { x = -322.66812133789, y = -1519.2263183594, z = 27.257934570313, h = 181.41732788086},
    { x = -319.58242797852, y = -1519.1999511719, z = 27.257934570313, h = 181.41732788086}
}
