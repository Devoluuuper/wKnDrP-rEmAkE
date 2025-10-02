cfg = {}

cfg.snakeCam = {
    MaxLength = 10.0,
    Controls = {
        up = 32,
        down = 33,

        look_up = 172,
        look_down = 173,
        look_left = 174,
        look_right = 175,

        stop_cam = 177
    }
}

cfg.stations = { 
	VHPD = {
		label = 'Vinewood Hills Police Department',
		position = vec3(608.8, 11.6, 87.9),
		
		vehicleActions = vec4(553.95166015625, 6.567033290863, 70.612426757812, 246.61416625977),
		weaponRepair = {
			{
				coords = vec3(606.15, 3.25, 87.35),
				size = vec3(0.85, 2.3, 1.2),
				rotation = 340.0,
			}
		},
		analysis = {
			coords = vec3(447.4065, -974.4924, 31.5743),
			size = vec3(2.4, 0.75, 2.3),
			rotation = 339.75,
		},
		duty = {
			coords = vec3(618.5, 3.95, 87.95),
			size = vec3(1.3, 0.4, 0.85),
			rotation = 340.0,
		}
	},

	SASP = {
		label = 'San Andreas State Police',
		position = vec3(-3151.3, 1133.55, 21.25),

		vehicleActions = vec4(-3153.560546875, 1144.7868652344, 21.040283203125, 5.6692910194397),

		weaponRepair = {
			{
				coords = vec3(-3170.55, 1120.9, 20.7),
				size = vec3(1.9, 0.85, 1.9),
				rotation = 337.0,
			}
		},

		duty = {
			coords = vec3(-3162.65, 1113.85, 20.8),
			size = vec3(1.25, 1.65, 1.35),
			rotation = 335.0,
		}
	},

	SASPR = {
		label = 'San Andreas State Park Rangers',
		position = vec3(387.38900756836, 792.46154785156, 187.68493652344),

		vehicleActions = vec4(396.77801513672, 785.81536865234, 187.44909667969, 198.42520141602),

		duty = {
			coords = vec3(378.5, 796.65, 190.65),
			size = vec3(0.6, 0.3, 0.55000000000001),
			rotation = 0.0,
		}
	},

	Sandy = {
		label = "Sandy Shores Sheriff's Station",
		position = vec3(1061.1032714844, 2721.2307128906, 38.648315429688),

		vehicleActions = vec4(1077.6658935547, 2744.1889648438, 38.665161132812, 181.41732788086),

		weaponRepair = {
			{
				coords = vec3(1068.1, 2727.9, 38.6),
				size = vec3(1.0, 0.55, 0.5),
				rotation = 358.25,
			}
		},

		duty = {
			coords = vec3(1059.7, 2726.7, 38.75),
			size = vec3(0.4, 0.6, 0.6),
			rotation = 0.0,
		}
	},

	Penitentiary = {
		label = 'Bolingbroke Penitentiary',
		position = vec3(1845.7451171875, 2585.736328125, 45.657836914062),

		duty = {
			coords = vec3(1839.5, 2573.6, 46.1),
			size = vec3(1.2, 0.3, 0.6),
			rotation = 355.5,
		}
	},

	FIB = {
		label = "Federal Investigation Bureau",
		position = vec3(370.1, -1589.35, 29.35),
		noBlip = true,

		duty = {
			coords = vec3(126.25, -767.4, 242.1),
			size = vec3(0.9, 0.8, 0.9),
			rotation = 340.25,
		}
	},
}

cfg.gunRanges = {
	--[[{
		target = {
			coords = vec3(-444.05, -309.1, 35.0),
			size = vec3(3.15, 1.05, 2.15),
			rotation = 21.5,
		},

		items = {
			vec4(817.58141113281,-2171.3816894531,29.667030334473,1.4801919460297),

		}
	}]]
}

cfg.cuffAccessory = {
    [`mp_m_freemode_01`] = 303,
    [`mp_f_freemode_01`] = 247,
}

cfg.rangeDifficulties = {
	{
		icon = 'fa-solid fa-face-laugh',
		label = 'Kerge',
		time = 2000
	},

	{
		icon = 'fa-solid fa-face-smile',
		label = 'Keskmine',
		time = 1500
	},

	{
		icon = 'fa-solid fa-face-grimace',
		label = 'Raske',
		time = 1000
	},

	{
		icon = 'fa-solid fa-face-angry',
		label = 'Keeruline',
		time = 800
	}
}

cfg.impoundNpc = vec4(409.31869506836, -1622.9143066406, 29.279907226562, 235.27558898926)
cfg.impoundSpawns = {
	{ x = 410.76922607422, y = -1656.6329345703, z = 29.296752929688, h = 138.89762878418},
	{ x = 408.25054931641, y = -1654.3648681641, z = 29.296752929688, h = 138.89762878418},
	{ x = 405.74505615234, y = -1652.5186767578, z = 29.296752929688, h = 138.89762878418},
	{ x = 403.49011230469, y = -1650.3297119141, z = 29.296752929688, h = 138.89762878418},
	{ x = 400.98461914062, y = -1648.3516845703, z = 29.296752929688, h = 138.89762878418},
	{ x = 398.71649169922, y = -1646.2416992188, z = 29.296752929688, h = 138.89762878418},
	{ x = 396.34286499023, y = -1644.2373046875, z = 29.296752929688, h = 138.89762878418}
}

cfg.tuningItems = {
    {value = 8, label = 'Üksus'},
    {value = 9, label = 'Auaste'}
}

cfg.tuningValues = {
	[8] = {
		[0] = 'Los Santos Police Department',
		[1] = 'Blaine County Sheriff',
		[2] = 'San Andreas State Police',
		[3] = 'San Andreas State Park Rangers'
	},

	[9] = {
		[0] = 'Cadet',
		[1] = 'Officer I',
		[2] = 'Officer II',
		[3] = 'Senior Officer',
		[4] = 'Corporal',
		[5] = 'Sergeant',
		[6] = 'Lieutenant',
		[7] = 'Captain',
		[8] = 'Assistant Chief of Police',
		[9] = 'Chief of Police',
	}
}

cfg.policeItems = {
	['empty_evidence_bag'] = true,
	['armor'] = true,
	['parachute'] = true,
	['handcuffs'] = true,
	['radio'] = true,
	['spray_remover'] = true,
	['spikestrips'] = true,
	['at_flashlight'] = true,
	['at_grip'] = true,
	['at_scope_small'] = true,
	['ammo-airsoft'] = true,
	['ammo-pistol-pd'] = true,
	['ammo-rifle-pd'] = true,
	['ammo-smg-pd'] = true,
	['ammo-rubber'] = true,
	['WEAPON_BEANBAG'] = true,
	['WEAPON_FLASHLIGHT'] = true,
	['at_scope_medium'] = true,
	['WEAPON_NIGHTSTICK'] = true,
	['WEAPON_CARBINERIFLE_MK2'] = true,
	['WEAPON_PISTOL_MK2'] = true,
	['WEAPON_SNSPISTOL_MK2'] = true,
	['WEAPON_REVOLVER_MK2'] = true,
	['WEAPON_SPECIALCARBINE_MK2'] = true,
	['WEAPON_PUMPSHOTGUN_MK2'] = true,
	['WEAPON_HEAVYRIFLE'] = true,
	['WEAPON_SMG'] = true,
	['WEAPON_AIRSOFTM4'] = true,
	['WEAPON_AIRSOFTMP5'] = true,
	['WEAPON_AIRSOFTGLOCK20'] = true,
	['WEAPON_STUNGUN'] = true,
	['prop_roadcone02a'] = true,
	['prop_barrier_work05'] = true,
	['prop_sign_road_01a'] = true,
	['prop_gazebo_03'] = true,
	['prop_worklight_03b'] = true,
	['alcoquant'] = true,
	['WEAPON_PEPPERSPRAY'] = true,
	['WEAPON_ANTIDOTE'] = true,
	['a4'] = true,
	['finger_scanner'] = true,
	['WEAPON_SPEEDRADAR'] = true,
	['badge'] = true,
	['v_ret_gc_bag02'] = true,
}

exports('getWeapons', function()
	return cfg.policeItems
end)