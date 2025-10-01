return {
	['black_money'] = {
		label = 'FBI Raha',
	},

	['money'] = {
		label = 'Raha',
	},

	['idcard'] = {
		label = 'Isikutunnistus',
		stack = false,
		consume = 0
	}, 

	['fishing_id'] = {
		label = 'Kalastusluba',
		stack = false,
		consume = 0
	},

	['radio'] = {
		label = 'Raadio',
		weight = 3000,
		stack = false,
		consume = 0,
		allowArmed = true
	},

	['lockpick'] = {
		label = 'Multitööriist',
		weight = 2000,
		stack = false,
		consume = 0,
		allowArmed = true 
	},
	
	['special_lockpick'] = {
		label = 'Häkkimisseade',
		weight = 3000,
		stack = false,
		consume = 0,
		allowArmed = true 
	}, 

	['giftbox'] = {
		label = 'Kingitus',
		weight = 2000,
		stack = false,
		consume = 1,
		allowArmed = true 
	},
	
	['wheelchair'] = {
		label = 'Ratastool',
		weight = 15000,
		durability = 0.2,
		stack = false,
		consume = 0,
		allowArmed = true 
	},

	['bottle'] = {
		label = 'Pudel',
		weight = 2000,
		stack = true,
		consume = 0,
		allowArmed = true
	},
	
    ['plastic'] = {
		label = 'Plastik',
		weight = 1000,
		stack = true,
		consume = 0,
		allowArmed = true
	},
	
	['screwdriver'] = {
		label = 'Kruvikeeraja',
		weight = 1000,
		stack = true,
		consume = 0,
		allowArmed = true
	},

	
	['wipes'] = {
		label = 'Kätepuhastuslapid',
		weight = 1000,
		stack = true,
		consume = 0,
		allowArmed = true
	},

	['stickynote'] = {
		label = 'Märkmik',
		weight = 1000,
		stack = false,
		consume = 0
	},

["phone"] = {
    label = "Phone",
    weight = 190,
    stack = false,
    consume = 0,
    client = {
        export = "lb-phone.UsePhoneItem",
        remove = function()
            TriggerEvent("lb-phone:itemRemoved")
        end,
        add = function()
            TriggerEvent("lb-phone:itemAdded")
        end
    }
},
	
	['scratch_ticket'] = {
		label = 'Loteriipilet',
		weight = 1000,
		stack = false,
		consume = 0,
		allowArmed = true 
	},
	
	['alecoq'] = {
		label = 'Õlu',
		weight = 3000,
		stack = 1,
		close = 1,
		description = ''
	},

	['apple'] = {
		label = 'Õun',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0
	},

	['armor'] = {
		label = 'Kuulivest',
		weight = 13000,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	},

	['armor_plate'] = {
		label = 'Vestiplaat',
		weight = 12000,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	},

	['at_clip_drum_pistol'] = {
		label = 'pistol drum clip',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_flashlight_pistol'] = {
		label = 'pistol flashlight',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_flashlight_rifle'] = {
		label = 'rifle flashlight',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_flashlight_shotgun'] = {
		label = 'shotgun flashlight',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_flashlight_smg'] = {
		label = 'smg flashlight',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_flashlight_sniper'] = {
		label = 'sniper flashlight',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_grip_mg'] = {
		label = 'mg grip',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_grip_rifle'] = {
		label = 'rifle grip',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_grip_shotgun'] = {
		label = 'shotgun grip',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['small_spring'] = {
		label = 'Vedru',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['small_trigger'] = {
		label = 'Päästik',
		weight = 2000,
		stack = 1,
		close = 1,
		description = ''
	},

	['safety'] = {
		label = 'Kaitseriiv',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['grip'] = {
		label = 'Käepide',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['cableties'] = {
		label = 'Nipukad',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['magazin'] = {
		label = 'Keskmine salv',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},


	['at_grip_smg'] = {
		label = 'smg grip',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_grip_sniper'] = {
		label = 'sniper grip',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_scope_mg'] = {
		label = 'mg scope',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_scope_rifle'] = {
		label = 'rifle scope',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_scope_smg'] = {
		label = 'smg sight',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_scope_sniper'] = {
		label = 'sniper scope',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_suppressor_pistol'] = {
		label = 'pistol suppressor',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_suppressor_rifle'] = {
		label = 'rifle suppressor',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_suppressor_shotgun'] = {
		label = 'shotgun suppressor',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_suppressor_smg'] = {
		label = 'smg suppressor',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['at_suppressor_sniper'] = {
		label = 'Sniper suppressor',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['bock'] = {
		label = 'Bock',
		weight = 3000,
		stack = 1,
		close = 1,
		description = ''
	},

	['c4_bank'] = {
		label = 'Pomm',
		weight = 20000,
		stack = 1,
		close = 1,
		description = ''
	},

	['chips'] = {
		label = 'Krõpsud',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0
	},

	['coca_leaf'] = {
		label = 'Kokaleht',
		weight = 500,
		stack = 1,
		close = 1,
		description = ''
	},

	['cola'] = {
		label = 'eCola',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},


	['copper'] = {
		label = 'Vask',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['diamond'] = {
		label = 'Teemant',
		weight = 1500,
		stack = 1,
		close = 1,
		description = ''
	},

	['grip_bag'] = {
		label = 'Gripkott',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['drill'] = {
		label = 'Trell',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['thermite'] = {
		label = 'Termiit',
		weight = 1500,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	}, 
	['atmmotherboard'] = {
        label = 'Emmeplaat',
        description = 'Tundub nagu emmeplaat.',
        weight = 250,
        close = true,
        stack = false
    },

	['emerald'] = {
		label = 'Smaragd',
		weight = 2000,
		stack = 1,
		close = 1,
		description = ''
	},

	['fakeplate'] = {
		label = 'Numbrimärk',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['fanta'] = {
		label = 'Fanta',
		weight = 3000,
		stack = 1,
		close = 1,
		description = ''
	},   

	['sugar'] = {
		label = 'Suhkur',
		weight = 100,
		stack = 1,
		close = 0,
		description = ''
	},

	['grape_juice'] = {
		label = 'Viinamarjamahl',
		weight = 5000,
		stack = 1,
		close = 0,
		description = ''
	},

	['grape'] = {
		label = 'Viinamari',
		weight = 5000,
		stack = 1,
		close = 0,
		description = ''
	}, 

	['racing_tablet'] = {
		label = 'Tahvelarvuti',
		weight = 5000,
		stack = 0,
		close = 1,
		description = 'Käivad kõlakad, et sellel tahvlil on võimalus teistega tänavavõidusõitudel mõõtu võtta.'
	},

	['boosting_tablet'] = {
		label = 'Tahvelarvuti',
		weight = 5000,
		stack = 0,
		close = 1,
		description = 'Käivad kõlakad, et sellel tahvlil on mingi kahtlane programm peal.'
	},

	['drugphone'] = {
		label = 'Nokia telefon',
		weight = 3000,
		stack = 0,
		close = 1,
		description = 'Naudi helistamist oma nokia telefoniga.'
	},

	['nintendo'] = {
		label = 'Wintendo Switch',
		weight = 5000,
		stack = 0,
		close = 1,
		description = ':OO'
	},

	['fixkit'] = {
		label = 'Paranduskomplekt',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['goldwatch'] = {
		label = 'Kuldne käekell',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},
	
	['goldbar'] = {
		label = 'Kullakang',
		weight = 8000,
		stack = 1,
		close = 1,
		description = ''
	},
	
	['tiamond'] = {
		label = 'Kallis Deemant',
		weight = 2000,
		stack = 1,
		close = 1,
		description = ''
	},
	
	['ruby'] = {
		label = 'Rubiin',
		weight = 2000,
		stack = 1,
		close = 1,
		description = ''
	},
	
	['sapphire'] = {
		label = 'Safiir',
		weight = 1500,
		stack = 1,
		close = 1,
		description = ''
	},
	
	['emerald'] = {
		label = 'Emerald',
		weight = 2000,
		stack = 1,
		close = 1,
		description = ''
	},

	['iron'] = {
		label = 'Raud',
		weight = 3000,
		stack = 1,
		close = 1,
		description = ''
	},

	['jewelry_id'] = {
		label = 'Juveelipoe kaart',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},
	
	['jewelry_key'] = {
		label = 'Juveelipoe võti',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	-- ['medkit'] = {
	-- 	label = 'Esmaabikomplekt',
	-- 	weight = 5000,
	-- 	stack = 1,
	-- 	close = 1,
	-- 	description = ''
	-- },
	
	['bandage'] = {
		label = 'Sidemed',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	},

	['stretcher'] = {
		label = 'Kanderaam',
		weight = 20000,
		stack = false,
		consume = 0,
		allowArmed = false 
	},


	['syringe'] = {
		label = 'Süstal',
		weight = 1000,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['oxmask'] = {
		label = 'Hapnikumask',
		weight = 1000,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},
	['patch'] = {
		label = 'Plaaster',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	},

	['nacl'] = {
		label = 'Naatriumkloriid',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	},


	['monster'] = {
		label = 'Monster',
		weight = 3000,
		stack = 1,
		close = 1,
		description = ''
	},

	['moon_leaf'] = {
		label = 'Moonileht',
		weight = 200,
		stack = 1,
		close = 1,
		description = ''
	},

	['moonshine'] = {
		label = 'Puskar',
		weight = 1200,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	},

	['milk'] = {
		label = 'Piim',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},


	['neckless'] = {
		label = 'Kaelakee',
		weight = 2000,
		stack = 1,
		close = 1,
		description = ''
	},

	['oil'] = {
		label = 'Õli',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},


	['proccesedoil'] = {
		label = 'Rafineeritud õli',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['hacking_tablet'] = {
		label = 'Tahvelarvuti',
		weight = 3000,
		stack = 1,
		close = 1,
		description = ''
	},

	['redbull'] = {
		label = 'Red Bull',
		weight = 3000,
		stack = 1,
		close = 1,
		description = ''
	},

	['ring'] = {
		label = 'Sõrmus',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['rolexwatch'] = {
		label = 'Käekell rolex',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['rollingpaper'] = {
		label = 'Rullpaber',
		weight = 500,
		stack = 1,
		close = 1,
		description = ''
	},

	['sandwitch'] = {
		label = 'Võileib',
		weight = 2000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	['sprite'] = {
		label = 'Sprite',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	},
	['steel'] = {
		label = 'Sulatatud raud',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['taurus'] = {
		label = 'Taurus',
		weight = 3000,
		stack = 1,
		close = 1,
		description = ''
	},

	['tequila'] = {
		label = 'Tekiila',
		weight = 3000,
		stack = 1,
		close = 1,
		description = ''
	},

	['tunerchip'] = {
		label = 'Tuunerarvuti',
		weight = 15000,
		stack = 1,
		close = 1,
		description = ''
	},

	['vodka'] = {
		label = 'Viin',
		weight = 3000,
		stack = 1,
		close = 1,
		description = ''
	},

	['arcadetoken'] = {
		label = 'Arcade token',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ':OOO'
	},

	['boombox'] = {
		label = 'Boombox',
		weight = 15000,
		stack = 1,
		close = 1,
		description = ':OOO'
	},

	['whisky'] = {
		label = 'Viski',
		weight = 3000,
		stack = 1,
		close = 1,
		description = ''
	},

	['wine'] = {
		label = 'Vein',
		weight = 5000,
		stack = 1,
		close = 1,
		description = ''
	},

	['bait'] = {
		label = 'Kalasööt',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['fish'] = {
		label = 'Kala',
		weight = 2000,
		stack = 0,
		close = 1,
		description = ''
	},

	['turtle'] = {
		label = 'Kilpkonn',
		weight = 4000,
		stack = 0,
		close = 1,
		description = ''
	},

	['shark'] = {
		label = 'Haikala',
		weight = 6000,
		stack = 0,
		close = 1,
		description = ''
	},

	['fishingrod'] = {
		label = 'Õng',
		weight = 3000,
		stack = 1,
		close = 1,
		description = ''
	},
	---BURGERSHOT

	['chocolate_syrup'] = {
		label = 'Šhokolaadi siirup',
		weight = 500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['icecream'] = {
		label = 'Jäätis',
		weight = 100,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['bs_cup'] = {
		label = 'Tops',
		weight = 100,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['sprunk_cup'] = {
		label = 'Sprunk',
		weight = 500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['cola_cup'] = {
		label = 'E-cola',
		weight = 500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['orango_cup'] = {
		label = 'Orango Tang',
		weight = 500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['cola_light_cup'] = {
		label = 'Cola Light',
		weight = 500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['sprunk_syrup'] = {
		label = 'Sprunk siirup',
		weight = 500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['cola_syrup'] = {
		label = 'Cola siirup',
		weight = 500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['orango_syrup'] = {
		label = 'Orango siirup',
		weight = 500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['orango_icecream'] = {
		label = 'Orang-O-Tang',
		weight = 500,
		stack = 1,
		close = 1,
		degrade = 120,
		description = '',
		consume = 0,
	},
	
	
	['meteorite_icecream'] = {
		label = 'Meteorite',
		weight = 500,
		stack = 1,
		close = 1,
		degrade = 120,
		description = '',
		consume = 0,
	},
	
	
	['double_shot'] = {
		label = 'Double Shot',
		weight = 3000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	
	['glorious'] = {
		label = 'Glorious',
		weight = 4000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	
	['prickly'] = {
		label = 'Prickly',
		weight = 2000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	
	['heart_stopper'] = {
		label = 'Heart Stopper',
		weight = 3500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	
	['simply'] = {
		label = 'Simply',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	
	['bleeder'] = {
		label = 'Bleeder',
		weight = 2000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	
	['goat_cheese_wrap'] = {
		label = 'Goat Cheese Wrap',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	
	['chicken_wrap'] = {
		label = 'Chicken Wrap',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	
	['mexican_taco'] = {
		label = 'Mexican Taco',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	
	['minced_beef'] = {
		label = 'Veisehakkliha',
		weight = 2000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	

	
	['burger_bun'] = {
		label = 'Burgeri sai',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['pickle'] = {
		label = 'Hapukurk',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['bacon'] = {
		label = 'Peekon',
		weight = 2000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['potato'] = {
		label = 'Kartul',
		weight = 3000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['egg'] = {
		label = 'Muna',
		weight = 100,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['chicken_fillet'] = {
		label = 'Kanafilee',
		weight = 2000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['fried_egg'] = {
		label = 'Praemuna',
		weight = 100,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['spicy_sauce'] = {
		label = 'Vürtsikas Kaste',
		weight = 400,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	
	['beef_patty'] = {
		label = 'Veiseliha Pihv',
		weight = 300,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['tomato_slice'] = {
		label = 'Tomati viil',
		weight = 100,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['chopped_onion'] = {
		label = 'Sibularõngas',
		weight = 100,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['salad'] = {
		label = 'Salat',
		weight = 70,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['bacon_slice'] = {
		label = 'Peekoni viil',
		weight = 250,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['grilled_bacon_slice'] = {
		label = 'Peekoni viil',
		weight = 200,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['bun_slice'] = {
		label = 'Saia pool',
		weight = 400,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['pickle_slice'] = {
		label = 'Hapukurgi viil',
		weight = 50,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['french_fries'] = {
		label = 'Friikartulid',
		weight = 250,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['sliced_chicken_fillet'] = {
		label = 'Kanafilee riba',
		weight = 400,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['grilled_chicken_fillet'] = {
		label = 'Kanafilee riba',
		weight = 300,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['grilled_beef_patty'] = {
		label = 'Veiseliha pihv',
		weight = 200,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['fried_french_fries'] = {
		label = 'Friikartulid',
		weight = 200,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['sauce'] = {
		label = 'Kaste',
		weight = 500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['cheese'] = {
		label = 'Juust',
		weight = 500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['tortilla'] = {
		label = 'Tortilla',
		weight = 400,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['jalapeno'] = {
		label = 'Jalapeno',
		weight = 400,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['taco'] = {
		label = 'Taco',
		weight = 400,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	--burgershot end 
	-- uwucafe stat
	
	['sliced_fish'] = {
		label = 'Fileeritud kala',
		weight = 1500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['yakitori'] = {
		label = 'Yakitori',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['sashimi'] = {
		label = 'Sashimi',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['ramen'] = {
		label = 'Ramen',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['miso_soup'] = {
		label = 'Miso supp',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['okonomiyaki'] = {
		label = 'Okonomiyaki',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['gyoza'] = {
		label = 'Gyoza',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['curry_rice'] = {
		label = 'Karririis',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['tempura'] = {
		label = 'Tempura',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['sake'] = {
		label = 'Sake',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['ploomivein'] = {
		label = 'Ploomivein',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['syrup'] = {
		label = 'Siirup',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['matcha_tea'] = {
		label = 'Matcha tee',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['mahl'] = {
		label = 'mahl',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['rice'] = {
		label = 'Riis',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['beef'] = {
		label = 'Veiseliha',
		weight = 2000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['sliced_beef'] = {
		label = 'Hakitud veiseliha',
		weight = 500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['grilled_sliced_beef'] = {
		label = 'Grillitud veiseliha',
		weight = 500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['noodles'] = {
		label = 'Nuudlid',
		weight = 200,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['dashi'] = {
		label = 'Puljong',
		weight = 1500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['miso'] = {
		label = 'Miso',
		weight = 1500,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['dough'] = {
		label = 'Taigen',
		weight = 1500,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	--Uwucafe End
	-- Bean Start
	['coffee_bean'] = {
		label = 'Kohviuba',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['banana'] = {
		label = 'Banaan',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['mango'] = {
		label = 'Mango',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['peppermint'] = {
		label = 'Piparmünt',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['vanilla_syrup'] = {
		label = 'Vanilje siirup',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['caramel_syrup'] = {
		label = 'Karamelli siirup',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['ice_tea'] = {
		label = 'Jäätee',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['ice_coffee'] = {
		label = 'Jääkohv',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['caramel_cocktail'] = {
		label = 'Karamelli jääkokteil',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['chocolate_cocktail'] = {
		label = 'Šokolaadi jääkokteil',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['vanilla_cocktail'] = {
		label = 'Vanilje jääkokteil',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['peppermint_cocktail'] = {
		label = 'Piparmündi jääkokteil',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['peppermint_chocolate_cocktail'] = {
		label = 'Piparmündi-šokolaadi jääkokteil',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['mango_smoothie'] = {
		label = 'Mango smuuti',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['banana_smoothie'] = {
		label = 'Banaani smuuti',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['filter_coffee'] = {
		label = 'Filtrikohv',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['cappuccino'] = {
		label = 'Cappuccino',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['americano'] = {
		label = 'Americano',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['espresso'] = {
		label = 'Espresso',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['latte'] = {
		label = 'Latte',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['caramel_latte'] = {
		label = 'Karamelli Latte',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['vanilla_latte'] = {
		label = 'Vanilje Latte',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['hot_chocolate'] = {
		label = 'Kuum šokolaad',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['brownie'] = {
		label = 'Brownie',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['cheescake'] = {
		label = 'Juustukook',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['gingerbreads'] = {
		label = 'Piparkoogid',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['cheese_sandwich'] = {
		label = 'Juustuvõileib',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	
	['waffles'] = {
		label = 'Vahvlid',
		weight = 1000,
		stack = 1,
		close = 1,
		degrade = 1440,
		description = '',
		consume = 0,
	},
	-- Bean End

	['water'] = {
		label = 'Vesi',
		weight = 200,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},
	
	['laptop'] = {
		label = 'Sülearvuti',
		weight = 2000,
		stack = false,
		close = 1,
		description = 'Võimalik, et siit leiad sa väärtuslikku teavet...'
	},

	['document'] = {
		label = 'Dokument',
		weight = 2000,
		stack = false,
		close = 1,
		description = '',
		consume = 0
	},

	['a4'] = {
		label = 'A4',
		weight = 2000,
		stack = true,
		close = 0,
		description = ''
	},
	-- kk-drugs
	['hairdryer'] = {
		label = 'Föön',
		weight = 500,
		stack = true,
		description = '',
		consume = 0
	},

	['pot'] = {
		label = 'Pott',
		weight = 250,
		stack = true,
		consume = 0,
		description = 'Tundub mugav koht, kuhu võiks seemnekese poetada'
	},

	['weed_seed'] = { 
		label = 'Kanepiseeme',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},

	-- kk-druglabs  
	['drugscales'] = {
		label = 'Kaal',
		weight = 5000,
		stack = 0,
		close = 1,
		description = ''
	},

	['tobacco_plant'] = {
		label = 'Tubakataim',
		weight = 2000,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},

	['tobacco_mass'] = {
		label = 'Tubakamass',
		weight = 2000,
		stack = true,
		close = 0,
		description = ''
	},

	['weed_plant'] = { 
		label = 'Kanepitaim',
		weight = 2000,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	}, 


	['coke_plant'] = {
		label = 'Kokataim',
		weight = 2000,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},
	
	['roller'] = {
		label = 'Roller',
		weight = 1000,
		stack = 0,
		close = 1,
		description = '',
		consume = 0
	},

	['cigarett'] = {
		label = 'Sigarett',
		weight = 50,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	}, 

	['cigarello'] = {
		label = 'Sigarillo',
		weight = 100,
		stack = true,
		close = 0,
		consume = 0,
		allowArmed = true 
	},


	['dried_weed'] = {
		label = 'Kuivatatud kanepiõis',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	},

	['tobacco_powder'] = {
		label = 'Tubakapuru',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	},

	['dried_tobacco'] = {
		label = 'Kuivatatud tubakaleht',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	},

	['amphetamine_pooch'] = {
		label = 'Pakendatud amfetamiin',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['amphetamine'] = {
		label = 'Amfetamiin',
		weight = 500,
		stack = 1,
		close = 1,
		description = ''
	},

	['heroin'] = {
		label = 'Heroiin',
		weight = 500,
		stack = 1,
		close = 1,
		description = ''
	},

	['heroin_pooch'] = {
		label = 'Pakendatud heroiin',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['coke'] = {
		label = 'Kokaiin',
		weight = 100,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	},

	['coke_pooch'] = {
		label = 'Pakendatud kokaiin',
		weight = 100,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	},
	['weed_joint'] = {
		label = 'Kanepisuits',
		weight = 200,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	},

	['weed_pooch'] = {
		label = 'Pakendatud kanep',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['soda'] = {
		label = 'Sooda',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	}, 

	['aluminium'] = {
		label = 'Alumiinium',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['amphetamine_paste'] = {
		label = 'Amfetamiinipasta',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	}, 

	['cigarello_pack'] = {
		label = 'Sigarillo pakk',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['hash'] = {
		label = 'Hash',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['kief'] = {
		label = 'Kiff',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['coke_plate'] = {
		label = 'Kokaiiniplaat',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['cloth'] = {
		label = 'Valge riie',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},
	
	['brown_heroin'] = {
		label = 'Pruun heroiin',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	}, 

	['alcohol'] = {
		label = 'Alkohol',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	}, 

	['plaster'] = {
		label = 'Krohv',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['barley'] = {
		label = 'Oder',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	},

	['dried_barley'] = {
		label = 'Kuivatatud oder',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	}, 

	['snus'] = {
		label = 'Tups',
		weight = 100,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	}, 

	['snus_pack'] = {
		label = 'Tupsukarp',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	}, 

	['snus_tower'] = {
		label = 'Tupsutorn',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	}, 

	['salt'] = {
		label = 'Sool',
		weight = 1000,
		stack = 1,
		close = 1,
		description = ''
	}, 

	['sulp'] = {
		label = 'Sulp',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '' 
	}, 

	['sulfur'] = {
		label = 'Väävel',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '' 
	},  

	['cigarett_pack'] = {
		label = 'Sigaretipakk',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '' 
	},

	['cigarett_block'] = {
		label = 'Sigaretiblokk',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '' 
	},

	['wet_weed'] = {
		label = 'Niiske kanepiõis',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	}, 

	['wet_tobacco'] = {
		label = 'Niiske tubakas',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	},

	['wet_tobaccoleaf'] = {
		label = 'Niiske tubakaleht',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	}, 

	['morphine'] = {
		label = 'Morfiinibaas',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	},

	['milky_juice'] = {
		label = 'Piimjas mahl',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	},  

	['chemical_element'] = {
		label = 'Keemiline element',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	}, 

	['processed_coke'] = {
		label = 'Töödeldud kokalehed',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	}, 
 
	['fertilizer'] = {
		label = 'Väetis',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	}, 

	['chemical_mass'] = {
		label = 'Keemiamass',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	},

	['film'] = {
		label = 'Kile',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	},

	['lsa'] = {
		label = 'LSA',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	},

	['lsd_extract'] = {
		label = 'LSD Ekstakt',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	},

	['lsd_blotter_empty'] = {
		label = 'Tühi blotter',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	},

	['lsd'] = {
		label = 'LSD',
		weight = 200,
		stack = true,
		close = 0,
		description = ''
	},

	-- kk-mechanic
	['brakes_1'] = {
		label = 'Pidurid LVL1',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['brakes_2'] = {
		label = 'Pidurid LVL2',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['brakes_3'] = {
		label = 'Pidurid LVL3',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['brakes_4'] = {
		label = 'Pidurid LVL4',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['brakes_5'] = {
		label = 'Pidurid LVL5',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['engine_1'] = {
		label = 'Mootor LVL1',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['engine_2'] = {
		label = 'Mootor LVL2',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['engine_3'] = {
		label = 'Mootor LVL3',
		weight = 200,
		stack = false,
		close = 0,
		description = ''
	},

	['engine_4'] = {
		label = 'Mootor LVL4',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['engine_5'] = {
		label = 'Mootor LVL5',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['suspension_1'] = {
		label = 'Vedrustus LVL1',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['suspension_2'] = {
		label = 'Vedrustus LVL2',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['suspension_3'] = {
		label = 'Vedrustus LVL3',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['suspension_4'] = {
		label = 'Vedrustus LVL4',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['suspension_5'] = {
		label = 'Vedrustus LVL4',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['transmission_1'] = {
		label = 'Käigukast LVL1',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['transmission_2'] = {
		label = 'Käigukast LVL2',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['transmission_3'] = {
		label = 'Käigukast LVL3',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['transmission_4'] = {
		label = 'Käigukast LVL4',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['transmission_5'] = {
		label = 'Käigukast LVL5',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['turbo_1'] = {
		label = 'Turbo',
		weight = 200,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},
	-------- Carwash
	['carwax'] = {
		label = 'Vahapurk',
		weight = 1000,
		stack = true,
		client = {
			export = 'kk-carwash.applyWax'
		},
		allowArmed = false
	},

	--- LÕNG / Sewing

	['beige_fabric'] = {
		label = 'Beež kangas',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['beige_fabric_piece'] = {
		label = 'Beež kanga tükk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['blue_fabric'] = {
		label = 'Sinine kangas',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['blue_fabric_piece'] = {
		label = 'Sinine kanga tükk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['red_fabric'] = {
		label = 'Punane kangas',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['red_fabric_piece'] = {
		label = 'Punane kanga tükk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['black_fabric'] = {
		label = 'Must kangas',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['black_fabric_piece'] = {
		label = 'Must kanga tükk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['orange_fabric'] = {
		label = 'Oranž kangas',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['orange_fabric_piece'] = {
		label = 'Oranž kanga tükk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['orange_thread'] = {
		label = 'Oranž niit',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['green_fabric'] = {
		label = 'Roheline kangas',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['green_fabric_piece'] = {
		label = 'Roheline kanga tükk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['blue_thread'] = {
		label = 'Sinine niit',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['beige_thread'] = {
		label = 'Beež niit',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['green_thread'] = {
		label = 'Roheline niit',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['red_thread'] = {
		label = 'Punane niit',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['black_thread'] = {
		label = 'Must niit',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['brown_fabric'] = {
		label = 'Pruun kangas',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['brown_fabric_piece'] = {
		label = 'Pruun kanga tükk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['brown_thread'] = {
		label = 'Pruun niit',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['coat'] = {
		label = 'Pintsak',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['brown_ironed_shirt_1'] = {
		label = 'Pruun triiksärk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['brown_ironed_shirt_2'] = {
		label = 'Pruun triiksärk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['brown-beige_ironed_shirt'] = {
		label = 'Pruun-beež triiksärk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['red_ironed_shirt'] = {
		label = 'Punane triiksärk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['orange_ironed_shirt'] = {
		label = 'Oranž triiksärk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['orange-beige_ironed_shirt'] = {
		label = 'Oranž-beež triiksärk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['beige_ironed_shirt'] = {
		label = 'Beež triiksärk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['green_ironed_shirt'] = {
		label = 'Roheline triiksärk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['blue_ironed_shirt'] = {
		label = 'Sinine triiksärk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['blue-green_ironed_shirt'] = {
		label = 'Sinikakasroheline triiksärk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['boxers'] = {
		label = 'Bokserid',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['camo_vest_1'] = {
		label = 'Camo vest',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['camo_vest_2'] = {
		label = 'Camo vest',
		weight = 30000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['green_vest'] = {
		label = 'Roheline vest',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['black_vest'] = {
		label = 'Must vest',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['gray_shirt'] = {
		label = 'Hall särk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['white_shirt'] = {
		label = 'Valge särk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['brown_shirt'] = {
		label = 'Pruun särk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['blue_shirt'] = {
		label = 'Sinine särk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['yellow_dress'] = {
		label = 'Kollane kleit',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['yellow_shirt'] = {
		label = 'Kollane särk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['orange_shirt'] = {
		label = 'Oranž särk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['purple_shirt'] = {
		label = 'Lilla särk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['black_shirt'] = {
		label = 'Must särk',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['necktie'] = {
		label = 'Lips',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['strew_hat'] = {
		label = 'Õlgkübar',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['wallet'] = {
		label = 'Rahakott',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['bra'] = {
		label = 'Rinnahoidja',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['w_underwear'] = {
		label = 'Naiste aluspesu',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['socks'] = {
		label = 'Sokid',
		weight = 200,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},


	--

	['apple_juice'] = {
		label = 'Õunamahl',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		degrade = 405,
		consume = 0,
	},

	['orange_juice'] = {
		label = 'Apelsinimahl',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		degrade = 405,
		consume = 0,
	},

	['cola_bottle'] = {
		label = 'eCola',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},

	['sprunk_bottle'] = {
		label = 'Sprunk',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},

	['orango_tang'] = {
		label = 'Orango Tang',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	--

	['donut_pack'] = {
		label = 'Sõõrikud pakendis',
		weight = 4000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['boke'] = {
		label = 'Poke',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['caesar_salat'] = {
		label = 'Caesari salat',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	
	['caramel_donut'] = {
		label = 'Karamellisõõrik',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['red_donut'] = {
		label = 'Punane sõõrik',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['pink_donut'] = {
		label = 'Roosa sõõrik',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['blue_pink_donut'] = {
		label = 'Sinine-Roosa sõõrik',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},
	
	['blue_donut'] = {
		label = 'Sinine sõõrik',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['white_donut'] = {
		label = 'Valge sõõrik',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['donut'] = {
		label = 'sõõrik',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},


	['cheese_chips'] = {
		label = 'Juustukrõpsud',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['salty_chips'] = {
		label = 'Soolakrõpsud',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['sweet_nothings'] = {
		label = 'Sweet Nothings',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['zebrabar'] = {
		label = 'Zebrabar',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['earth_quakes'] = {
		label = 'Earth Quakes',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['ego_chaser'] = {
		label = 'Ego Chaser',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['meteorite'] = {
		label = 'Meteorite',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['paprica_chips'] = {
		label = 'Paprika krõpsud',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['phatchips_pringles'] = {
		label = 'Phatchips',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['sticky_ribs_chips'] = {
		label = 'Ribikrõpsud',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	['pie'] = {
		label = 'Pirukas',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	}, 

	['pnqs'] = {
		label = 'PnQs',
		weight = 1000,
		stack = 1,
		close = 1,
		consume = 0,
		degrade = 405,
		description = ''
	},

	--

	-- Meha varuosad

	-- S

	['fuel_injector_s'] = {
		label = 'Kütusepihusti',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['radiator_s'] = {
		label = 'Radiaator',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['axle_s'] = {
		label = 'Teljed',
		weight = 15000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['transmission_s'] = {
		label = 'Käigukast',
		weight = 20000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['electronics_s'] = {
		label = 'Elektroonika',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['brakes_s'] = {
		label = 'Pidurid',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['clutch_s'] = {
		label = 'Sidur',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['tire_s'] = {
		label = 'Rehvid',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	-- A

	['fuel_injector_a'] = {
		label = 'Kütusepihusti',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['radiator_a'] = {
		label = 'Radiaator',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['axle_a'] = {
		label = 'Teljed',
		weight = 15000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['transmission_a'] = {
		label = 'Käigukast',
		weight = 20000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['electronics_a'] = {
		label = 'Elektroonika',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['brakes_a'] = {
		label = 'Pidurid',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['clutch_a'] = {
		label = 'Sidur',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['tire_a'] = {
		label = 'Rehvid',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	-- B

	['fuel_injector_b'] = {
		label = 'Kütusepihusti',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['radiator_b'] = {
		label = 'Radiaator',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['axle_b'] = {
		label = 'Teljed',
		weight = 15000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['transmission_b'] = {
		label = 'Käigukast',
		weight = 20000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['electronics_b'] = {
		label = 'Elektroonika',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['brakes_b'] = {
		label = 'Pidurid',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['clutch_b'] = {
		label = 'Sidur',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['tire_b'] = {
		label = 'Rehvid',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	-- C
	['fuel_injector_c'] = {
		label = 'Kütusepihusti',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['radiator_c'] = {
		label = 'Radiaator',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['axle_c'] = {
		label = 'Teljed',
		weight = 15000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['transmission_c'] = {
		label = 'Käigukast',
		weight = 20000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['electronics_c'] = {
		label = 'Elektroonika',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['brakes_c'] = {
		label = 'Pidurid',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['clutch_c'] = {
		label = 'Sidur',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['tire_c'] = {
		label = 'Rehvid',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	-- D

	['fuel_injector_d'] = {
		label = 'Kütusepihusti',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['radiator_d'] = {
		label = 'Radiaator',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['axle_d'] = {
		label = 'Teljed',
		weight = 15000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['transmission_d'] = {
		label = 'Käigukast',
		weight = 20000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['electronics_d'] = {
		label = 'Elektroonika',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['brakes_d'] = {
		label = 'Pidurid',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['clutch_d'] = {
		label = 'Sidur',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['tire_d'] = {
		label = 'Rehvid',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	-- M

	['fuel_injector_m'] = {
		label = 'Kütusepihusti',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['radiator_m'] = {
		label = 'Radiaator',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['axle_m'] = {
		label = 'Teljed',
		weight = 15000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['transmission_m'] = {
		label = 'Käigukast',
		weight = 20000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['electronics_m'] = {
		label = 'Elektroonika',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['brakes_m'] = {
		label = 'Pidurid',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['clutch_m'] = {
		label = 'Sidur',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['tire_m'] = {
		label = 'Rehvid',
		weight = 10000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	-- S kategooria
	['fuel_injector_s_box'] = {
		label = 'Kütusepihusti S',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Pihustab kütust mootorisse (S-tase).'
	},

	['radiator_s_box'] = {
		label = 'Radiaator S',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Jahutab mootorit (S-tase).'
	},

	['axle_s_box'] = {
		label = 'Telg',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Ühendab ja toetab rattaid (S-tase).'
	},

	['transmission_s_box'] = {
		label = 'Käigukast S',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Edastab mootori võimsust ratastele (S-tase).'
	},

	['electronics_s_box'] = {
		label = 'Elektroonika S',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Kontrollib elektroonikat (S-tase).'
	},

	['brakes_s_box'] = {
		label = 'Pidurid S',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Peatab sõiduki (S-tase).'
	},

	['clutch_s_box'] = {
		label = 'Sidur S',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Ühendab mootori käigukastiga (S-tase).'
	},

	['tire_s_box'] = {
		label = 'Rehv S',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Tagab haarduvuse teega (S-tase).'
	},

	-- A kategooria
	['fuel_injector_a_box'] = {
		label = 'Kütusepihusti A',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Pihustab kütust mootorisse (A-tase).'
	},

	['radiator_a_box'] = {
		label = 'Radiaator A',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Jahutab mootorit (A-tase).'
	},

	['axle_a_box'] = {
		label = 'Telg A',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Ühendab ja toetab rattaid (A-tase).'
	},

	['transmission_a_box'] = {
		label = 'Käigukast A',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Edastab võimsust ratastele (A-tase).'
	},

	['electronics_a_box'] = {
		label = 'Elektroonika A',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Kontrollib elektroonikat (A-tase).'
	},

	['brakes_a_box'] = {
		label = 'Pidurid A',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Peatab sõiduki (A-tase).'
	},

	['clutch_a_box'] = {
		label = 'Sidur A',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Ühendab mootori ja käigukasti (A-tase).'
	},

	['tire_a_box'] = {
		label = 'Rehv A',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Tagab haarduvuse teega (A-tase).'
	},

	-- B kategooria
	['fuel_injector_b_box'] = {
		label = 'Kütusepihusti B',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Pihustab kütust mootorisse (B-tase).'
	},

	['radiator_b_box'] = {
		label = 'Radiaator B',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Jahutab mootorit (B-tase).'
	},

	['axle_b_box'] = {
		label = 'Telg B',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Ühendab ja toetab rattaid (B-tase).'
	},

	['transmission_b_box'] = {
		label = 'Käigukast B',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Edastab võimsust ratastele (B-tase).'
	},

	['electronics_b_box'] = {
		label = 'Elektroonika B',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Kontrollib elektroonikat (B-tase).'
	},

	['brakes_b_box'] = {
		label = 'Pidurid B',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Peatab sõiduki (B-tase).'
	},

	['clutch_b_box'] = {
		label = 'Sidur B',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Ühendab mootori ja käigukasti (B-tase).'
	},

	['tire_b_box'] = {
		label = 'Rehv B',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Tagab haarduvuse teega (B-tase).'
	},

	-- C kategooria
	['fuel_injector_c_box'] = {
		label = 'Kütusepihusti C',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Pihustab kütust mootorisse (C-tase).'
	},

	['radiator_c_box'] = {
		label = 'Radiaator C',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Jahutab mootorit (C-tase).'
	},

	['axle_c_box'] = {
		label = 'Telg C',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Ühendab ja toetab rattaid (C-tase).'
	},

	['transmission_c_box'] = {
		label = 'Käigukast C',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Edastab võimsust ratastele (C-tase).'
	},

	['electronics_c_box'] = {
		label = 'Elektroonika C',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Kontrollib elektroonikat (C-tase).'
	},

	['brakes_c_box'] = {
		label = 'Pidurid C',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Peatab sõiduki (C-tase).'
	},

	['clutch_c_box'] = {
		label = 'Sidur C',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Ühendab mootori ja käigukasti (C-tase).'
	},

	['tire_c_box'] = {
		label = 'Rehv C',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Tagab haarduvuse teega (C-tase).'
	},

	-- D kategooria
	['fuel_injector_d_box'] = {
		label = 'Kütusepihusti D',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Pihustab kütust mootorisse (D-tase).'
	},

	['radiator_d_box'] = {
		label = 'Radiaator D',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Jahutab mootorit (D-tase).'
	},

	['axle_d_box'] = {
		label = 'Telg D',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Ühendab ja toetab rattaid (D-tase).'
	},

	['transmission_d_box'] = {
		label = 'Käigukast D',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Edastab võimsust ratastele (D-tase).'
	},

	['electronics_d_box'] = {
		label = 'Elektroonika D',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Kontrollib elektroonikat (D-tase).'
	},

	['brakes_d_box'] = {
		label = 'Pidurid D',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Peatab sõiduki (D-tase).'
	},

	['clutch_d_box'] = {
		label = 'Sidur D',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Ühendab mootori ja käigukasti (D-tase).'
	},

	['tire_d_box'] = {
		label = 'Rehv D',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Tagab haarduvuse teega (D-tase).'
	},

	-- M kategooria
	['fuel_injector_m_box'] = {
		label = 'Kütusepihusti M',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Pihustab kütust mootorisse (M-tase).'
	},

	['radiator_m_box'] = {
		label = 'Radiaator M',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Jahutab mootorit (M-tase).'
	},

	['axle_m_box'] = {
		label = 'Telg M',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Ühendab ja toetab rattaid (M-tase).'
	},

	['transmission_m_box'] = {
		label = 'Käigukast M',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Edastab võimsust ratastele (M-tase).'
	},

	['electronics_m_box'] = {
		label = 'Elektroonika M',
		weight = 5000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Kontrollib elektroonikat (M-tase).'
	},

	['brakes_m_box'] = {
		label = 'Pidurid M',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Peatab sõiduki (M-tase).'
	},

	['clutch_m_box'] = {
		label = 'Sidur M',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Ühendab mootori ja käigukasti (M-tase).'
	},

	['tire_m_box'] = {
		label = 'Rehv M',
		weight = 50000,
		stack = false,
		consume = 0,
		close = 0,
		description = 'Tagab haarduvuse teega (M-tase).'
	},

	-------------
	['scuba_gear'] = {
		label = 'Akvalangivarustus',
		weight = 8000,
		stack = 0,
		close = 1,
		consume = 0,
		description = ''
	},
	['parachute'] = {
		label = 'Langevari',
		weight = 8000,
		stack = 1,
		close = 0,
		description = ''
	},
	['binoculars'] = {
		label = 'Binoklid',
		weight = 1000,
		stack = 0,
		close = 1,
		consume = 0,
		description = 'Altul jookseb ümber poe, vaatab aknast sisse... näeb ilusaid HM-i binokleid ;)'
	},

	----- Police ----
	['handcuffs'] = {
		label = 'Käerauad',
		weight = 2000,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['alcoquant'] = {
		label = 'Alcoquant',
		weight = 1000,
		stack = false,
		close = 1,
		consume = 0,
		description = ''
	},
	
	['empty_evidence_bag'] = {
		label = 'Tühi kott',
		weight = 100,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['filled_evidence_bag'] = {
		label = 'Tõendusmaterjal',
		weight = 1000,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},

	['vehicle_clamp'] = {
		label = 'Kand',
		weight = 5000,
		stack = false,
		consume = 0,
		close = 0,
		description = ''
	},
	['blowtorch'] = {
        label = 'Gaasipõleti',
        description = 'Kuum naq suveöö...',
        weight = 1500,
        close = true,
        stack = false
    },
	
	['spikestrips'] = {
		label = 'Siilid',
		weight = 10000,
		stack = false,
		allowArmed = false,
		client = {
			export = 'kk-police.placeSpikes'
		}
	},

	
	['snake'] = {
		label = 'Salakaamera',
		weight = 2500,
		stack = 0,
		consume = 0,
		allowArmed = true 
	},

	['prop_roadcone02a'] = {
		label = 'Koonus',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['prop_barrier_work05'] = {
		label = 'Teetõke',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['prop_sign_road_01a'] = {
		label = 'Stop märk',
		weight = 800,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['prop_gazebo_03'] = {
		label = 'Telk',
		weight = 5000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['prop_worklight_03b'] = {
		label = 'Valgustus',
		weight = 2000,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	---- tasulised -----
	['xm_prop_base_tripod_lampa'] = {
		label = 'Tripodtuli',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},

	['bzzz_dream_of_lights_blue'] = {
		label = 'Sinine D',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_dream_of_lights_green'] = {
		label = 'Roheline D',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_dream_of_lights_orange'] = {
		label = 'Oranz D',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_dream_of_lights_pink'] = {
		label = 'Roosa D',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_dream_of_lights_purple'] = {
		label = 'Lilla D',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_dream_of_lights_red'] = {
		label = 'Punane D',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_dream_of_lights_white'] = {
		label = 'Valge D',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_dream_of_lights_yellow'] = {
		label = 'Kollane D',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_world_of_lamps_blue'] = {
		label = 'Sinine W',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_world_of_lamps_green'] = {
		label = 'Roheline W',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_world_of_lamps_orange'] = {
		label = 'Oranz W',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_world_of_lamps_pink'] = {
		label = 'Roosa W',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_world_of_lamps_purple'] = {
		label = 'Lilla W',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_world_of_lamps_red'] = {
		label = 'Punane W',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_world_of_lamps_white'] = {
		label = 'Valge W',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	
	['bzzz_world_of_lamps_yellow'] = {
		label = 'Kollane W',
		weight = 500,
		stack = true,
		consume = 0,
		close = 0,
		description = ''
	},
	------- prop end ----


		-- Tuner
	["tunertablet"] = {
		label = "Tunershopi tahvel",
		weight = 2000,
		stack = false,
		close = true,
		description = "Kõige vingemate autode jaoks!",
		consume = 0,
	},




	
	--kk-farming
	['barley_seed'] = { 
		label = 'Oderseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Oderseeme, ideaalne kõrge saagikusega odra kasvatamiseks.'
	},
	
	['oats_seed'] = { 
		label = 'Kaereseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Kaereseeme, suurepärane toitainerikka kaera kasvatamiseks.'
	},
	
	['rye_seed'] = { 
		label = 'Rukkiseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Rukkiseeme, ideaalne rukkileiva valmistamiseks vajaliku rukki kasvatamiseks.'
	},
	
	['corn_seed'] = { 
		label = 'Maisiseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Maisiseeme, sobib suurepäraselt maisi kasvatamiseks nii loomadele kui inimestele.'
	},
	
	['hops_seed'] = { 
		label = 'Humalaseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Humalaseeme, oluline õlle valmistamiseks vajalike humalate kasvatamiseks.'
	},
	
	['poppy_seed'] = { 
		label = 'Mooniseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Mooniseeme, sobib nii dekoratiivseteks aedtaimedeks kui ka küpsetiste jaoks.'
	},
	
	['tabacco_seed'] = { 
		label = 'Tubakaseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Tubakaseeme, sobib tubakataimede kasvatamiseks sigarite ja sigarettide valmistamiseks.'
	},
	
	['cotton_seed'] = { 
		label = 'Puuvillaseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Puuvillaseeme, sobib puuvillataimede kasvatamiseks tekstiilitootmises.'
	},
	
	['cucumber_seed'] = { 
		label = 'Kurgiseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Kurgiseeme, ideaalne mahlakate ja värskete kurkide kasvatamiseks.'
	},
	
	['eggplant_seed'] = { 
		label = 'Baklažaaniseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Baklažaaniseeme, sobib maitsvate ja toitvate baklažaanide kasvatamiseks.'
	},
	
	['onion_seed'] = { 
		label = 'Sibulaseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Sibulaseeme, ideaalne maitsekate ja aromaatsete sibulate kasvatamiseks.'
	},
	
	['pineapple_seed'] = { 
		label = 'Ananassiseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Ananassiseeme, sobib mahlakate ja magusate ananasside kasvatamiseks.'
	},
	
	['carrot_seed'] = { 
		label = 'Porgandiseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Porgandiseeme, ideaalne värviliste ja toitvate porgandite kasvatamiseks.'
	},
	
	['potato_seed'] = { 
		label = 'Kartuliseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Kartuliseeme, sobib suurepäraselt kartulite kasvatamiseks erinevate roogade jaoks.'
	},
	
	['pumpkin_seed'] = { 
		label = 'Kõrvitsaseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Kõrvitsaseeme, ideaalne suurte ja magusate kõrvitsate kasvatamiseks.'
	},
	
	['salad_seed'] = { 
		label = 'Kapsaseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Kapsaseeme, sobib värskete ja krõmpsuvate salatitesse.'
	},

	['wheat_seed'] = { 
		label = 'Nisuseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Nisuseeme, perfektne nisue kasvatamiseks.'
	},
	
	['strawberry_seed'] = { 
		label = 'Maasikaseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Maasikaseeme, ideaalne magusate ja mahlakate maasikate kasvatamiseks.'
	},
	
	['tomato_seed'] = { 
		label = 'Tomatiseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Tomatiseeme, sobib maitsvate ja mahlakate tomatite kasvatamiseks.'
	},
	
	['melon_seed'] = { 
		label = 'Meloniseeme',
		weight = 400,
		stack = true,
		close = 0,
		consume = 0,
		description = 'Meloniseeme, ideaalne suurte ja mahlakate melonite kasvatamiseks.'
	},
	
	['hops'] = { 
		label = 'Humal',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},
	
	['poppy'] = { 
		label = 'Moon',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},
	
	['tabacco'] = { 
		label = 'Tubakas',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},
	
	['cotton'] = { 
		label = 'Puuvill',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},
	
	['cucumber'] = { 
		label = 'Kurk',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},

	['onion'] = { 
		label = 'Sibul',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},
	
	['pineapple'] = { 
		label = 'Ananass',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},
	
	['carrot'] = { 
		label = 'Porgand',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},
	
	['salad'] = { 
		label = 'Salat',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},
	
	['strawberry'] = { 
		label = 'Maasikas',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},
	
	['tomato'] = { 
		label = 'Tomat',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},
	
	['melon'] = { 
		label = 'Melon',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	},
--
	['wheat'] = {
		label = 'Nisu',
		weight = 300,
		stack = 50,
		close = 1,
		description = 'Põhiline teravili, mida kasutatakse jahu ja leiva valmistamiseks.',
		consume = 0,
	},

	['corn'] = {
		label = 'Mais',
		weight = 300,
		stack = 10,
		close = 1,
		description = 'Magus ja mahlane, sobib grillimiseks või keetmiseks.',
		consume = 0,
	},

	['oats'] = {
		label = 'Kaer',
		weight = 300,
		stack = 200,
		close = 1,
		description = 'Tervislik teravili, mis sobib hästi pudru ja küpsetiste valmistamiseks.',
		consume = 0,
	},

	['rye'] = {
		label = 'Rukis',
		weight = 300,
		stack = 50,
		close = 1,
		description = 'Tummine teravili, millest tehakse traditsioonilist leiba ja jooke.',
		consume = 0,
	},
	

	['wet_tabaccoleaf'] = {
		label = 'Niiske tubakaleht',
		weight = 200,
		stack = true,
		close = 0,
		consume = 0,
		description = ''
	}, 

	['eggplant'] = {
		label = 'Baklažaan',
		weight = 300,
		stack = 1,
		close = 1,
		description = 'Maitsev ja tervislik baklažaan, ideaalne grillimiseks või hautamiseks.',
		consume = 0,
	},

		
	['pumpkin'] = {
		label = 'Kõrvits',
		weight = 500,
		stack = 2,
		close = 1,
		description = 'Suurepärane sügisköögivili, mida kasutatakse suppideks ja küpsetisteks.',
		consume = 0,
	},

		
	['cabbage'] = {
		label = 'Kapsas',
		weight = 1000,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
	
	['tomatoes'] = {
		label = 'Tomatid',
		weight = 200,
		stack = 1,
		close = 1,
		description = 'Värsked ja mahlased tomatid, ideaalne salatitesse ja pastaroogadesse.',
		consume = 0,
	},
	['watermelon'] = {
		label = 'Arbuus',
		weight = 1000,
		stack = 1,
		close = 1,
		description = 'Suur ja värskendav vili, ideaalne suvekuumuses.',
		consume = 0,
	},
	-- kk-farming end


	-- kk-fishing
	['net'] = {
		label = 'Võrk',
		weight = 1500,
		stack = false,
		close = 0,
		description = 'Keegi vist unustas...',
		consume = 0,
	},

	['tamil'] = {
		label = 'Sassis tamiil',
		weight = 2000,
		stack = false,
		close = 0,
		description = 'Amatöörid raisk...',
		consume = 0,
	},

	['stick'] = {
		label = 'Oks',
		weight = 1000,
		stack = false,
		close = 0,
		description = 'Aga, kus on nöör...',
		consume = 0,
	},

	['stump'] = {
		label = 'Vana känd',
		weight = 3200,
		stack = false,
		close = 0,
		description = 'Haisev ja kõdunenud...',
		consume = 0,
	},

	['fishingrod'] = {
		label = 'Õng',
		weight = 3000,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	},

	['fish'] = {
		label = 'Fish',
		weight = 100,
		stack = 1,
		close = 1,
		description = '',
		consume = 0,
	},
		
	['nori'] = {
		label = 'Nori',
		weight = 50,
		stack = 1,
		close = 0,
		description = 'Krõmpsuv ja maitsekas norileht, ideaalne sushi valmistamiseks.',
		consume = 0,
	},

	['salmon'] = {
		label = 'Lõhe',
		weight = 1000,
		stack = false,
		close = 0,
		description = 'Õrn ja mahlane lõhe, ideaalne grillimiseks või küpsetamiseks.',
		consume = 0,
	},

	['shrimp'] = {
		label = 'Krevetid',
		weight = 200,
		stack = 1,
		close = 0,
		description = 'Õrnad ja mahlased krevetid, ideaalne grillimiseks, praadimiseks või salatitesse.',
		consume = 0,
	},

	['bass'] = {
		label = 'Ahven',
		weight = 4000,
		stack = false,
		close = 0,
		description = 'gr3nnnn_: eino nii see ongi mingi 6-8h kalastuses omaette ja vb siis 1h normi rpd ka haha.',
		consume = 0,
	},

	['cod'] = {
		label = 'Haug',
		weight = 1000,
		stack = false,
		close = 0,
		description = 'vasj0k: kalastus tuleks üldse ära kaotada suht lamp asi nehh LUL.',
		consume = 0,
	},

	['eel'] = {
		label = 'Angerjas',
		weight = 1000,
		stack = false,
		close = 0,
		description = 'gr3nnnn_: sellepärast seda (kalapüüki) teemegi et pappi nagu muda.',
		consume = 0,
	},
	['goldfish'] = {
		label = 'Kuldkalake',
		weight = 5000,
		stack = false,
		close = 0,
		description = 'gr3nnnn_: sellepärast seda teemegi et pappi nagu muda',
		consume = 0,
	},

	['umadfish'] = {
		label = 'SaOledHullKalake',
		weight = 9000,
		stack = false,
		close = 0,
		description = 'm4rkusmg: suzyl kohe jalle 1mil koos',
		consume = 0,
	},
	
	['pufferfish'] = {
		label = 'Paisekala',
		weight = 8000,
		stack = false,
		close = 0,
		description = 'Naq õhupall',
		consume = 0,
	},


	['turtle'] = {
		label = 'Kilpkonn',
		weight = 300,
		stack = 0,
		close = 1,
		consume = 0,
		description = ''
	},

	['shark'] = {
		label = 'Haikala',
		weight = 1000,
		stack = 0,
		close = 1,
		consume = 0,
		description = ''
	},

	----- kk-mining
	
	['tin_ore'] = {
		label = 'Tinamaak',
		description = '',
		weight = 10000,
		stack = false,
		consume = 0,
		allowArmed = true 
	},

	['silver_ore'] = {
		label = 'Hõbemaak',
		description = '',
		weight = 10000,
		stack = false,
		consume = 0,
		allowArmed = true 
	},

	['iron_ore'] = {
		label = 'Rauamaak',
		description = '',
		weight = 10000,
		stack = false,
		consume = 0,
		allowArmed = true 
	},

	['gold_ore'] = {
		label = 'Kullamaak',
		description = '',
		weight = 10000,
		stack = false,
		consume = 0,
		allowArmed = true 
	},

	['copper_ore'] = {
		label = 'Vasmaak',
		description = '',
		weight = 10000,
		stack = false,
		consume = 0,
		allowArmed = true 
	},

	['mug'] = {
		label = 'Kruus',
		description = '',
		weight = 10000,
		stack = false,
		description = 'Mõni ütleb tass...',
		consume = 0,
		allowArmed = true 
	},

	['rocks'] = {
		label = 'Kivikamakad',
		description = '',
		weight = 30000,
		stack = false,
		description = 'Oh sa raisk kui rasked...',
		consume = 0,
		allowArmed = true 
	},

	['coal'] = {
		label = 'Süsi',
		description = '',
		weight = 10000,
		stack = false,
		consume = 0,
		allowArmed = true 
	},

	['steel_bar'] = {
		label = 'Teraskang',
		description = '',
		weight = 2500,
		stack = 1,
		consume = 0,
		allowArmed = true 
	},

	['silver_bar'] = {
		label = 'Hõbekang',
		description = '',
		weight = 2500,
		stack = 1,
		consume = 0,
		allowArmed = true 
	},

	['iron_bar'] = {
		label = 'Rauakang',
		description = '',
		weight = 2500,
		stack = 1,
		consume = 0,
		allowArmed = true 
	},

	['gold_bar'] = {
		label = 'Kullakang',
		description = '',
		weight = 2500,
		stack = 1,
		consume = 0,
		allowArmed = true 
	},

	['bronze_bar'] = {
		label = 'Pronkskang',
		description = '',
		weight = 2500,
		stack = 1,
		consume = 0,
		allowArmed = true 
	},
	['vehicle_key'] = {
		label = 'Autovõti',
		weight = 300,
		
		stack = false,
		close = true
	}, 

	---
	['oxy'] = {
		label = 'Oxy',
		weight = 30,
		stack = 1,
		close = 1,
		consume = 0,
		description = ''
	},
	['package'] = {
		label = 'Pakk',
		weight = 77000,
		stack = false,
		close = 1,
		consume = 0,
		description = ''
	},


	--- hunting
	['hunting_gear'] = {
		label = 'Jahivarustus',
		weight = 3000,
		stack = false,
		close = 1,
		consume = 0,
		description = 'Kõik vajalik, et ilma autota hakkama saada, sõbrake!'
	},
	['huntingbait'] = {
		label = 'Jahisööt',
		weight = 2500,
		stack = true,
		allowArmed = false,
		client = {
			export = 'kk-hunting.huntingBait'
		}
	},

	
	['a_c_boar'] = {
		label = 'Metssiga',
		weight = 23000,
		stack = true,
		allowArmed = false
	},

	['a_c_cow'] = {
		label = 'Lehm',
		weight = 84000,
		stack = true,
		allowArmed = false
	},

	['a_c_cow_stuffed'] = {
		label = 'Lehma topis',
		weight = 84000,
		stack = true,
		allowArmed = false
	},

	['a_c_coyote'] = {
		label = 'Kojott',
		weight = 17000,
		stack = true,
		allowArmed = false
	},
	
	['a_c_deer'] = {
		label = 'Hirv',
		weight = 72000,
		stack = true,
		allowArmed = false
	},

	['a_c_mtlion'] = {
		label = 'Puuma',
		weight = 19000,
		stack = true,
		allowArmed = false
	},

	['a_c_rabbit_01'] = {
		label = 'Jänes',
		weight = 4700,
		stack = true,
		allowArmed = false
	},

	['a_c_rabbit_stuffed'] = {
		label = 'Jänese topis',
		weight = 4700,
		stack = true,
		allowArmed = false
	},

	['a_c_hen'] = {
		label = 'Kana',
		weight = 4400,
		stack = true,
		allowArmed = false
	},

	['a_c_hen_stuffed'] = {
		label = 'Kana topis',
		weight = 4400,
		stack = true,
		allowArmed = false
	},
	
	['a_c_boar_carcass'] = {
		label = 'Metssea rümp',
		weight = 23000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_boar_head'] = {
		label = 'Metssea pea',
		weight = 3000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_boar_stuffed'] = {
		label = 'Metssea topis',
		weight = 6000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_boar_skin'] = {
		label = 'Metssea nahk',
		weight = 3000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_cow_carcass'] = {
		label = 'Lehma rümp',
		weight = 84000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_cow_skin'] = {
		label = 'Lehma nahk',
		weight = 8000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_coyote_carcass'] = {
		label = 'Kojotti rümp',
		weight = 17000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},
	
	['a_c_coyote_head'] = {
		label = 'Kojotti pea',
		weight = 3000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_coyote_stuffed'] = {
		label = 'Kojotti topis',
		weight = 6000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},
		
	['a_c_coyote_skin'] = {
		label = 'Kojotti nahk',
		weight = 2000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_deer_carcass'] = {
		label = 'Hirve rümp',
		weight = 72000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},
	
	['a_c_deer_head'] = {
		label = 'Hirve pea',
		weight = 5000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},
		
	['a_c_deer_stuffed'] = {
		label = 'Hirve topis',
		weight = 10000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},
			
	['a_c_deer_skin'] = {
		label = 'Hirve nahk',
		weight = 2000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_mtlion_carcass'] = {
		label = 'Puuma rümp',
		weight = 19000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_mtlion_head'] = {
		label = 'Puuma pea',
		weight = 3000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},
		
	['a_c_mtlion_stuffed'] = {
		label = 'Puuma topis',
		weight = 6000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_mtlion_skin'] = {
		label = 'Puuma nahk',
		weight = 2000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_rabbit_carcass'] = {
		label = 'Jänese rümp',
		weight = 4700,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_rabbit_skin'] = {
		label = 'Jänese nahk',
		weight = 2000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_hen_carcass'] = {
		label = 'Kana rümp',
		weight = 4400,
		stack = true,		
		close = 1,
		consume = 0,
		description = ''
	},

    ['a_c_hen_filee'] = {
		label = 'Kanafilee',
		weight = 1000,
		stack = true,		
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_hen_feather'] = {
		label = 'Kanasulg',
		weight = 100,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	['a_c_steak'] = {
		label = 'Steik',
		weight = 2000,
		stack = true,
		close = 1,
		consume = 0,
		description = ''
	},

	-- Hunting end

	--- 
	['tablet'] = {
		label = 'Tahvelarvuti',
		weight = 3000,
		stack = 0,
		close = 1,
		description = 'Siin on nüüd küll palju võimalusi...',
		client = {
			remove = function(total)
				if total < 1 then
					TriggerServerEvent('kk-tablet:main:itemRemoved')
				end
			end,
			
			export = 'kk-tablet.openTablet'
		}
	},

	['droppy_stick'] = {
		label = 'Droppy kaart',
		weight = 1000,
		stack = false,
		-- server = {
		-- 	export = 'kk-tablet.droppyStick'
		-- },
		allowArmed = true 
	},

	['selling_stick'] = {
		label = 'Müümise kaart',
		weight = 1000,
		stack = false,
		-- server = {
		-- 	export = 'kk-tablet.sellingStick'
		-- },
		allowArmed = true 
	},

}