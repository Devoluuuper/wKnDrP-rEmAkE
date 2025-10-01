cfg = {}

cfg.pedMessage = 'Tervist, nagu näen siis olete huvitatud GoPostali töökohast. Tööotsa vastu võttes vastutate ajalehtede kui ka töösõiduki eest. Teile on määratud ajalehepunktide ala, kust tuleb kontrollida ja vajadusel lisada ajalehti. Ajalehepakid leiad auto tagant. Kui vajate abi, võid kutsuda appi mõne kolleegi ja teenida natukene kiiremini töötasu. NB! Tööks on vajalik, et oled ennast riietanud korrektselt ja kannad GoPostali mütsi. Töö sõidukit on võimalik minu käest küsida ja see toimetatakse sinu seljataha olevasse parklasse.'
cfg.ped = vec4(-258.574615, -841.556274, 31.421310,125.34102630615)
cfg.prize = math.random(30, 50)

cfg.models = {
    joaat('prop_news_disp_06a'),
    joaat('prop_news_disp_05a'),
    joaat('prop_news_disp_03c'),
    joaat('prop_news_disp_03a'),
    joaat('prop_news_disp_02e'),
    joaat('prop_news_disp_02d'),
    joaat('prop_news_disp_02c'),
    joaat('prop_news_disp_02b'),
    joaat('prop_news_disp_02a_s'),
    joaat('prop_news_disp_02a'),
    joaat('prop_news_disp_01a'),
    joaat('prop_postbox_01a')
}

cfg.zones = {
    {
        id = {'MORN','RICHM','ROCKF','DELPE','MOVIE'},
        label = 'Del Perro',
        points = {min = 2, max = 4},
		coords = vec2(-1475.60, -371.23)
    },
    {
        id = {'ROCKF','MORN','RICHM','DELPE','MOVIE'},
        label = 'Rockford Hills',
		points = {min = 2, max = 4},
		coords = vec2(-1237.30, -347.55)
    },
    {
        id = {'KOREAT','VCANA'},
        label = 'Little Seoul',
		points = {min = 2, max = 4},
		coords = vec2(-724.28, -858.76)
    },
    {
        id = {'PBOX','LEGSQU','SKID'},
        label = 'Pillbox Hill',
		points = {min = 2, max = 4},
		coords = vec2(29.68, -851.88)
    },
    {
        id = {'SKID','TEXTI','LEGSQU','PBOX'},
        label = 'Mission Row',
		points = {min = 2, max = 4},
		coords = vec2(230.28, -863.27)
    },
    {
        id = {'DAVIS','STRAW','RANCHO','CHAMH'},
        label = 'Davis',
		points = {min = 2, max = 4},
		coords = vec2(192.27, -1538.78)
    },
    {
        id = {'HAWICK','ALTA','DTVINE'},
        label = 'Hawick',
		points = {min = 2, max = 4},
		coords = vec2(284.46, -145.48)
    },
    {
        id = {'HAWICK','ALTA','DTVINE'},
        label = 'Dowtown Vinewood',
		points = {min = 2, max = 4},
		coords = vec2(345.11, 2.94)
    },
}

cfg.vehicles = {
    { x = -289.1604309082, y = -887.53845214844, z = 30.981689453125, h = 167.24407958984},
    { x = -285.61318969727, y = -888.42199707031, z = 30.981689453125, h = 170.07873535156},
    { x = -292.85275268555, y = -886.89233398438, z = 30.981689453125, h = 164.4094543457},
    { x = -296.9274597168, y = -886.0087890625, z = 30.981689453125, h = 167.24407958984},
    { x = -300.15823364258, y = -885.12524414063, z = 30.981689453125, h = 167.24407958984},
    { x = -304.16702270508, y = -884.59777832031, z = 30.981689453125, h = 167.24407958984},
    { x = -307.49011230469, y = -883.81976318359, z = 30.981689453125, h = 167.24407958984},
    { x = -311.15603637695, y = -882.81756591797, z = 30.981689453125, h = 167.24407958984},
    { x = -314.75604248047, y = -882.26373291016, z = 30.981689453125, h = 164.4094543457},
    { x = -318.26373291016, y = -881.51208496094, z = 30.96484375, h = 167.24407958984},
    { x = -322.21978759766, y = -880.58898925781, z = 30.96484375, h = 167.24407958984},
    { x = -325.81976318359, y = -880.02197265625, z = 30.96484375, h = 164.4094543457},
    { x = -328.85275268555, y = -879.29669189453, z = 30.96484375, h = 167.24407958984},
    { x = -332.9274597168, y = -878.46594238281, z = 30.96484375, h = 167.24407958984},
    { x = -336.30328369141, y = -877.64837646484, z = 30.96484375, h = 167.24407958984},
    { x = -340.12747192383, y = -877.01538085938, z = 30.96484375, h = 167.24407958984},
    { x = -343.93844604492, y = -876.21099853516, z = 30.96484375, h = 167.24407958984}
}
