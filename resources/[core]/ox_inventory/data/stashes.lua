---wip types

---@class OxStash
---@field name string
---@field label string
---@field owner? boolean | string | number
---@field slots number
---@field weight number
---@field groups? string | string[] | { [string]: number }
---@field blip? { id: number, colour: number, scale: number }
---@field coords? vector3
---@field target? { loc: vector3, length: number, width: number, heading: number, minZ: number, maxZ: number, distance: number, debug?: boolean, drawSprite?: boolean }

return {
	{
		coords = vec3(-323.951263, -1039.610352, 27.517338),
		target = {
			coords = vec3(-323.951263, -1039.610352, 27.517338),
			size = vec3(1, 1, 1),
			rotation = 0.0,
			label = 'Haigla inventuuri kapp'
		},
		name = 'ems_safe',
		label = 'Fraktsiooni seif - EMS',
		owner = false,
		slots = 200,
		weight = 500000,
		groups = {['ambulance'] = 0}
	},
	
	{
		coords = vec3(-303.388184, -1053.928955, 27.455853),
		target = {
			coords = vec3(-303.388184, -1053.928955, 27.455853),
			size = vec3(1, 1, 1),
			rotation = 338.5,
			label = 'Isiklik meditsiinikott'
		},
		name = 'ems_personal_safe',
		label = 'Personaalne seif - Kiirabi',
		owner = true,
		slots = 25,
		weight = 100000,
		groups = {['ambulance'] = 0}
	},

	{
		coords = vec3(149.3, -3014.0, 6.5),
		target = {
			coords = vec3(149.3, -3014.0, 6.5),
			size = vec3(2.0, 0.6, 0.8),
			rotation = 0.0,
			label = 'Alkoholikülmik'
		},
		name = 'eventure_alcohol',
		label = 'Fraktsiooni alkoholikülmik - Eventure',
		owner = false,
		slots = 50,
		weight = 150000,
		groups = {['eventure'] = 0}
	},
	
	{
		coords = vec3(-324.1, -134.9, 39.0),
		target = {
			coords = vec3(-324.1, -134.9, 39.0),
			size = vec3(1.0, 4.3, 1.3),
			rotation = 341.5,
			label = 'Fraktsiooni seif'
		},
		name = 'bennys_safe',
		label = 'Fraktsiooni seif - LS Customs',
		owner = false,
		slots = 50,
		weight = 100000,
		groups = {['lscustoms'] = 0}
	},

	{
		coords = vec3(-327.5, -131.75, 39.5),
		target = {
			coords = vec3(-327.5, -131.75, 39.5),
			size = vec3(4.5, 1.0, 2.25),
			rotation = 339.0,
			label = 'Suur seif'
		},
		name = 'bennys_parts_safe',
		label = 'Suur seif - LS Customs',
		owner = false,
		slots = 500,
		weight = 5000000,
		groups = {['lscustoms'] = 0}
	},

	{
		coords = vec3(1189.7, 2636.55, 38.0),
		target = {
			coords = vec3(1189.7, 2636.55, 38.0),
			size = vec3(0.75, 1.7, 1),
			rotation = 1.0,
			label = 'Fraktsiooni seif'
		},
		name = 'harmony_safe',
		label = 'Fraktsiooni seif - Harmony',
		owner = false,
		slots = 50,
		weight = 100000,
		groups = {['harmony'] = 0}
	},

	{
		coords = vec3(1172.65, 2634.95, 37.85),
		target = {
			coords = vec3(1172.65, 2634.95, 37.85),
			size = vec3(3.05, 0.8, 1.85),
			rotation = 0.0,
			label = 'Suur seif'
		},
		name = 'harmony_parts_safe',
		label = 'Suur seif - Harmony',
		owner = false,
		slots = 500,
		weight = 5000000,
		groups = {['harmony'] = 0}
	},

	{
		coords = vec3(950.4, -970.55, 39.9),
		target = {
			coords = vec3(759.45, -1300.6, 26.3),
			size = vec3(0.7, 0.65, 2.05),
			rotation = 0.0,
			label = 'Fraktsiooni seif'
		},
		name = 'spade_safe',
		label = 'Fraktsiooni seif - Spade Motors',
		owner = false,
		slots = 50,
		weight = 100000,
		groups = {['spade'] = 0}
	},

	{
		coords = vec3(936.25, -985.5, 39.45),
		target = {
			coords = vec3(761.0, -1288.4, 26.75),
			size = vec3(2.9, 1.55, 3.0),
			rotation = 0.0,
			label = 'Suur seif'
		},
		name = 'spade_big_safe',
		label = 'Suur seif - Spade Motors',
		owner = false,
		slots = 500,
		weight = 5000000,
		groups = {['spade'] = 0}
	},

	{
		coords = vec3(461.95, -995.45, 31.05),
		target = {
			coords = vec3(607.9, 9.3, 87.8),
			size = vec3(4.35, 0.8, 2.05),
			rotation = 338.5,
			label = 'Personaalne seif'
		},
		name = 'police_personal_mrpd',
		label = 'Personaalne seif - Police',
		owner = true,
		slots = 25,
		weight = 100000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(486.0, -995.0, 31.15),
		target = {
			coords = vec3(603.45, 7.2, 88.05),
			size = vec3(0.45, 3.05, 2.5),
			rotation = 340.0,
			label = 'Fraktsiooni seif'
		},
		name = 'police_safe_mrpd',
		label = 'Fraktsiooni seif - Police',
		owner = false,
		slots = 500,
		weight = 10000000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(-3153.72, 1134.69, 21.35),
		target = {
			coords = vec3(-3153.72, 1134.69, 21.35),
			size = vec3(0.3, 2.7, 2.65),
			rotation = 335.0,
			label = 'Personaalne seif'
		},
		name = 'police_personal_lamesa',
		label = 'Personaalne seif - Police',
		owner = true,
		slots = 25,
		weight = 100000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(-3172.28, 1121.96, 21.7),
		target = {
			coords = vec3(-3172.28, 1121.96, 21.7),
			size = vec3(1.7, 1, 3.3),
			rotation = 335.0,		
			label = 'Fraktsiooni seif'
		},
		name = 'police_safe_lamesa',
		label = 'Fraktsiooni seif - Police',
		owner = false,
		slots = 500,
		weight = 10000000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(369.1, -1607.25, 29.45),
		target = {
			coords = vec3(369.1, -1607.25, 29.45),
			size = vec3(1, 0.3, 1),
			rotation = 50.0,
			label = 'Personaalne seif'
		},
		name = 'police_personal_davis',
		label = 'Personaalne seif - Police',
		owner = true,
		slots = 25,
		weight = 100000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(387.3, 800.2, 187.5),
		target = {
			coords = vec3(387.3, 800.2, 187.5),
			size = vec3(2.6, 0.5, 2.2),
			rotation = 0.0,
			label = 'Personaalne seif'
		},
		name = 'police_personal_saspr',
		label = 'Personaalne seif - Police',
		owner = true,
		slots = 25,
		weight = 100000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(1067.0, 2724.2, 38.85),
		target = {
			coords = vec3(1067.0, 2724.2, 38.85),
			size = vec3(1.5, 0.45, 2.4),
			rotation = 0.0,
			label = 'Fraktsiooni seif'
		},
		name = 'police_safe_sandy',
		label = 'Fraktsiooni seif - Police',
		owner = false,
		slots = 500,
		weight = 10000000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(1069.2, 2732.1, 38.7),
		target = {
			coords = vec3(1069.2, 2732.1, 38.7),
			size = vec3(0.5, 1.2, 2.2),
			rotation = 0.0,
			label = 'Personaalne seif'
		},
		name = 'police_personal_sandy',
		label = 'Personaalne seif - Police',
		owner = true,
		slots = 25,
		weight = 100000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(1844.3, 2573.65, 46.3),
		target = {
			coords = vec3(1844.3, 2573.65, 46.3),
			size = vec3(1.6, 0.65, 2.65),
			rotation = 0.0,
			label = 'Fraktsiooni seif'
		},
		name = 'police_safe_prison',
		label = 'Fraktsiooni seif - Prison',
		owner = false,
		slots = 500,
		weight = 10000000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(1843.2, 2573.45, 46.0),
		target = {
			coords = vec3(1843.2, 2573.45, 46.0),
			size = vec3(0.65, 0.7, 1.95),
			rotation = 0.0,
			label = 'Personaalne seif'
		},
		name = 'police_personal_prison',
		label = 'Personaalne seif - Prison',
		owner = true,
		slots = 25,
		weight = 100000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(128.65, -3014.6, 7.25),
		target = {
			coords = vec3(128.65, -3014.6, 7.25),
			size = vec3(2.45, 1.45, 2.5),
			rotation = 0.0,
			label = 'Suur seif'
		},
		name = 'eventure_parts_safe',
		label = 'Suur seif - Eventure',
		owner = false,
		slots = 500,
		weight = 10000000,
		groups = {['eventure'] = 0}
	},

	{
		coords = vec3(90.3, 9.3, 68.3),
		target = {
			coords = vec3(90.3, 9.3, 68.3),
			size = vec3(1.9, 0.55, 1.6),
			rotation = 70.75,
			label = 'Riiul'
		},
		name = 'aldente_safe',
		label = 'AlDente Riiul',
		owner = false,
		slots = 500,
		weight = 10000000,
		groups = {['aldente'] = 0}
	},

	{
		coords = vec3(4902.95, -4942.55, 2.75),
		target = {
			coords = vec3(4902.95, -4942.55, 2.75),
			size = vec3(1.75, 0.25, 1.0),
			rotation = 39.0,
			label = 'Suur külmik'
		},
		name = 'eventure_fridge_big_1',
		label = 'Suur külmik - Eventure',
		owner = false,
		slots = 500,
		weight = 5000000,
		groups = {['eventure'] = 0}
	},

	{
		coords = vec3(4905.75, -4940.75, 2.85),
		target = {
			coords = vec3(4905.75, -4940.75, 2.85),
			size = vec3(1.75, 0.30000000000001, 1.0),
			rotation = 24.75,
			label = 'Suur külmik'
		},
		name = 'eventure_fridge_big_2',
		label = 'Suur külmik - Eventure',
		owner = false,
		slots = 500,
		weight = 5000000,
		groups = {['eventure'] = 0}
	},

	{
		coords = vec3(-2039.1, -477.05, 11.5),
		target = {
			coords = vec3(-2039.1, -477.05, 11.5),
			size = vec3(0.6, 3.15, 1.55),
			rotation = 50.75,
			label = 'Fraktsiooni seif'
		},
		name = 'taxi_safe',
		label = 'Fraktsiooni seif - Takso',
		owner = false,
		slots = 100,
		weight = 200000,
		groups = {['taxi'] = 0}
	},

	{
		coords = vec3(-2026.1, -481.5, 11.85),
		target = {
			coords = vec3(-2026.1, -481.5, 11.85),
			size = vec3(2.75, 0.55, 2.1),
			rotation = 320.25,
			label = 'Fraktsiooni võtmed'
		},
		name = 'taxi_keys',
		label = 'Fraktsiooni võtmed - Takso',
		owner = false,
		slots = 100,
		weight = 50000,
		groups = {['taxi'] = 0},
		permission = 'function13'
	},

	{
		coords = vec3(123.6, -3007.8, 7.65),
		target = {
			coords = vec3(123.6, -3007.8, 7.65),
			size = vec3(0.2, 0.5, 0.35),
			rotation = 0.0,
			label = 'Fraktsiooni võtmed'
		},
		name = 'eventure_keys',
		label = 'Fraktsiooni võtmed - Eventure',
		owner = false,
		slots = 100,
		weight = 50000,
		groups = {['eventure'] = 0},
		permission = 'function13'
	},

	{
		coords = vec3(127.05, -760.65, 242.15),
		target = {
			coords = vec3(127.05, -760.65, 242.15),
			size = vec3(2.55, 0.6, 2.05),
			rotation = 340.75,
			label = 'Personaalne seif'
		},
		name = 'police_personal_fib',
		label = 'Personaalne seif - Police',
		owner = true,
		slots = 25,
		weight = 100000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(142.0, -756.75, 242.25),
		target = {
			coords = vec3(142.0, -756.75, 242.25),
			size = vec3(1.0, 2.75, 2.25),
			rotation = 339.0,
			label = 'Fraktsiooni seif'
		},
		name = 'police_safe_fib',
		label = 'Fraktsiooni seif - Police',
		owner = false,
		slots = 500,
		weight = 10000000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(377.8, 800.2, 190.1),
		target = {
			coords = vec3(377.8, 800.2, 190.1),
			size = vec3(1.7, 0.7, 1.3),
			rotation = 0.0,
			label = 'Fraktsiooni seif'
		},
		name = 'police_safe_park',
		label = 'Fraktsiooni seif - Police',
		owner = false,
		slots = 500,
		weight = 10000000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(2527.1, -342.35, 102.05),
		target = {
			coords = vec3(2527.1, -342.35, 102.05),
			size = vec3(2.85, 0.55, 2.35),
			rotation = 45.0,
			label = 'MTI seif'
		},
		name = 'police_safe_mti',
		label = 'Fraktsiooni seif - Police',
		owner = false,
		slots = 500,
		weight = 10000000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(2512.5, -345.2, 102.0),
		target = {
			coords = vec3(2512.5, -345.2, 102.0),
			size = vec3(0.55, 3.25, 2.25),
			rotation = 44.75,
			label = 'Personaalne seif'
		},
		name = 'police_personal_fib',
		label = 'Personaalne seif - Police',
		owner = true,
		slots = 25,
		weight = 100000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(242.75, -3159.25, 3.0),
		target = {
			coords = vec3(242.75, -3159.25, 3.0),
			size = vec3(1, 1, 1),
			rotation = 0.0,
			label = 'Klubi VIP laud'
		},
		name = 'club_VIP_laud',
		label = 'Kohvilaud - Club VIP',
		owner = true,
		slots = 25,
		weight = 150000,
	},

	{
		coords = vec3(256.0, -3185.2, 3.0),
		target = {
			coords = vec3(256.0, -3185.2, 3.0),
			size = vec3(0.5, 0.35, 0.8),
			rotation = 0.0,
			label = 'VIP Alkoholikülmik'
		},
		name = 'club_VIP_kylmik',
		label = 'Alkokülmik - Club VIP',
		owner = true,
		slots = 25,
		weight = 150000,
	},

	{
		coords = vec3(237.5, -3166.0, -0.5),
		target = {
			coords = vec3(237.5, -3166.0, -0.5),
			size = vec3(0.5, 0.35, 0.8),
			rotation = 0.0,
			label = 'Klubi tavalaud #1'
		},
		name = 'club_tavalaud_01',
		label = 'Klubi tavalaud #1',
		owner = true,
		slots = 25,
		weight = 7500,
	},

	{
		coords = vec3(237.6, -3170.45, -0.5),
		target = {
			coords = vec3(237.6, -3170.45, -0.5),
			size = vec3(0.5, 0.35, 0.8),
			rotation = 0.0,
			label = 'Klubi tavalaud #2'
		},
		name = 'club_tavalaud_02',
		label = 'Klubi tavalaud #2',
		owner = true,
		slots = 25,
		weight = 7500,
	},

	{
		coords = vec3(237.5, -3183.05, -0.5),
		target = {
			coords = vec3(237.5, -3183.05, -0.5),
			size = vec3(0.5, 0.35, 0.8),
			rotation = 0.0,
			label = 'Klubi tavalaud #3'
		},
		name = 'club_tavalaud_03',
		label = 'Klubi tavalaud #3',
		owner = true,
		slots = 25,
		weight = 7500,
	},

	{
		coords = vec3(237.55, -3187.6, -0.5),
		target = {
			coords = vec3(237.55, -3187.6, -0.5),
			size = vec3(0.5, 0.35, 0.8),
			rotation = 0.0,
			label = 'Klubi tavalaud #4'
		},
		name = 'club_tavalaud_04',
		label = 'Klubi tavalaud #4',
		owner = true,
		slots = 25,
		weight = 7500,
	},

	{
		coords = vec3(255.85, -3182.5, -0.5),
		target = {
			coords = vec3(255.85, -3182.5, -0.5),
			size = vec3(0.5, 0.35, 0.8),
			rotation = 0.0,
			label = 'Klubi tavalaud #5'
		},
		name = 'club_tavalaud_05',
		label = 'Klubi tavalaud #5',
		owner = true,
		slots = 25,
		weight = 7500,
	},

	{
		coords = vec3(255.9, -3177.95, -0.5),
		target = {
			coords = vec3(255.9, -3177.95, -0.5),
			size = vec3(0.5, 0.35, 0.8),
			rotation = 0.0,
			label = 'Klubi tavalaud #6'
		},
		name = 'club_tavalaud_06',
		label = 'Klubi tavalaud #6',
		owner = true,
		slots = 25,
		weight = 7500,
	},

	{
		coords = vec3(258.75, -3159.25, 0.0),
		target = {
			coords = vec3(258.75, -3159.25, 0.0),
			size = vec3(0.5, 0.4, 0.8),
			rotation = 0.0,
			label = 'Klubi laoruum'
		},
		name = 'club_bigsafe',
		label = 'Klubi laoruum',
		owner = false,
		slots = 500,
		weight = 500000,
		groups = {['eventure'] = 0}
	},

	{
		coords = vec3(249.75, -3160.75, -0.3),
		target = {
			coords = vec3(249.75, -3160.75, -0.3),
			size = vec3(0.5, 0.4, 0.8),
			rotation = 1.75,
			label = 'Klubi Alkokülmik'
		},
		name = 'club_leti_alkokapp',
		label = 'Klubi Alkokülmik',
		owner = false,
		slots = 500,
		weight = 500000,
		groups = {['eventure'] = 0}
	},

	{
		coords = vec3(245.6, -3160.3, -0.2),
		target = {
			coords = vec3(245.6, -3160.3, -0.2),
			size = vec3(0.5, 0.4, 0.8),
			rotation = 336.5,
			label = 'Klubi Toidukapp'
		},
		name = 'club_leti_toidukapp',
		label = 'Klubi Toidukapp',
		owner = false,
		slots = 500,
		weight = 500000,
		groups = {['eventure'] = 0}
	},

	{
		coords = vec3(250.095657, -3162.669189, -0.148843),
		target = {
			coords = vec3(250.095657, -3162.669189, -0.148843),
			size = vec3(0.5, 0.35, 0.8),
			rotation = 0.0,
			label = 'Klubi letilaud'
		},
		name = 'club_kassatray_01',
		label = 'Klubi letilaud #1',
		owner = true,
		slots = 25,
		weight = 7500,
	},

	{
		coords = vec3(243.505310, -3160.956787, -0.148843),
		target = {
			coords = vec3(243.505310, -3160.956787, -0.148843),
			size = vec3(0.5, 0.35, 0.8),
			rotation = 0.0,
			label = 'Klubi letilaud'
		},
		name = 'club_kassatray_02',
		label = 'Klubi letilaud #2',
		owner = true,
		slots = 25,
		weight = 7500,
	},

}