Config = {}
Config.ShowUnlockedText = true
Config.CheckVersion = true
Config.CheckVersionDelay = 60 -- Minutes

Config.DoorList = {}

-- Prison1
table.insert(Config.DoorList, {
	lockpick = false,
	fixText = true,
	dutyRequired = true,
	garage = false,
	authorizedJobs = { ['police']=0, ['ambulance']=0 },
	maxDistance = 6.0,
	audioRemote = false,
	objHash = 741314661,
	objCoords = vector3(1844.998, 2604.813, 44.63978),
	locked = true,
	slides = true,
	objHeading = 90.0,		
	audioRemote = true,
	audioLock = {['file'] = 'garage-close.ogg', ['volume'] = 0.7},
	audioUnlock = {['file'] = 'garage-open.ogg', ['volume'] = 0.7},
})

-- PrincipalBank
table.insert(Config.DoorList, {
	garage = false,
	fixText = true,
	authorizedJobs = { ['police']=0 },
	maxDistance = 1.0,
	dutyRequired = true,
	objHeading = 250.00003051758,
	locked = true,
	lockpick = false,
	audioRemote = false,
	slides = false,
	objCoords = vector3(262.1981, 222.5188, 106.4296),
	objHash = 746855201,		
	audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
	audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
})

-- outside next to single
table.insert(Config.DoorList, {
	dutyRequired = false,
	fixText = true,
	objHash = -2023754432,
	maxDistance = 2.0,
	objCoords = vector3(895.2413, -144.8651, 77.04504),
	garage = false,
	slides = false,
	lockpick = false,
	audioRemote = false,
	locked = true,
	objHeading = 328.84948730469,
	authorizedJobs = { ['taxi']=0 },
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})


-- outside garage
table.insert(Config.DoorList, {
	dutyRequired = false,
	objCoords = vector3(900.0851, -147.8304, 77.32047),
	locked = true,
	authorizedJobs = { ['taxi']=0 },
	lockpick = false,
	fixText = true,
	objHash = 2064385778,
	audioRemote = false,
	objHeading = 147.9923248291,
	maxDistance = 6.0,
	slides = 6.0,
	garage = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- outside double
table.insert(Config.DoorList, {
	dutyRequired = false,
	doors = {
		{objHash = -2023754432, objHeading = 58.631664276123, objCoords = vector3(893.7596, -180.4167, 74.85624)},
		{objHash = -2023754432, objHeading = 238.01802062988, objCoords = vector3(895.1225, -178.2061, 74.85624)}
 },
	authorizedJobs = { ['taxi']=0 },
	lockpick = false,
	locked = true,
	audioRemote = false,
	slides = false,
	maxDistance = 2.5,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- outside main
table.insert(Config.DoorList, {
	dutyRequired = false,
	slides = false,
	lockpick = false,
	locked = false,
	audioRemote = false,
	maxDistance = 2.5,
	authorizedJobs = { ['taxi']=0 },
	doors = {
		{objHash = 1519319655, objHeading = 238.3483581543, objCoords = vector3(906.6433, -161.5644, 74.54778)},
		{objHash = 1519319655, objHeading = 58.205558776855, objCoords = vector3(908.1147, -159.1847, 74.54778)}
 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- inside double
table.insert(Config.DoorList, {
	dutyRequired = true,
	locked = true,
	maxDistance = 2.5,
	authorizedJobs = { ['taxi']=0 },
	lockpick = false,
	doors = {
		{objHash = -2023754432, objHeading = 327.72305297852, objCoords = vector3(898.5289, -163.3064, 74.33624)},
		{objHash = -2023754432, objHeading = 147.98602294922, objCoords = vector3(900.7323, -164.6911, 74.33624)}
 },
	slides = false,
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- inside single
table.insert(Config.DoorList, {
	dutyRequired = false,
	locked = true,
	objCoords = vector3(903.5715, -152.1612, 74.33624),
	lockpick = false,
	objHash = -2023754432,
	maxDistance = 2.0,
	authorizedJobs = { ['taxi']=0 },
	audioRemote = false,
	fixText = true,
	objHeading = 327.72305297852,
	garage = false,
	slides = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- inside single
table.insert(Config.DoorList, {
	dutyRequired = true,
	locked = true,
	objCoords = vector3(895.8756, -161.0501, 77.0637),
	lockpick = false,
	objHash = -2023754432,
	maxDistance = 2.0,
	authorizedJobs = { ['taxi']=0 },
	audioRemote = false,
	fixText = true,
	objHeading = 58.010314941406,
	garage = false,
	slides = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- inside single
table.insert(Config.DoorList, {
	dutyRequired = true,
	audioRemote = false,
	locked = true,
	fixText = true,
	lockpick = false,
	objCoords = vector3(890.2437, -169.8149, 77.0637),
	objHeading = 238.02786254883,
	slides = false,
	authorizedJobs = { ['taxi']=0 },
	garage = false,
	maxDistance = 2.0,
	objHash = -2023754432,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Riided1
table.insert(Config.DoorList, {
	audioRemote = false,
	fixText = false,
	lockpick = false,
	maxDistance = 2.0,
	garage = false,
	authorizedJobs = { ['properties']=0 },
	objHeading = 95.999954223633,
	dutyRequired = true,
	objCoords = vector3(-133.9599, -630.6448, 168.9704),
	slides = false,
	locked = true,
	objHash = -240975975,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Riided2
table.insert(Config.DoorList, {
	slides = false,
	lockpick = false,
	authorizedJobs = { ['properties']=0 },
	maxDistance = 2.0,
	locked = true,
	audioRemote = false,
	dutyRequired = true,
	fixText = false,
	objHeading = 185.99998474121,
	garage = false,
	objCoords = vector3(-132.1241, -637.5084, 168.9704),
	objHash = -240975975,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- akuma
table.insert(Config.DoorList, {
	dutyRequired = false,
	maxDistance = 2.0,
	slides = false,
	lockpick = false,
	objHeading = 355.00003051758,
	audioRemote = false,
	objHash = 1289778077,
	objCoords = vector3(-568.881, 281.1112, 83.12643),
	fixText = false,
	garage = false,
	locked = true,
	authorizedJobs = { ['akuma']=0 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- akuma3
table.insert(Config.DoorList, {
	dutyRequired = false,
	maxDistance = 2.0,
	slides = false,
	lockpick = false,
	objHeading = 265.00006103516,
	audioRemote = false,
	objHash = -626684119,
	objCoords = vector3(-569.7971, 293.7701, 79.3264),
	fixText = false,
	garage = false,
	locked = true,
	authorizedJobs = { ['akuma']=0 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- akuma4
table.insert(Config.DoorList, {
	dutyRequired = false,
	maxDistance = 3.0,
	slides = false,
	lockpick = false,
	objHeading = 175.00003051758,
	audioRemote = false,
	objHash = 993120320,
	objCoords = vector3(-561.2866, 293.5044, 87.77851),
	fixText = false,
	garage = false,
	locked = true,
	authorizedJobs = { ['akuma']=0 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- akuma5
table.insert(Config.DoorList, {
	dutyRequired = false,
	maxDistance = 2.0,
	slides = false,
	lockpick = false,
	objHeading = 175.00003051758,
	audioRemote = false,
	objHash = 757543979,
	objCoords = vector3(-567.9351, 291.9264, 85.52499),
	fixText = false,
	garage = false,
	locked = true,
	authorizedJobs = { ['akuma']=0 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Akuunma
table.insert(Config.DoorList, {
	dutyRequired = false,
	objHash = -626684119,
	maxDistance = 2.0,
	locked = true,
	lockpick = false,
	garage = false,
	audioRemote = false,
	slides = false,
	objHeading = 265.00006103516,
	fixText = false,
	objCoords = vector3(-560.2373, 293.0106, 82.32609),
	authorizedJobs = { ['akuma']=0 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- camo
table.insert(Config.DoorList, {
	dutyRequired = false,
	locked = true,
	maxDistance = 2.0,
	lockpick = false,
	garage = false,
	authorizedJobs = { ['camo']=0 },
	objHash = 1413743677,
	fixText = false,
	objCoords = vector3(2435.429, 4975.025, 46.90218),
	objHeading = 224.99993896484,
	slides = false,
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- camo2
table.insert(Config.DoorList, {
	dutyRequired = false,
	locked = true,
	maxDistance = 2.0,
	lockpick = false,
	garage = false,
	authorizedJobs = { ['camo']=0 },
	objHash = 1413743677,
	fixText = false,
	objCoords = vector3(2441.017, 4981.73, 46.90218),
	objHeading = 314.99993896484,
	slides = false,
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- camo3
table.insert(Config.DoorList, {
	dutyRequired = false,
	locked = true,
	maxDistance = 2.0,
	lockpick = false,
	garage = false,
	authorizedJobs = { ['camo']=0 },
	objHash = 1413743677,
	fixText = false,
	objCoords = vector3(2448.641, 4988.778, 46.90218),
	objHeading = 224.99993896484,
	slides = false,
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- camo4
table.insert(Config.DoorList, {
	dutyRequired = false,
	locked = true,
	maxDistance = 2.0,
	lockpick = false,
	garage = false,
	authorizedJobs = { ['camo']=0 },
	objHash = 1413743677,
	fixText = false,
	objCoords = vector3(2453.184, 4969.372, 46.90218),
	objHeading = 314.99993896484,
	slides = false,
	audioRemote = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- BURGERSHOT
-- staffonly uks ees
table.insert(Config.DoorList, {
	fixText = true,
	objHash = GetHashKey('p_bs_map_door_01_s'),
	dutyRequired = false,
	objCoords = vector3(-1179.327, -891.4769, 14.05767),
	locked = true,
	objHeading = 124,
	maxDistance = 2,
	authorizedJobs = {
		['burgershot'] = 0,
	}
})

-- outside double
table.insert(Config.DoorList, {
	dutyRequired = false,
	doors = {
		{objHash = 1800304361, objHeading = 124.02837371826, objCoords = vector3(-1183.207, -885.8312, 14.25113)},--parem
		{objHash = 167687243, objHeading = 124.02837371826, objCoords = vector3(-1184.892, -883.3377, 14.25113)}--vasak
 },
	authorizedJobs = { ['burgershot']=0 },
	lockpick = false,
	locked = false,
	audioRemote = false,
	slides = false,
	maxDistance = 2.5,		
})

-- outside double right
table.insert(Config.DoorList, {
	dutyRequired = false,
	doors = {
		{objHash = 1800304361, objHeading = 214.08651733398, objCoords = vector3(-1196.539, -883.4852, 14.25259)},--parem
		{objHash = 167687243, objHeading = 213.94761657715, objCoords = vector3(-1199.033, -885.1699, 14.25259)}--vasak
 },
	authorizedJobs = { ['burgershot']=0 },
	lockpick = false,
	locked = false,
	audioRemote = false,
	slides = false,
	maxDistance = 2.5,		
})
-- uks kööki
table.insert(Config.DoorList, {
	fixText = true,
	objHash = 233831934,
	dutyRequired = true,
	objCoords = vector3(-1199.728, -892.0408, 14.24617),
	locked = true,
	objHeading = 214,
	maxDistance = 2,
	authorizedJobs = {
		['burgershot'] = 0,
	}
})

-- uks kööki kaks
table.insert(Config.DoorList, {
	fixText = true,
	objHash = 233831934,
	dutyRequired = true,
	objCoords = vector3(-1195.275, -897.9365, 14.24617),
	locked = true,
	objHeading = 123.955,
	maxDistance = 2,
	authorizedJobs = {
		['burgershot'] = 0,
	}
})

