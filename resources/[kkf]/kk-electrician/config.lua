cfg = {}

cfg.pedMessage = 'Tervist, nagu näen siis olete huvitatud elektrikappide paranduse  töökohast. Tööotsa vastu võttes vastutate tööriistade kui ka töösõiduki eest. Teile on määratud elektrikappide ala, kust tuleb kontrollida ja vajadusel parandada süsteem. Vajalikud tööriistad parandamiseks leiad auto tagant. Kui vajate abi, võid kutsuda appi mõne kolleegi ja teenida natukene kiiremini töötasu. NB! Tööks on vajalik, et oled ennast riietanud korrektselt ja kannad elekrtit isoleerivaid kindaid. Töö sõidukit on võimalik minu käest küsida ja see toimetatakse sinu seljataha.'
cfg.ped = vec4(735.24, 130.99, 80.72, 241.66)
cfg.prize = math.random(30, 50)

cfg.models = {
    joaat('prop_elecbox_01a'),
    joaat('port_xr_elecbox_1'),
    joaat('port_xr_elecbox_2'),
    joaat('port_xr_elecbox_3'),
    joaat('prop_byard_elecbox03'),
    joaat('prop_byard_elecbox04'),
    joaat('prop_elecbox_18'),
    joaat('prop_elecbox_19'),
    joaat('prop_elecbox_20'),
    joaat('prop_elecbox_10'),
    joaat('prop_elecbox_21'),
    joaat('prop_ind_light_01c'),
    joaat('prop_elecbox_23'),
    joaat('prop_elecbox_25'),
    joaat('prop_elecbox_01b'),
    joaat('prop_elecbox_04a'),
    joaat('prop_elecbox_07a'),
    joaat('prop_elecbox_11'),
    joaat('prop_elecbox_13'),
    joaat('prop_elecbox_02a'),
    joaat('prop_elecbox_02b'),
    joaat('prop_elecbox_09'),
    joaat('prop_elecbox_05a'),
    joaat('prop_elecbox_06a')
}

exports('getModels', function()
    return cfg.models
end)

cfg.zones = {
    {
        id = {'EAST_V','MIRR'},
        label = 'East Winewood',
        points = {min = 2, max = 5},
		coords = vec2(888.85,-225.29)
    },
    {
        id = {'MIRR'},
        label = 'Mirror Park',
		points = {min = 2, max = 5},
		coords = vec2(1144.13,-451.15)
    },
    {
        id = {'LMESA','MURRI'},
        label = 'La Mesa',
		points = {min = 2, max = 5},
		coords = vec2(783.00,-1006.27)
    },
    {
        id = {'MURRI','EBURO'},
        label = 'El Burro Heights',
		points = {min = 2, max = 5},
		coords = vec2(1276.14,-1795.11)
    },
    {
        id = {'CYPRE'},
        label = 'Cypress Flats',
		points = {min = 2, max = 5},
		coords = vec2(860.70,-2063.73)
    },
    {
        id = {'RANCHO'},
        label = 'Rancho',
		points = {min = 2, max = 5},
		coords = vec2(454.20,-1819.79)
    },
    {
        id = {'STRAW','DAVIS','RANCHO'},
        label = 'Strawberry',
		points = {min = 2, max = 5},
		coords = vec2(169.21,-1377.73)
    },
	{
        id = {'CHAMH','STRAW'},
        label = 'Chamberlain Hills',
		points = {min = 2, max = 4},
		coords = vec2(-125.34,-1546.65)
    },
	{
        id = {'SKID','TEXTI','LEGSQU'},
        label = 'Mission Row',
		points = {min = 2, max = 5},
		coords = vec2(344.65,-995.32)
    },
	{
        id = {'PBOX'},
        label = 'Pillbox Hill',
		points = {min = 2, max = 5},
		coords = vec2(-147.57,-922.83)
    },
	{
        id = {'KOREAT'},
        label = 'Little Seoul',
		points = {min = 2, max = 5},
		coords = vec2(-640.44,-897.21)
    },
	{
        id = {'VCANA'},
        label = 'Vespucci',
		points = {min = 2, max = 5},
		coords = vec2(-1083.66,-1002.58)
    },
	{
        id = {'DELPE'},
        label = 'Del Perro',
		points = {min = 2, max = 5},
		coords = vec2(-1468.43,-628.58)
    },
	{
        id = {'MORN','ROCKF'},
        label = 'Morningwood',
		points = {min = 2, max = 5},
		coords = vec2(-1353.75,-238.11)
    },
	{
        id = {'RICHM'},
        label = 'Richman',
		points = {min = 2, max = 5},
		coords = vec2(-1543.40,49.18)
    },
	{
        id = {'ROCKF'},
        label = 'Rockford Hills',
		points = {min = 2, max = 5},
		coords = vec2(-919.66,-287.08)
    },
	{
        id = {'WVINE'},
        label = 'West Vinewood',
		points = {min = 2, max = 5},
		coords = vec2(-117.93,174.04)
    },
	{
        id = {'BURTON'},
        label = 'Burton',
		points = {min = 2, max = 5},
		coords = vec2(-414.78,-208.15)
    },
	{
        id = {'DTVINE'},
        label = 'Downtown Vinewood',
		points = {min = 2, max = 5},
		coords = vec2(320.78,161.79)
    },
	{
        id = {'ALTA','HAWICK'},
        label = 'Alta',
		points = {min = 2, max = 5},
		coords = vec2(352.15,-224.56)
    },
}  

cfg.vehicles = {
    { x = 744.54064941406, y = 123.71868133545, z = 79.104736328125, h = 243.77952575684},
    { x = 746.28131103516, y = 127.17362976074, z = 79.104736328125, h = 243.77952575684},
    { x = 747.85052490234, y = 130.20658874512, z = 79.172119140625, h = 243.77952575684},
    { x = 749.57800292969, y = 133.31867980957, z = 79.239501953125, h = 243.77952575684}
}
