return {
	-- 0	vehicle has no storage
	-- 1	vehicle has no trunk storage
	-- 2	vehicle has no glovebox storage
	-- 3	vehicle has trunk in the hood
	Storage = {
		[`jester`] = 3,
		[`adder`] = 3,
		[`osiris`] = 1,
		[`pfister811`] = 1,
		[`penetrator`] = 1,
		[`autarch`] = 1,
		[`bullet`] = 1,
		[`cheetah`] = 1,
		[`cyclone`] = 1,
		[`voltic`] = 1,
		[`reaper`] = 3,
		[`entityxf`] = 1,
		[`t20`] = 1,
		[`taipan`] = 1,
		[`tezeract`] = 1,
		[`torero`] = 3,
		[`turismor`] = 1,
		[`fmj`] = 1,
		[`infernus`] = 1,
		[`italigtb`] = 3,
		[`italigtb2`] = 3,
		[`nero2`] = 1,
		[`vacca`] = 3,
		[`vagner`] = 1,
		[`visione`] = 1,
		[`prototipo`] = 1,
		[`zentorno`] = 1,
		[`trophytruck`] = 0,
		[`trophytruck2`] = 0,
	},

	-- slots, maxWeight; default weight is 8000 per slot
	glovebox = {
		[0] = {5, 12000},		-- Compact
		[1] = {5, 12000},		-- Sedan
		[2] = {5, 12000},		-- SUV
		[3] = {5, 12000},		-- Coupe
		[4] = {5, 12000},		-- Muscle
		[5] = {5, 12000},		-- Sports Classic
		[6] = {5, 12000},		-- Sports
		[7] = {5, 12000},		-- Super
		[8] = {2, 2500},		-- Motorcycle
		[9] = {5, 12000},		-- Offroad
		[10] = {5, 12000},		-- Industrial
		[11] = {5, 12000},		-- Utility
		[12] = {5, 12000},		-- Van
		[14] = {5, 12000},	-- Boat
		[15] = {5, 12000},	-- Helicopter
		[16] = {5, 12000},	-- Plane
		[17] = {5, 12000},		-- Service
		[18] = {5, 12000},		-- Emergency
		[19] = {5, 12000},		-- Military
		[20] = {5, 12000},		-- Commercial (trucks)
		models = {
			[`xa21`] = {5, 12000}
		}
	},

	trunk = {
		[0] = {20, 75000},		-- Compact
		[1] = {30, 100000},		-- Sedan
		[2] = {40, 150000},		-- SUV
		[3] = {20, 75000},		-- Coupe
		[4] = {20, 75000},		-- Muscle
		[5] = {20, 75000},		-- Sports Classic
		[6] = {20, 75000},		-- Sports
		[7] = {20, 75000},		-- Super
		[8] = {5, 15000},		-- Motorcycle
		[9] = {40, 150000},		-- Offroad
		[10] = {50, 180000},	-- Industrial
		[11] = {50, 180000},	-- Utility
		[12] = {50, 180000},	-- Van
		-- [14] -- Boat
		-- [15] -- Helicopter
		-- [16] -- Plane
		[17] = {20, 75000},	-- Service
		[18] = {20, 75000},	-- Emergency
		[19] = {20, 75000},	-- Military
		[20] = {20, 75000},	-- Commercial
		models = {
			[`mule`] = {50, 180000},
			[`mule2`] = {50, 180000},
			[`mule3`] = {50, 180000},
			[`mule4`] = {50, 180000},
			[`mule5`] = {50, 180000}
		},
		boneIndex = {
			[`pounder`] = 'wheel_rr'
		}
	}
}
