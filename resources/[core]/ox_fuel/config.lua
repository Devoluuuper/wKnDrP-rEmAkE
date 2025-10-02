Config = {
	-- Get notified when a new version releases
	versionCheck = true,

	-- Enable support for qTarget
	qtarget = true,

	/*
	* Show or hide gas stations blips
	* 0 - Hide all
	* 1 - Show nearest (5000ms interval check)
	* 2 - Show all
	*/
	showBlips = 2,

	-- What keys to disable while fueling
	disabledKeys = { 0, 22, 23, 24, 29, 30, 31, 37, 44, 56, 82, 140, 166, 167, 168, 170, 288, 289, 311, 323 },

	-- Total duration (ex. 10% missing fuel): 10 / 0.25 * 250 = 10 seconds

	-- Fuel refill value (every 250msec add 0.25%)
	refillValue = 0.5,

	-- Fuel tick time (every 250 msec)
	refillTick = 200,

	-- Fuel cost (Added once every tick)
	priceTick = 5,

	-- Can durability loss
	durabilityTick = 1.3,

	-- Enables fuel can
	petrolCan = {
		enabled = true,
		duration = 5000,
		price = 1000
	},

	-- Fuel usage multiplier based on class (default 1.0)
	classUsage = {
		[13] = 0.0, -- Cycles
		[15] = 7.0,
		[16] = 5.0
	},

	-- Fuel usage per second based on vehicle RPM
	rpmUsage = {
		[1.0] = 0.07,
		[0.9] = 0.06,
		[0.8] = 0.05,
		[0.7] = 0.045,
		[0.6] = 0.04,
		[0.5] = 0.035,
		[0.4] = 0.025,
		[0.3] = 0.02,
		[0.2] = 0.01,
		[0.1] = 0.005,
		[0.0] = 0.00,
	},

	-- Electic vehicles (not currently used)
	electricModels = {
		[`airtug`] = true,
		[`neon`] = true,
		[`raiden`] = true,
		[`caddy`] = true,
		[`caddy2`] = true,
		[`caddy3`] = true,
		[`cyclone`] = true,
		[`dilettante`] = true,
		[`dilettante2`] = true,
		[`surge`] = true,
		[`tezeract`] = true,
		[`imorgon`] = true,
		[`khamelion`] = true,
		[`voltic`] = true,
		[`iwagen`] = true
	},

	-- Gas pump models
	pumpModels = {
		`prop_gas_pump_old2`,
		`prop_gas_pump_1a`,
		`prop_vintage_pump`,
		`prop_gas_pump_old3`,
		`prop_gas_pump_1c`,
		`prop_gas_pump_1b`,
		`prop_gas_pump_1d`,
	},

	gasStations = { -- gas station polyzones
		[1] = {
			zones = {
				vector2(197.71, -1563.35),
				vector2(175.44, -1577.13),
				vector2(166.95, -1577.69),
				vector2(153.49, -1566.63),
				vector2(180.97, -1541.11)
			},
			minz = 28.2,
			maxz = 30.3,
		},
		[2] = { 
			zones = {
				vector2(-45.04, -1764.04),
				vector2(-60.67, -1751.32),
				vector2(-72.59, -1743.82),
				vector2(-85.63, -1749.96),
				vector2(-89.56, -1761.59),
				vector2(-64.15, -1782.26)
			},
			minz = 28.2,
			maxz = 30.4,
		},
		[3] = { 
			zones = {
				vector2(-544.35, -1214.84),
				vector2(-532.38, -1188.11),
				vector2(-523.16, -1184.4),
				vector2(-513.99, -1189.66),
				vector2(-504.84, -1201.55),
				vector2(-519.84, -1225.96)
			},
			minz = 17.4,
			maxz = 21.04,
		},
		[4] = { 
			zones = {
				vector2(-703.67, -922.96),
				vector2(-703.1, -945.78),
				vector2(-738.64, -948.84),
				vector2(-738.86, -928.63),
				vector2(-737.26, -922.6)
			},
			minz = 18.0,
			maxz = 20.4,
		},
		[5] = { 
			zones = {
				vector2(249.16, -1238.56),
				vector2(248.45, -1277.9),
				vector2(284.8, -1277.77),
				vector2(283.25, -1238.85)
			},
			minz = 28.1,
			maxz = 30.3,
		},
		[6] = { 
			zones = {
				vector2(835.16, -1016.11),
				vector2(835.17, -1038.91),
				vector2(803.41, -1039.43),
				vector2(801.99, -1021.48),
				vector2(807.06, -1017.5)
			},
			minz = 25.1,
			maxz = 28.1,
		},
		[7] = { 
			zones = {
				vector2(1194.29, -1390.77),
				vector2(1222.02, -1390.89),
				vector2(1222.28, -1397.48),
				vector2(1220.31, -1403.85),
				vector2(1215.59, -1408.99),
				vector2(1210.27, -1414.28),
				vector2(1202.85, -1417.77),
				vector2(1194.23, -1417.77)
			},
			minz = 34.1,
			maxz = 36.3,
		},
		[8] = { 
			zones = {
				vector2(1175.53, -345.75),
				vector2(1196.56, -341.94),
				vector2(1195.71, -330.24),
				vector2(1190.13, -311.13),
				vector2(1168.08, -315.06)
			},
			minz = 68.1,
			maxz = 70.2,
		},
		[9] = { 
			zones = {
				vector2(607.47, 256.21),
				vector2(621.22, 249.25),
				vector2(630.36, 244.68),
				vector2(640.58, 261.96),
				vector2(632.23, 292.5),
				vector2(613.05, 291.07),
				vector2(600.56, 273.67),
				vector2(600.25, 260.91)
			},
			minz = 101.9,
			maxz = 104.8,
		},
		[10] = { 
			zones = {
				vector2(-1436.74, -294.19),
				vector2(-1420.77, -280.07),
				vector2(-1437.81, -260.54),
				vector2(-1453.21, -275.01)
			},
			minz = 45.0,
			maxz = 47.3,
		},
		[11] = { 
			zones = {
				vector2(-2110.46, -304.06),
				vector2(-2114.37, -333.21),
				vector2(-2108.01, -336.58),
				vector2(-2082.13, -337.16),
				vector2(-2079.08, -306.89)
			},
			minz = 12.0,
			maxz = 14.3,
		},
		[12] = {
			zones = {
				vector2(-80.43, 6424.65),
				vector2(-89.59, 6433.63),
				vector2(-109.95, 6413.36),
				vector2(-100.59, 6404.59)
			},
			minz = 30.34,
			maxz = 32.5,
		},
		[13] = { 
			zones = {
				vector2(163.43, 6589.83),
				vector2(199.63, 6593.83),
				vector2(196.35, 6617.25),
				vector2(160.56, 6612.12)
			},
			minz = 30.7,
			maxz = 32.91,
		},
		[14] = { 
			zones = {
				vector2(1688.68, 6415.44),
				vector2(1694.51, 6426.76),
				vector2(1713.32, 6417.86),
				vector2(1709.4, 6404.74)
			},
			minz = 31.4,
			maxz = 34.2,
		},
		[15] = { 
			zones = {
				vector2(1684.55, 4940.1),
				vector2(1677.23, 4927.9),
				vector2(1690.32, 4919.34),
				vector2(1699.03, 4932.36)
			},
			minz = 41.05,
			maxz = 43.17,
		},
		[16] = { 
			zones = {
				vector2(1993.86, 3774.78),
				vector2(2000.73, 3763.9),
				vector2(2016.33, 3772.56),
				vector2(2009.89, 3784.76)
			},
			minz = 31.18,
			maxz = 33.60,
		},
		[17] = { 
			zones = {
				vector2(1785.94, 3339.17),
				vector2(1793.17, 3326.67),
				vector2(1783.28, 3320.17),
				vector2(1775.34, 3331.93)
			},
			minz = 40.0,
			maxz = 42.6,
		},
		[18] = { 
			zones = {
				vector2(2670.27, 3261.09),
				vector2(2681.18, 3254.82),
				vector2(2689.25, 3268.21),
				vector2(2677.85, 3274.04)
			},
			minz = 54.24,
			maxz = 56.4,
		},
		[19] = { 
			zones = {
				vector2(1208.37, 2649.92),
				vector2(1197.52, 2661.37),
				vector2(1205.17, 2670.24),
				vector2(1217.39, 2660.06)
			},
			minz = 36.7,
			maxz = 38.85,
		},
		[20] = { 
			zones = {
				vector2(1049.94, 2664.15),
				vector2(1049.14, 2678.46),
				vector2(1029.32, 2680.23),
				vector2(1029.13, 2664.08)
			},
			minz = 38.24,
			maxz = 40.55,
		},
		[21] = { 
			zones = {
				vector2(257.59, 2600.27),
				vector2(256.42, 2610.27),
				vector2(269.5, 2613.24),
				vector2(271.72, 2602.8)
			},
			minz = 43.60,
			maxz = 45.95,
		},
		[22] = { 
			zones = {
				vector2(58.56, 2780.19),
				vector2(51.92, 2770.87),
				vector2(39.99, 2778.77),
				vector2(46.29, 2786.66)
			},
			minz = 56.8,
			maxz = 58.9,
		},
		[23] = { 
			zones = {
				vector2(-2544.79, 2320.18),
				vector2(-2546.07, 2348.81),
				vector2(-2566.62, 2347.06),
				vector2(-2564.37, 2319.18)
			},
			minz = 32.05,
			maxz = 34.08,
		},
		[24] = { 
			zones = {
				vector2(2539.1, 2600.33),
				vector2(2531.31, 2597.31),
				vector2(2534.94, 2586.64),
				vector2(2542.88, 2590.09)
			},
			minz = 36.94,
			maxz = 38.94,
		},
		[25] = {
			zones = {
				vector2(2565.13, 350.19),
				vector2(2595.63, 347.79),
				vector2(2596.64, 372.98),
				vector2(2565.27, 375.54)
			},
			minz = 107.4,
			maxz = 109.4,
		},
		[26] = { 
			zones = {
				vector2(-1780.57, 806.54),
				vector2(-1801.73, 783.76),
				vector2(-1818.02, 800.35),
				vector2(-1796.41, 821.75)
			},
			minz = 136.64,
			maxz = 139.9,
		},
		[27] = { 
			zones = {
				vector2(-329.02, -1490.46),
				vector2(-300.69, -1474.47),
				vector2(-311.31, -1454.88),
				vector2(-338.74, -1469.33)
			},
			minz = 29.5,
			maxz = 31.9,
		},
	}
}
