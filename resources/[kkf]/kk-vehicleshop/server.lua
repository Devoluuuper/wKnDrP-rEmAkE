local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

local vehicles = {
    -- VAN
    ['pony2'] = {
        label = 'Pony',
        price = 46122, 
        class = 'd',
        category = 'VAN',
        hash = `pony2`,
        img = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi_4B5JrDW2_P0UADe4SqtXODmnPho1Zr5Ig&s',
        removedCar = false,
        specialVehicle = false,
        policeVehicle = false,
    },

    -- End of VAN
    ['baller'] = {
        label = 'Baller',
        price = 46122, 
        class = 'c',
        category = 'SUV',
        hash = `baller`,
        img = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi_4B5JrDW2_P0UADe4SqtXODmnPho1Zr5Ig&s',
        removedCar = false,
        specialVehicle = false,
        policeVehicle = false,
    },

    ['baller2'] = {
        label = 'Baller II',
        price = 120000, 
        class = 'c',
        category = 'SUV',
        hash = `baller2`,
        img = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi_4B5JrDW2_P0UADe4SqtXODmnPho1Zr5Ig&s',
        removedCar = false,
        specialVehicle = false,
        policeVehicle = false,
    },
	
	['baller3'] = {
        label = 'Baller III',
        price = 120000, 
        class = 'b',
        category = 'SUV',
        hash = `baller3`,
        img = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi_4B5JrDW2_P0UADe4SqtXODmnPho1Zr5Ig&s',
        removedCar = false,
        specialVehicle = false,
        policeVehicle = false,
    },
	
	['baller4'] = {
        label = 'Baller IIII',
        price = 120000, 
        class = 'b',
        category = 'SUV',
        hash = `baller4`,
        img = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi_4B5JrDW2_P0UADe4SqtXODmnPho1Zr5Ig&s',
        removedCar = false,
        specialVehicle = false,
        policeVehicle = false,
    },
	
	['bjxl'] = {
        label = 'BeeJay XL',
        price = 120000, 
        class = 'c',
        category = 'SUV',
        hash = `bjxl`,
        img = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi_4B5JrDW2_P0UADe4SqtXODmnPho1Zr5Ig&s',
        removedCar = false,
        specialVehicle = false,
        policeVehicle = false,
    },
	
	['cavalcade'] = {
        label = 'Cavalcade',
        price = 120000, 
        class = 'c',
        category = 'SUV',
        hash = `cavalcade`,
        img = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi_4B5JrDW2_P0UADe4SqtXODmnPho1Zr5Ig&s',
        removedCar = false,
        specialVehicle = false,
        policeVehicle = false,
    },
	
	['cavalcade2'] = {
        label = 'Cavalcade II',
        price = 120000, 
        class = 'c',
        category = 'SUV',
        hash = `cavalcade2`,
        img = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi_4B5JrDW2_P0UADe4SqtXODmnPho1Zr5Ig&s',
        removedCar = false,
        specialVehicle = false,
        policeVehicle = false,
    },
	
-- 	['contender'] = {
--         label = 'Contender',
--         price = 120000, 
--         class = 'c',
--         category = 'SUV',
--         hash = `contender`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993157104732999790/unknown.png'
--     },
	
-- 	['dubsta'] = {
--         label = 'Dubsta',
--         price = 120000, 
--         class = 'c',
--         category = 'SUV',
--         hash = `dubsta`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993157751192686652/unknown.png'
--     },
	
-- 	['dubsta2'] = {
--         label = 'Dubsta II',
--         price = 120000, 
--         class = 'c',
--         category = 'SUV',
--         hash = `dubsta2`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993160789475217498/unknown.png'
--     },
	
-- 	['fq2'] = {
--         label = 'FQ 2',
--         price = 120000, 
--         class = 'c',
--         category = 'SUV',
--         hash = `fq2`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993161723034992681/unknown.png'
--     },
	
-- 	['granger'] = {
--         label = 'Granger',
--         price = 120000, 
--         class = 'c',
--         category = 'SUV',
--         hash = `granger`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993162234832375848/unknown.png'
--     },
	
-- 	['granger2'] = {
--         label = 'Granger II',
--         price = 120000, 
--         class = 'c',
--         category = 'SUV',
--         hash = `granger2`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993164558418063370/unknown.png'
--     },
	
-- 	['jubilee'] = {
--         label = 'Jubilee',
--         price = 120000, 
--         class = 'a',
--         category = 'SUV',
--         hash = `jubilee`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993165318291718254/unknown.png'
--     },
	
-- 	['astron'] = {
--         label = 'Astron',
--         price = 120000, 
--         class = 'a',
--         category = 'SUV',
--         hash = `astron`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993165775512809493/unknown.png'
--     },
	
-- 	['gresley'] = {
--         label = 'Gresley',
--         price = 120000, 
--         class = 'b',
--         category = 'SUV',
--         hash = `gresley`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993166477983219732/unknown.png'
--     },
	
-- 	['habanero'] = {
--         label = 'Habanero',
--         price = 120000, 
--         class = 'c',
--         category = 'SUV',
--         hash = `habanero`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993167079547076668/unknown.png'
--     },
	
-- 	['huntley'] = {
--         label = 'Huntley',
--         price = 120000, 
--         class = 'c',
--         category = 'SUV',
--         hash = `huntley`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993167444929687552/unknown.png'
--     },
	
-- 	['landstalker'] = {
--         label = 'Landstalker',
--         price = 120000, 
--         class = 'c',
--         category = 'SUV',
--         hash = `landstalker`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993167884903784510/unknown.png'
--     },
	
-- 	['landstalker2'] = {
--         label = 'Landstalker II',
--         price = 120000, 
--         class = 'b',
--         category = 'SUV',
--         hash = `landstalker2`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993169886698274826/unknown.png'
--     },
	
-- 	['mesa'] = {
--         label = 'Mesa',
--         price = 120000, 
--         class = 'd',
--         category = 'SUV',
--         hash = `mesa`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993170273144680498/unknown.png'
--     },
	
-- 	['novak'] = {
--         label = 'Novak',
--         price = 120000, 
--         class = 'c',
--         category = 'SUV',
--         hash = `novak`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993170273144680498/unknown.png'
--     },
	
-- 	['patriot'] = {
--         label = 'Patriot',
--         price = 120000, 
--         class = 'b',
--         category = 'SUV',
--         hash = `patriot`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993171283934183574/unknown.png'
--     },
	
-- 	['patriot2'] = {
--         label = 'Patriot II',
--         price = 120000, 
--         class = 'b',
--         category = 'SUV',
--         hash = `patriot2`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993171987977478274/unknown.png'
--     },
	
-- 	['radi'] = {
--         label = 'Radius',
--         price = 120000, 
--         class = 'd',
--         category = 'SUV',
--         hash = `radi`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993172579483406386/unknown.png'
--     },
	
-- 	['rebla'] = {
--         label = 'Rebla GTS',
--         price = 120000, 
--         class = 'a',
--         category = 'SUV',
--         hash = `rebla`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993174192658858184/unknown.png'
--     },
	
-- 	['rocoto'] = {
--         label = 'Rocoto',
--         price = 120000, 
--         class = 'b',
--         category = 'SUV',
--         hash = `rocoto`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993174567034044438/unknown.png'
--     },

-- 	['seminole'] = {
--         label = 'Seminole',
--         price = 120000, 
--         class = 'c',
--         category = 'SUV',
--         hash = `seminole`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993175184716615741/unknown.png'
--     },	


-- 	['seminole2'] = {
--         label = 'Seminole Frontier',
--         price = 120000, 
--         class = 'c',
--         category = 'SUV',
--         hash = `seminole2`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993175184716615741/unknown.png'
--     },	

-- 	['serrano'] = {
--         label = 'Serrano',
--         price = 120000, 
--         class = 'd',
--         category = 'SUV',
--         hash = `serrano`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993176135984746506/unknown.png'
--     },	

-- 	['xls'] = {
--         label = 'XLS',
--         price = 120000, 
--         class = 'a',
--         category = 'SUV',
--         hash = `xls`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993176965890703501/unknown.png'
--     },	

-- 	['squaddie'] = {
--         label = 'Squaddie',
--         price = 120000, 
--         class = 'a',
--         hash = `squaddie`,
--         img = 'https://cdn.discordapp.com/attachments/821049635824730132/993177857809461338/unknown.png'
--     },
	
-- 	['baller7'] = { --updated
--         label = 'Baller ST',
--         price = 120000, 
--         class = 'b',
--         category = 'SUV',
--         hash = `baller7`,
--         img = 'https://gtacars.net/images/136b1591019513983e514c99c3c1527c'
--     },	
	
-- 	['iwagen'] = {
--         label = 'I-Wagen',
--         price = 120000, 
--         class = 'a',
--         category = 'SUV',
--         hash = `iwagen`,
--         img = 'https://gtacars.net/images/a46dbb756e7ce89850cd6b70630c455f'
--     },	
	
-- 	['patriot3'] = {
--         label = 'Patriot Mil-Spec',
--         price = 120000, 
--         class = 'a',
--         category = 'SUV',
--         hash = `patriot3`,
--         img = 'https://gtacars.net/images/a46dbb756e7ce89850cd6b70630c455f'
--     },	
-- --street
-- 	['asea'] = {
--         label = 'Asea',
--         price = 28000, 
--         class = 'd',
--         category = 'Sedans',
--         hash = `asea`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993180430180298762/unknown.png'
--     },

-- 	['asbo'] = {
--         label = 'Asbo',
--         price = 120000, 
--         class = 'd',
--         category = 'Compacts',
--         hash = `asbo`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993183534221111416/unknown.png'
--     },

-- 	['blista'] = {
--         label = 'Blista',
--         price = 32000, 
--         class = 'c',
--         category = 'Compacts',
--         hash = `blista`,
--         img = 'https://cdn.discordapp.com/attachments/938906949284667492/993183775917867208/unknown.png'
--     },
	
-- 	['brioso'] = {
--         label = 'Brioso',
--         price = 56000, 
--         class = 'c',
--         category = 'Compacts',
--         hash = `brioso`,
--         img = 'https://gtacars.net/images/ec04a2f81196dfc9dcc10e517630f5f8'
--     },

-- 	['club'] = {
--         label = 'Club',
--         price = 120000, 
--         class = 'd',
--         category = 'Compacts',
--         hash = `club`,
--         img = 'https://gtacars.net/images/6adca2931c8e034e62323194585ed517'
--     },

-- 	['dilettante'] = {
--         label = 'Dilettante',
--         price = 34000, 
--         class = 'd',
--         category = 'Compacts',
--         hash = `dilettante`,
--         img = 'https://gtacars.net/images/9f7a3651b408c544c3ce7c9250772503'
--     },
	
-- 	['kanjo'] = {
--         label = 'kanjo',
--         price = 120000, 
--         class = 'a',
--         category = 'Compacts',
--         hash = `kanjo`,
--         img = 'https://gtacars.net/images/0e512a64cccb8adec297578b3e7feaa9'
--     },

-- 	['issi2'] = {
--         label = 'Issi',
--         price = 40000, 
--         class = 'c',
--         category = 'Compacts',
--         hash = `issi2`,
--         img = 'https://gtacars.net/images/6bdb08262de062014ba0e41f4b7e637c'
--     },

-- 	['issi3'] = {
--         label = 'Issi classic',
--         price = 28000, 
--         class = 'd',
--         category = 'Compacts',
--         hash = `issi3`,
--         img = 'https://gtacars.net/images/0ea9863b0ff61f913b77744cec5d3400'
--     },

-- 	['panto'] = {
--         label = 'Panto',
--         price = 20000, 
--         class = 'c',
--         category = 'Compacts',
--         hash = `panto`,
--         img = 'https://gtacars.net/images/6a32e6bde44473f2870c0ac4522b8dac'
--     },
	
-- 	['prairie'] = {
--         label = 'Prairie',
--         price = 120000, 
--         class = 'c',
--         category = 'Compacts',
--         hash = `prairie`,
--         img = 'https://gtacars.net/images/a5096e93c5d2f3cd5dc89ff6e834879d'
--     },
-- 	['rhapsody'] = {
--         label = 'Rhapsody',
--         price = 50000, 
--         class = 'd',
--         category = 'Compacts',
--         hash = `rhapsody`,
--         img = 'https://gtacars.net/images/a035c8b6aaec131ed645170c8f588932'
--     },

-- 	['brioso2'] = {
--         label = 'Brioso 300',
--         price = 46000, 
--         class = 'd',
--         category = 'Compacts',
--         hash = `brioso2`,
--         img = 'https://gtacars.net/images/ec04a2f81196dfc9dcc10e517630f5f8'
--     },

-- 	['weevil'] = {
--         label = 'Weevil',
--         price = 120000, 
--         class = 'd',
--         category = 'Compacts',
--         hash = `weevil`,
--         img = 'https://gtacars.net/images/551dc919cf92fab2374ec7cc5fcd3cbc'
--     },

-- 	['exemplar'] = {
--         label = 'Exemplar',
--         price = 120000, 
--         class = 'b',
--         category = 'Compacts',
--         hash = `exemplar`,
--         img = 'https://gtacars.net/images/f7c531248fea1e37eba6cc93d7345715'
--     },

-- 	['f620'] = {
--         label = 'F 620',
--         price = 120000, 
--         class = 'b',
--         category = 'Compacts',
--         hash = `f620`,
--         img = 'https://gtacars.net/images/1e4634da4835956e450fa3cdbd5d0d85'
--     },

-- 	['felon'] = {
--         label = 'Felon',
--         price = 120000, 
--         class = 'b',
--         category = 'Compacts',
--         hash = `felon`,
--         img = 'https://gtacars.net/images/a7a298c3d9942c50d23de135e388ff8d'
--     },

-- 	['felon2'] = {
--         label = 'Felon GT',
--         price = 120000, 
--         category = 'Compacts',
--         class = 'b',
--         hash = `felon2`,
--         img = 'https://gtacars.net/images/4760dcdeb96e5ee763061bf29d9ee831'
--     },

-- 	['jackal'] = {
--         label = 'Jackal',
--         price = 120000, 
--         class = 'b',
--         category = 'Compacts',
--         hash = `jackal`,
--         img = 'https://gtacars.net/images/133a18f5b210db972c9f6fc1ddbfd0c8'
--     },

-- 	['oracle'] = {
--         label = 'Oracle',
--         price = 120000, 
--         class = 'b',
--         hash = `oracle`,
--         category = 'Compacts',
--         img = 'https://gtacars.net/images/e11de2216bf3c6d4a1e1f04ddec6780c'
--     },

-- 	['oracle2'] = {
--         label = 'Oracle XS',
--         price = 120000, 
--         class = 'c',
--         category = 'Compacts',
--         hash = `oracle2`,
--         img = 'https://gtacars.net/images/7173b7d21d663cc1d6a810cb804e047a'
--     },
	
-- 	['sentinel2'] = {
--         label = 'Sentinel',
--         price = 120000, 
--         class = 'b',
--         category = 'Compacts',
--         hash = `sentinel2`,
--         img = 'https://gtacars.net/images/de95c562b004963319c4db755670843e'
--     },
	
-- 	['windsor'] = {
--         label = 'Windsor',
--         price = 120000, 
--         class = 'a',
--         category = 'Compacts',
--         hash = `windsor`,
--         img = 'https://gtacars.net/images/3883dbb59ef85bb83b172c9e83b66e97'
--     },
	
-- 	['windsor2'] = {
--         label = 'Windsor Drop',
--         price = 120000, 
--         class = 'a',
--         category = 'Compacts',
--         hash = `windsor2`,
--         img = 'https://gtacars.net/images/ecce4683e7140feb72561fb489e12c66'
--     },
	
-- 	['zion'] = {
--         label = 'Zion',
--         price = 120000, 
--         class = 'c',
--         category = 'Compacts',
--         hash = `zion`,
--         img = 'https://gtacars.net/images/fd7bcbbaa92f793c7ef96aa34b992774'
--     },
	
-- 	['zion2'] = {
--         label = 'Zino Cabrio',
--         price = 120000, 
--         class = 'c',
--         category = 'Compacts',
--         hash = `zion2`,
--         img = 'https://gtacars.net/images/c6f80da63e16c771b44eb13b1f3e8b3e'
--     },
-- 	------------- Sedans
-- 	['previon'] = {
--         label = 'Previon',
--         price = 120000, 
--         class = 'b',
--         category = 'Sedans',
--         hash = `previon`,
--         img = ''
--     },

-- 	['asterope'] = {
--         label = 'Asterope',
--         price = 34000, 
--         class = 'c',
--         category = 'Sedans',
--         hash = `asterope`,
--         img = 'https://gtacars.net/images/328761ce2a0d435e71b133d4413d6f61'
--     },

-- 	['cog55'] = {
--         label = 'Cognoscenti 55',
--         price = 120000, 
--         class = 'b',
--         category = 'Sedans',
--         hash = `cog55`,
--         img = 'https://gtacars.net/images/611906dbe0c5dcb22c5be93143145d5f'
--     },

-- 	['cognoscenti'] = {
--         label = 'Cognoscenti',
--         price = 120000, 
--         class = 'b',
--         category = 'Sedans',
--         hash = `cognoscenti`,
--         img = 'https://gtacars.net/images/773bd6df467035a068a47c54dd09b7b6'
--     },

-- 	['emperor'] = {
--         label = 'Emperor',
--         price = 120000, 
--         class = 'd',
--         category = 'Sedans',
--         hash = `emperor`,
--         img = 'https://gtacars.net/images/43b36f2b1c192dc1b13a727fb365ba4a'
--     },

-- 	['emperor2'] = {
--         label = 'Beater Emperor',
--         price = 120000, 
--         class = 'd',
--         category = 'Sedans',
--         hash = `emperor2`,
--         img = 'https://gtacars.net/images/055d29095e6e30c708c581661751798d'
--     },

-- 	['fugitive'] = {
--         label = 'Fugitive',
--         price = 120000, 
--         class = 'c',
--         category = 'Sedans',
--         hash = `fugitive`,
--         img = 'https://gtacars.net/images/898ee5123da9595ef2c8a10fbbffb26e'
--     },

-- 	['glendale'] = {
--         label = 'Glendale',
--         price = 50000, 
--         class = 'c',
--         category = 'Sedans',
--         hash = `glendale`,
--         img = 'https://gtacars.net/images/b6df4a6d5f26cc1463ed0c230d808ca2'
--     },

-- 	['glendale2'] = {
--         label = 'Glendale Custom',
--         price = 120000, 
--         class = 'c',
--         category = 'Sedans',
--         hash = `glendale2`,
--         img = 'https://gtacars.net/images/0d6e3ec9a1c94d03327c553f7185c1e7'
--     },

-- 	['ingot'] = {
--         label = 'Ingot',
--         price = 24000, 
--         class = 'd',
--         hash = `ingot`,
--         img = 'https://gtacars.net/images/cbc95622365f7990a846b90242137075'
--     },
	
-- 	['intruder'] = {
--         label = 'Intruder',
--         price = 44000, 
--         class = 'd',
--         category = 'Sedans',
--         hash = `intruder`,
--         img = 'https://gtacars.net/images/5abe4ed2eb395e0bb4c81cf17a255200'
--     },
	
-- 	['premier'] = {
--         label = 'Premier',
--         price = 60000, 
--         class = 'd',
--         category = 'Sedans',
--         hash = `premier`,
--         img = 'https://gtacars.net/images/deae4ef216190e522637c051bd1dea5d'
--     },
	
-- 	['primo'] = {
--         label = 'Primo',
--         price = 50000, 
--         class = 'd',
--         category = 'Sedans',
--         hash = `primo`,
--         img = 'https://gtacars.net/images/c825803d722f5cb4cf11b3a2580eceb6'
--     },
	
-- 	['primo2'] = {
--         label = 'Primo Custom',
--         price = 120000, 
--         class = 'c',
--         category = 'Sedans',
--         hash = `primo2`,
--         img = 'https://gtacars.net/images/0c07c69f98c40176fb346f65e4047014'
--     },
	
-- 	['romero'] = {
--         label = 'Romero Hearse',
--         price = 120000, 
--         class = 'd',
--         category = 'Sedans',
--         hash = `romero`,
--         img = 'https://gtacars.net/images/6ffe1217c48dca573027bd1724495e19'
--     },
	
-- 	['stafford'] = {
--         label = 'Stafford',
--         price = 120000, 
--         class = 'a',
--         category = 'Sedans',
--         hash = `stafford`,
--         img = 'https://gtacars.net/images/1345af5cae54e3d24e8bbf96822656a3'
--     },
	
-- 	['stanier'] = {
--         label = 'Stanier',
--         price = 20000, 
--         class = 'd',
--         category = 'Sedans',
--         hash = `stanier`,
--         img = 'https://gtacars.net/images/f66dbb897a2611fe66e717029f54a286'
--     },

--     ['stanier4'] = {
--         label = 'Vapid Stanier Sport',
--         price = 20000, 
--         class = 'd',
--         category = 'Sedans',
--         hash = `stanier4`,
--         img = 'https://gtacars.net/images/f66dbb897a2611fe66e717029f54a286'
--     },
	
-- 	['stretch'] = {
--         label = 'Stretch',
--         price = 120000, 
--         class = 'c',
--         category = 'Sedans',
--         hash = `stretch`,
--         img = 'https://gtacars.net/images/eaaefd38338e7a91bc93f368a5d804f6'
--     },

-- 	['sd'] = {
--         label = 's Diamond',
--         price = 120000, 
--         class = 's',
--         category = 'Sedans',
--         hash = `sd`,
--         img = 'https://gtacars.net/images/9697b1925c8c4ff99bf72aee9bf685b9'
--     },

-- 	['surge'] = {
--         label = 'Surge',
--         price = 50000, 
--         class = 'c',
--         category = 'Sedans',
--         hash = `surge`,
--         img = 'https://gtacars.net/images/a203f2c59ef3957e496d49d8270df1e9'
--     },

-- 	['tailgater'] = {
--         label = 'Tailgater',
--         price = 120000, 
--         class = 'c',
--         category = 'Sedans',
--         hash = `tailgater`,
--         img = 'https://gtacars.net/images/a95907490aac7fb1bef5adcefe924ab8'
--     },

-- 	['warrener'] = {
--         label = 'Warrener',
--         price = 120000, 
--         class = 'c',
--         category = 'Sedans',
--         hash = `warrener`,
--         img = 'https://gtacars.net/images/a54505c98b8abac3298f70522a86ae5d'
--     },

-- 	['warrener2'] = {
--         label = 'Warrener HKR',
--         price = 120000, 
--         class = 'c',
--         category = 'Sedans',
--         hash = `warrener2`,
--         img = 'https://gtacars.net/images/9ce5830e8b0968615270c8d3e7377fd2'
--     },

-- 	['washington'] = {
--         label = 'washington',
--         price = 120000, 
--         class = 'c',
--         category = 'Sedans',
--         hash = `washington`,
--         img = 'https://gtacars.net/images/60d6e5f630f8a261945bef19d88132a4'
--     },

-- 	['tailgater2'] = {
--         label = 'Tailgater S',
--         price = 120000, 
--         class = 'b',
--         category = 'Sedans',
--         hash = `tailgater2`,
--         img = 'https://gtacars.net/images/0ab59545f03405d62e1256ae59f288b8'
--     },
	
-- 	['cinquemila'] = {
--         label = 'Cinquemila',
--         price = 120000, 
--         class = 'b',
--         category = 'Sedans',
--         hash = `cinquemila`,
--         img = 'https://gtacars.net/images/38a6933cd02a4b767aabced7f0ba6ea1'
--     },
	
-- 	['deity'] = {
--         label = 'Deity',
--         price = 120000, 
--         class = 'b',
--         category = 'Sedans',
--         hash = `deity`,
--         img = 'https://gtacars.net/images/1bf58b80e3657c282c9dc50c08736040'
--     },
-- --offroad

-- 	['bfinjection'] = {
--         label = 'Injection',
--         price = 120000, 
--         class = 'd',
--         category = 'Off-Road',
--         hash = `bfinjection`,
--         img = 'https://gtacars.net/images/f272633cca7f5146d7ed215eea4d94ae'
--     },

-- 	['bifta'] = {
--         label = 'Bifta',
--         price = 120000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `bifta`,
--         img = 'https://gtacars.net/images/ad68bc9c1e568e851687700bd9f3fdc3'
--     },

-- 	['blazer'] = {
--         label = 'Blazer',
--         price = 40000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `blazer`,
--         img = 'https://gtacars.net/images/13225dc1a5c96e4de2caa698e948cdd9'
--     },
	
-- 	['blazer3'] = {
--         label = 'Hot Rod Blazer',
--         price = 45000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `blazer3`,
--         img = 'https://gtacars.net/images/9492a5fca0b0a7989704dad8c6ac0d90'
--     },
	
-- 	['blazer4'] = {
--         label = 'Street Blazer',
--         price = 50000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `blazer4`,
--         img = 'https://gtacars.net/images/572402664774936e6f56cc70040ab714'
--     },
	
-- --[[	['blazer5'] = {
--         label = 'Blazer Aqua',
--         price = 120000, 
--         class = 'c',
--         hash = `blazer5`,
--         img = 'https://gtacars.net/images/899213b08f194e8a4025955dffbe2a2d'
--     },]]
	
-- 	['bodhi2'] = {
--         label = 'Bodhi',
--         price = 120000, 
--         class = 'd',
--         category = 'Off-Road',
--         hash = `bodhi2`,
--         img = 'https://gtacars.net/images/85c92233f9331f58ef2f1f7b407cd373'
--     },
	
-- 	['caracara2'] = {
--         label = 'Caracara 4x4',
--         price = 120000, 
--         class = 'b',
--         category = 'Off-Road',
--         hash = `caracara2`,
--         img = 'https://gtacars.net/images/6347430b71f6c3e042efb1eb11991e32'
--     },
	
-- 	['dloader'] = {
--         label = 'Duneloader',
--         price = 120000, 
--         class = 'd',
--         category = 'Off-Road',
--         hash = `dloader`,
--         img = 'https://gtacars.net/images/245c1c82a82c476de81d232527ff05c4'
--     },
	
-- 	['everon'] = {
--         label = 'Everon',
--         price = 120000, 
--         class = 'b',
--         category = 'Off-Road',
--         hash = `everon`,
--         img = 'https://gtacars.net/images/3fbeb3dfd3cc418ad89d898f1497628e'
--     },
	
-- 	['freecrawler'] = {
--         label = 'Freecrawler',
--         price = 120000, 
--         class = 'b',
--         category = 'Off-Road',
--         hash = `freecrawler`,
--         img = 'https://gtacars.net/images/d2b06da4b80a44b510c52c947ba11be0'
--     },
	
-- 	['hellion'] = {
--         label = 'hellion',
--         price = 120000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `hellion`,
--         img = 'https://gtacars.net/images/500970e99b17d36a6d815b7d627405ba'
--     },

-- 	['kalahari'] = {
--         label = 'Kalahari',
--         price = 120000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `kalahari`,
--         img = 'https://gtacars.net/images/d6798590f9068fa1d2968283896186e3'
--     },

-- 	['kamacho'] = {
--         label = 'Kamacho',
--         price = 120000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `kamacho`,
--         img = 'https://gtacars.net/images/7058e4ed99359839e5b4eab51a57a33d'
--     },

-- 	['mesa3'] = {
--         label = 'Mesa',
--         price = 120000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `mesa3`,
--         img = 'https://gtacars.net/images/19b721a6e15a67482318227660baa635'
--     },

-- 	['rancherxl'] = {
--         label = 'Rancher XL',
--         price = 120000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `rancherxl`,
--         img = 'https://gtacars.net/images/0b3787ab425c0d7a139b249dcf6584bd'
--     },

-- 	['rebel'] = {
--         label = 'Rebel',
--         price = 39000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `rebel`,
--         img = 'https://gtacars.net/images/7bbd36aa5949a7532da243cb738674bc'
--     },

-- 	['rebel2'] = {
--         label = 'Rusty Rebel',
--         price = 120000, 
--         class = 'd',
--         category = 'Off-Road',
--         hash = `rebel2`,
--         img = 'https://gtacars.net/images/7bbd36aa5949a7532da243cb738674bc'
--     },
	
-- 	['riata'] = {
--         label = 'Riata',
--         price = 120000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `riata`,
--         img = 'https://gtacars.net/images/e9abd0a2f9588568013a7b0031ded0dc'
--     },
	
-- 	['sandking'] = {
--         label = 'Sandking XL',
--         price = 120000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `sandking`,
--         img = 'https://gtacars.net/images/021579105e8c9ceaf5e8c43dbe284c03'
--     },
	
-- 	['sandking2'] = {
--         label = 'Sandking SWB',
--         price = 120000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `sandking2`,
--         img = 'https://gtacars.net/images/bcb25c384e006897f5035dc060d96694'
--     },
	
-- 	['vagrant'] = {
--         label = 'Vagrant',
--         price = 120000, 
--         class = 'b',
--         category = 'Off-Road',
--         hash = `vagrant`,
--         img = 'https://gtacars.net/images/64de358cc51812fca594ef252339b638'
--     },
	
-- 	['verus'] = {
--         label = 'Verus',
--         price = 120000, 
--         class = 'c',
--         category = 'Off-Road',
--         hash = `versus`,
--         img = 'https://gtacars.net/images/2422f76ce3ceb55a13fdd1dab5a2db66'
--     },
-- --sport		
-- 	['drafter'] = {
--         label = '8F Drafter',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `drafter`,
--         img = 'https://gtacars.net/images/601ee8a8f5edfe8deb9fedb8ffef499f'
--     },
	
-- 	['ninef'] = {
--         label = '9F',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `ninef`,
--         img = 'https://gtacars.net/images/fc00d0c7b1a8eb0f3fd44e8de2d2a009'
--     },
	
-- 	['ninef2'] = {
--         label = '9F Cabrio',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `ninef2`,
--         img = 'https://gtacars.net/images/16aeceef84e24582df7e1c3ec6da2830'
--     },
	
-- 	['alpha'] = {
--         label = 'Alpha',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `alpha`,
--         img = 'https://gtacars.net/images/62681ede25ee721be4b9c46275522ae8'
--     },
	
-- 	['banshee'] = {
--         label = 'Banshee',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `banshee`,
--         img = 'https://gtacars.net/images/053ab32dabea586fa2864208453b8a6e'
--     },
	
-- 	['bestiagts'] = {
--         label = 'Bestia GTS',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `bestiagts`,
--         img = 'https://gtacars.net/images/62d53d00a10958e05016ff1f9ce9eef6'
--     },
	
-- 	['blista2'] = {
--         label = 'Blista Compact',
--         price = 120000, 
--         class = 'd',
--         category = 'Sports',
--         hash = `blista2`,
--         img = 'https://gtacars.net/images/0878123b7e4b738095544d2ada436f5b'
--     },
	
-- 	['buffalo'] = {
--         label = 'Buffalo',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `buffalo`,
--         img = 'https://gtacars.net/images/645819058f3bc44c42224cdc675ca178'
--     },
	
-- 	['buffalo2'] = {
--         label = 'Buffalo S',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `buffalo2`,
--         img = 'https://gtacars.net/images/572fde59aab87e66ae36fd92a3e5cb9a'
--     },
	
-- 	['calico'] = {
--         label = 'Calico GTF',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `calico`,
--         img = 'https://gtacars.net/images/0aafb25d151cb3a76fbbccc259b81be1'
--     },
	
-- 	['carbonizzare'] = {
--         label = 'Carbonizzare',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `carbonizzare`,
--         img = 'https://gtacars.net/images/81911488704264e57446a88f9bd5854d'
--     },
	
-- 	['comet'] = {
--         label = 'Comet',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `comet`,
--         img = 'https://gtacars.net/images/344d2921d59ac99df594e720bb946a37'
--     },
	
-- 	['comet3'] = {
--         label = 'Comet Retro Custom',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `comet3`,
--         img = 'https://gtacars.net/images/ddeb20a2b62fd2d2d7e45805a6aa6375'
--     },

-- 	['comet6'] = {
--         label = 'Comet S2',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `comet6`,
--         img = 'https://gtacars.net/images/0f83212470f25aae97a236f2161cfd03'
--     },

-- 	['comet7'] = {
--         label = 'Comet S2 Cabrio',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `comet7`,
--         img = 'https://gtacars.net/images/fea4da7b31358eeea1b133987ca81765'
--     },
	
-- 	['comet5'] = {
--         label = 'Comet SR',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `comet5`,
--         img = 'https://gtacars.net/images/f20a7fe3c03e55aa6ac04c0db2a1fc90'
--     },
	
-- 	['comet4'] = {
--         label = 'Comet Safari',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `comet4`,
--         img = 'https://gtacars.net/images/3327020704521d694ea57d70f35fcb35'
--     },
	
-- 	['coquette'] = {
--         label = 'Coquette',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `coquette`,
--         img = 'https://gtacars.net/images/24b8bdaf1db2cf3d88fbacf163dbfd3e'
--     },
	
-- 	['coquette4'] = {
--         label = 'Coquette D10',
--         price = 120000, 
--         class = 's',
--         category = 'Sports',
--         hash = `coquette4`,
--         img = 'https://gtacars.net/images/4ef2f283a9428d1f3641e76c0307a043'
--     },
	
-- 	['cypher'] = {
--         label = 'Cypher',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `cypher`,
--         img = 'https://gtacars.net/images/e994d2238d5211a4f8cf5f2e5ff686b8'
--     },
	
-- 	['tampa2'] = {
--         label = 'Drift Tampa',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `tampa2`,
--         img = 'https://gtacars.net/images/85e7b7cc046f87b74f9ce81c1a881ca9'
--     },
	
-- 	['elegy2'] = {
--         label = 'Elegy RH8',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `elegy2`,
--         img = 'https://gtacars.net/images/306c15592e7dfd0d9ce73f85d0cd432a'
--     },

-- 	['elegy'] = {
--         label = 'Elegy Retro Custom',
--         price = 120000, 
--         class = 's',
--         category = 'Sports',
--         hash = `elegy`,
--         img = 'https://gtacars.net/images/ecac7651b94091e083e5068e03264843'
--     },

-- 	['euros'] = {
--         label = 'Euros',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `euros`,
--         img = 'https://gtacars.net/images/71705592df5c0d18855809f0d074ab7c'
--     },

-- 	['feltzer2'] = {
--         label = 'Feltzer',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `feltzer2`,
--         img = 'https://gtacars.net/images/f758e8ef10273636c830d7aed8305333'
--     },

-- 	['flashgt'] = {
--         label = 'Flash GT',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `flashgt`,
--         img = 'https://gtacars.net/images/db47f6a8d9d26d951f361cbaa2536d56'
--     },

-- 	['furoregt'] = {
--         label = 'Furore GT',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `furoregt`,
--         img = 'https://gtacars.net/images/42775b3635375597405696ff660951bb'
--     },

-- 	['fusilade'] = {
--         label = 'Fusilade',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports',
--         hash = `fusilade`,
--         img = 'https://gtacars.net/images/5881299dbb093221d05c7e586299947a'
--     },

-- 	['futo'] = {
--         label = 'Futo',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports',
--         hash = `futo`,
--         img = 'https://gtacars.net/images/8f09ecdb4bf6c5c1a64e10a8d9c92456'
--     },

-- 	['futo2'] = {
--         label = 'Futo GTX',
--         price = 120000, 
--         category = 'Sports',
--         class = 'c',
--         hash = `futo2`,
--         img = 'https://gtacars.net/images/7f1f6dd2259bfeac5f5b85c6ec008d01'
--     },

-- 	['gb200'] = {
--         label = 'GB200',
--         price = 120000, 
--         category = 'Sports',
--         class = 'a',
--         hash = `gb200`,
--         img = 'https://gtacars.net/images/aa94af09150a58daf5d486fb7bc6030c'
--     },

-- 	['growler'] = {
--         label = 'Growler',
--         price = 120000, 
--         category = 'Sports',
--         class = 'a',
--         hash = `growler`,
--         img = 'https://gtacars.net/images/6b06c411ec28d9fa5840a7a49c32e36e'
--     },

-- 	['hotring'] = {
--         label = 'Hotring Sabre',
--         price = 120000, 
--         category = 'Sports',
--         class = 's',
--         hash = `hotring`,
--         img = 'https://gtacars.net/images/8f0b5732a807bee74acb0659aace27d1'
--     },
	
-- 	['imorgon'] = {
--         label = 'Imorgon',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `imorgon`,
--         img = 'https://gtacars.net/images/897345b381283ea77e5831577c8a5d0b'
--     },
	
-- 	['issi7'] = {
--         label = 'Issi Sport',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `issi7`,
--         img = 'https://gtacars.net/images/155be5e958df8d5fa0161ab9b9561d74'
--     },

-- 	['italigto'] = {
--         label = 'Itali GTO',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `italigto`,
--         img = 'https://gtacars.net/images/ba7acf6b4aff2f62b02f9234810713df'
--     },

-- 	['italirsx'] = {
--         label = 'Itali RSX',
--         price = 120000, 
--         class = 's',
--         category = 'Sports',
--         hash = `italirsx`,
--         img = 'https://gtacars.net/images/74042388552efb0b3b4b483fccfbdba9'
--     },

-- 	['jester'] = {
--         label = 'Jester',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `jester`,
--         img = 'https://gtacars.net/images/5fff3c45323e5357d1728980c1033773'
--     },
	
-- 	['jester3'] = {
--         label = 'Jester classic',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `jester3`,
--         img = 'https://gtacars.net/images/89bb6e10a5a66e138037c50580d0caf0'
--     },
	
-- 	['jester4'] = {
--         label = 'Jester RR',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `jester4`,
--         img = 'https://gtacars.net/images/2a31ba13c53320f056948c7c410a3be7'
--     },
	
-- 	['jugular'] = {
--         label = 'Jugular',
--         price = 120000, 
--         class = 's',
--         category = 'Sports',
--         hash = `jugular`,
--         img = 'https://gtacars.net/images/859e4a027f547501947ca247be15223b'
--     },
	
-- 	['khamelion'] = {
--         label = 'Khamelion',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports',
--         hash = `khamelion`,
--         img = 'https://gtacars.net/images/7c332ee949c6c2fee818ee10cfb363b1'
--     },
	
-- 	['komoda'] = {
--         label = 'Komoda',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `komoda`,
--         img = 'https://gtacars.net/images/33e974c2d5d875139150d1f799b9724f'
--     },
	
-- 	['kuruma'] = {
--         label = 'Kuruma',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `kuruma`,
--         img = 'https://gtacars.net/images/7b322fc26ab87e350fc49b9eac990144'
--     },
	
-- 	['locust'] = {
--         label = 'Locust',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `locust`,
--         img = 'https://gtacars.net/images/dbb753fd85f671100a99f1c16650d0a6'
--     },
	
-- 	['massacro'] = {
--         label = 'Massacro',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `massacro`,
--         img = 'https://gtacars.net/images/83a71dd9d99877fdf6daf44ee7b96d3b'
--     },
	
-- 	['neo'] = {
--         label = 'Neo',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `neo`,
--         img = 'https://gtacars.net/images/16a739088af9da2590cc5dbcc68b38dd'
--     },
	
-- 	['neon'] = {
--         label = 'Neon',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `neon`,
--         img = 'https://gtacars.net/images/5ee57ae85a2fccfa3b220993d77d050e'
--     },
	
-- 	['omnis'] = {
--         label = 'Omnis',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `omnis`,
--         img = 'https://gtacars.net/images/978f6a616e9a4aec6af23f88e7c7418f'
--     },
	
-- 	['paragon'] = {
--         label = 'Paragon R',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `paragon`,
--         img = 'https://gtacars.net/images/433322ae88327066b1357575358ff783'
--     },
	
-- 	['pariah'] = {
--         label = 'Pariah',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `pariah`,
--         img = 'https://gtacars.net/images/b51ca61e8e72af6c0eca7dd5ab175960'
--     },
	
-- 	['penumbra'] = {
--         label = 'Penumbra',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `penumbra`,
--         img = 'https://gtacars.net/images/a8dd4e8a0ab35cc4cb3aa633af6536c1'
--     },
	
-- 	['penumbra2'] = {
--         label = 'Penumbra FF',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `penumbra2`,
--         img = 'https://gtacars.net/images/44d89062eff5535b1269e5ee808f70cd'
--     },
	
-- 	['rt3000'] = {
--         label = 'RT3000',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `rt3000`,
--         img = 'https://gtacars.net/images/c9d910fc89907f870d31b8a8b6056ffe'
--     },
	
-- 	['raiden'] = {
--         label = 'Raiden',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `raiden`,
--         img = 'https://gtacars.net/images/d4f1c5892c55c68d9318259ea83614d8'
--     },
	
-- 	['rapidgt2'] = {
--         label = 'Rapid GT Convertible/Cabrio',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `rapidgt2`,
--         img = 'https://gtacars.net/images/d459c4f50269417e3fe15b7a0255ef45'
--     },
	
-- 	['rapidgt'] = {
--         label = 'Rapid GT',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `rapidgt`,
--         img = 'https://gtacars.net/images/8f6c6cf40ae1de61ea8f10e664ab5ee5'
--     },
	
-- 	['raptor'] = {
--         label = 'Raptor',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports',
--         hash = `raptor`,
--         img = 'https://gtacars.net/images/0390e7ff19424790f42efa5b756ac07d'
--     },
	
-- 	['remus'] = {
--         label = 'Remus',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `remus`,
--         img = 'https://gtacars.net/images/8dd636d2d77270e80547a46b206e77e4'
--     },
	
-- 	['revolter'] = {
--         label = 'Revolter',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `revolter`,
--         img = 'https://gtacars.net/images/7bb72fa71d08ae2822d3ae61404a8608'
--     },
	
-- 	['ruston'] = {
--         label = 'Ruston',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `ruston`,
--         img = 'https://gtacars.net/images/73bcd273c414f901237b2a11ac89ff40' --https://gtacars.net/gta5?page=3&filter_class=sport&perPage=36 lõpp
--     },
	
-- 	['s95'] = {
--         label = 'S95',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `s95`,
--         img = 'https://gtacars.net/images/c876b25830db1b59a3f45370932f1680'
--     },
	
-- 	['schafter4'] = {
--         label = 'Schafter LWB',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `schafter4`,
--         img = 'https://gtacars.net/images/3e6aa42c31d31261e08df8d2791a15dd'
--     },
	
-- 	['schafter3'] = {
--         label = 'Schafter V12',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `schafter3`,
--         img = 'https://gtacars.net/images/7074c7c237de86b41d3d12f5833ba136'
--     },
	
-- 	['schlagen'] = {
--         label = 'Schlagen GT',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `schlagen`,
--         img = 'https://gtacars.net/images/0d37801b299c7f11e8e210371c00cd24'
--     },

-- 	['schwarzer'] = {
--         label = 'Schwartzer',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `schwarzer`,
--         img = 'https://gtacars.net/images/771a571e4e467b9e70dff99d8f7552af'
--     },

-- 	['sentinel3'] = {
--         label = 'Sentinel classic',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `sentinel3`,
--         img = 'https://gtacars.net/images/39603b6eb6dfe10663486c2cde6c5fe7'
--     },

-- 	['seven70'] = {
--         label = 'Seven-70',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `seven70`,
--         img = 'https://gtacars.net/images/3dd32314a27673d994d2e80dfa73476e'
--     },

-- 	['specter2'] = {
--         label = 'Specter Custom',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `specter2`,
--         img = 'https://gtacars.net/images/40bafc8a2d404e2e6f324cd73b7ce81e'
--     },

-- 	['streiter'] = {
--         label = 'Streiter',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `streiter`,
--         img = 'https://gtacars.net/images/d1ca57c7057f1c7937ff31992dad6310'
--     },

-- 	['sugoi'] = {
--         label = 'Sugoi',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `sugoi`,
--         img = 'https://gtacars.net/images/bee2f4a92dd3055e4f31f583e2c51b51'
--     },

-- 	['sultan'] = {
--         label = 'Sultan',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports',
--         hash = `sultan`,
--         img = 'https://gtacars.net/images/f0d3d7573097ca3ece6f1ee26b81c71d'
--     },

-- 	['sultan2'] = {
--         label = 'Sultan classic',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports',
--         hash = `sultan2`,
--         img = 'https://gtacars.net/images/979b441981dc7a783a766e3bd0cd3075'
--     },

-- 	['sultan3'] = {
--         label = 'Sultan RS classic',
--         price = 120000, 
--         class = 's',
--         category = 'Sports',
--         hash = `sultan3`,
--         img = 'https://gtacars.net/images/2ed346f4ab3de8093a6f2e5da4d04f4a'
--     },

-- 	['surano'] = {
--         label = 'Surano',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `surano`,
--         img = 'https://gtacars.net/images/de610e3f62998a12aa48c8fa38250f1e'
--     },

-- 	['vstr'] = {
--         label = 'V-STR',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `vstr`,
--         img = 'https://gtacars.net/images/6e771e45f10cb45e07d19c090d753ce4'
--     },

-- 	['vectre'] = {
--         label = 'Vectre',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `vectre`,
--         img = 'https://gtacars.net/images/8490b1ff97977806d8df9fe306db467e'
--     },

-- 	['verlierer2'] = {
--         label = 'Verlierer',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports',
--         hash = `verlierer2`,
--         img = 'https://gtacars.net/images/b93b626495349f0bcd645b5b6ca1f0a7'
--     },

-- 	['zr350'] = {
--         label = 'ZR350',
--         price = 120000, 
--         class = 'a',
--         hash = `zr350`,
--         img = 'https://gtacars.net/images/e2746bee728ea389e66dade7b4e9dbe6'
--     },
--     ------ Supers

-- 	['pfister811'] = {
--         label = '811',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `pfister811`,
--         img = 'https://gtacars.net/images/a66803102a89831ef213b67f63d5efe3'
--     },
	
-- 	['adder'] = {
--         label = 'Adder',
--         price = 120000, 
--         class = 'a',
--         category = 'Supers',
--         hash = `adder`,
--         img = 'https://gtacars.net/images/8866294c242a925d4e20170282a3fdfd'
--     },
	
-- 	['autarch'] = {
--         label = 'Autarch',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `autarch`,
--         img = 'https://gtacars.net/images/213dc2b50d169485c92cff56abc7b58d'
--     },
	
-- 	['banshee2'] = {
--         label = 'Banshee 900R',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `banshee2`,
--         img = 'https://gtacars.net/images/b1e75246a5c90766c266cbd00fe7b651'
--     },
	
-- 	['bullet'] = {
--         label = 'Bullet',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `bullet`,
--         img = 'https://gtacars.net/images/288057fc7869f5f9d344292a1a00c419'
--     },
	
-- 	['champion'] = {
--         label = 'Champion',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `champion`,
--         img = 'https://gtacars.net/images/158bb4a74e98a84fde2867442be9f626'
--     },
	
-- 	['cheetah'] = {
--         label = 'Cheetah',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `cheetah`,
--         img = 'https://gtacars.net/images/9bf4d9bcf46b953bb655afbffd5645fb'
--     },
	
-- 	['cyclone'] = {
--         label = 'Cyclone',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `cyclone`,
--         img = 'https://gtacars.net/images/8e9cb4636ac4e2aa21632164fe32acae'
--     },
	
-- 	['cyclone2'] = {
--         label = 'Cyclone II',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `cyclone2`,
--         img = 'https://gtacars.net/images/72caba7a2fa5a3d5d242416d70abff9a'
--     },
	
-- 	['deveste'] = {
--         label = 'Deveste Eight',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `deveste`,
--         img = 'https://gtacars.net/images/c9817dfaeb9e8162cabbfcb98242814d'
--     },
	
-- 	['sheava'] = {
--         label = 'ETR1',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `sheava`,
--         img = 'https://gtacars.net/images/ed9d0d568994d9e9022ad0534909f01e'
--     },
-- 	['emerus'] = {
--         label = 'Emerus',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `emerus`,
--         img = 'https://gtacars.net/images/a9fb410a0ba8cdf728f25d293e37ecd5'
--     },
	
-- 	['entityxf'] = {
--         label = 'Entity XF',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `entityxf`,
--         img = 'https://gtacars.net/images/82f09e0204cad64f01ff3c2b3ca8b280'
--     },
	
-- 	['entity2'] = {
--         label = 'Entity XXR',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `entity2`,
--         img = 'https://gtacars.net/images/e9195ad077bd55e4b21de7d93002cd0c'
--     },
	
-- 	['fmj'] = {
--         label = 'FMJ',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `fmj`,
--         img = 'https://gtacars.net/images/62ecea12bb863e78984b1b977f85fe4a'
--     },
	
-- 	['furia'] = {
--         label = 'Furia',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `furia`,
--         img = 'https://gtacars.net/images/248ef8231feb8c7daeeb30d4754bc4eb'
--     },
	
-- 	['gp1'] = {
--         label = 'GP1',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `gp1`,
--         img = 'https://gtacars.net/images/cf0a6050551426fee4fd7d4c95fba829'
--     },
	
-- 	['ignus'] = {
--         label = 'Ignus',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `ignus`,
--         img = 'https://gtacars.net/images/78bcc5b51115aca5bf45540c3680cda2'
--     },
	
-- 	['infernus'] = {
--         label = 'Infernus',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `infernus`,
--         img = 'https://gtacars.net/images/ab29494a59ae97f2953d801ee786cf48'
--     },
	
-- 	['italigtb'] = {
--         label = 'Itali GTB',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `italigtb`,
--         img = 'https://gtacars.net/images/7eec638035a0e36c6360c5e588e86534'
--     },
	
-- 	['italigtb2'] = {
--         label = 'Itali GTB Custom',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `italigtb2`,
--         img = 'https://gtacars.net/images/71cedbcd3b2e6000b2e155b57ffd130b'
--     },
	
-- 	['krieger'] = {
--         label = 'Krieger',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `krieger`,
--         img = 'https://gtacars.net/images/db239a13b8e1de143facc23820ba8d84'
--     },
	
-- 	['nero'] = {
--         label = 'Nero',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `nero`,
--         img = 'https://gtacars.net/images/786490cd32aaf1226f0f230846c65b81'
--     },
	
-- 	['nero2'] = {
--         label = 'Nero Custom',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `nero2`,
--         img = 'https://gtacars.net/images/81e9ec741f4ff9f0dff9d1803aa18be9'
--     },
	
-- 	['osiris'] = {
--         label = 'Osiris',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `osiris`,
--         img = 'https://gtacars.net/images/4d2b6f7dd18cf7b6bd59e0229a3ac156'
--     },
	
-- 	['penetrator'] = {
--         label = 'Penetrator',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `penetrator`,
--         img = 'https://gtacars.net/images/839583d41b51b14ec69f58649e72917e'
--     },
	
-- 	['le7b'] = {
--         label = 'RE-7B',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `le7b`,
--         img = 'https://gtacars.net/images/71931522da763417acf042ac37f37511'
--     },
	
-- 	['reaper'] = {
--         label = 'Reaper',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `reaper`,
--         img = 'https://gtacars.net/images/671a28ac359e6225402a49f3dbf62a09'
--     },	
	
-- 	['s80'] = {
--         label = 'S80RR',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `s80`,
--         img = 'https://gtacars.net/images/f29bd57d82339b333a11cacb1175700d'
--     },
	
-- 	['sc1'] = {
--         label = 'SC1',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `sc1`,
--         img = 'https://gtacars.net/images/a0ce0f5203e10cf1507ae952ac843cca'
--     },
	
-- 	['sultanrs'] = {
--         label = 'Sultan RS',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `sultanrs`,
--         img = 'https://gtacars.net/images/07be1861890d36f4de402a87be274b4e'
--     },
	
-- 	['t20'] = {
--         label = 'T20',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `t20`,
--         img = 'https://gtacars.net/images/ba3b35deddb20bd58e5fe30e0d87b7de'
--     },
	
-- 	['taipan'] = {
--         label = 'Taipan',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `taipan`,
--         img = 'https://gtacars.net/images/25bd05ec3d225730acb383478dd4cc53'
--     },
	
-- 	['tempesta'] = {
--         label = 'Tempesta',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `tempesta`,
--         img = 'https://gtacars.net/images/41242cbbb2644235ec4bfc72864d0a56'
--     },
	
-- 	['tezeract'] = {
--         label = 'Tezeract',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `tezeract`,
--         img = 'https://gtacars.net/images/ce16950c7e52de16d11ffb27f0954a7c'
--     },
	
-- 	['thrax'] = {
--         label = 'Thrax',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `thrax`,
--         img = 'https://gtacars.net/images/7b61d9d5439d71c0c8dcf9155a9ee885'
--     },
	
-- 	['tigon'] = {
--         label = 'Tigon',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `tigon`,
--         img = 'https://gtacars.net/images/292cca5d9e841983122539c187f9db2a'
--     },
	
-- 	['turismor'] = {
--         label = 'Turismo R',
--         price = 120000, 
--         class = 'a',
--         category = 'Supers',
--         hash = `turismor`,
--         img = 'https://gtacars.net/images/3316578ec337a8b9f756c3ad5c7b8703'
--     },
	
-- 	['tyrant'] = {
--         label = 'Tyrant',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `tyrant`,
--         img = 'https://gtacars.net/images/3dd5c78c7be8efb8579df4afc2c6082d'
--     },
	
-- 	['tyrus'] = {
--         label = 'Tyrus',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `tyrus`,
--         img = 'https://gtacars.net/images/f1b11590e373f4dc4f0f2c9c1083c116'
--     },
	
-- 	['vacca'] = {
--         label = 'Vacca',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `vacca`,
--         img = 'https://gtacars.net/images/8e67459cdb0c6e4cbfd66c49514a1f72'
--     },
	
-- 	['vagner'] = {
--         label = 'Vagner',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `vagner`,
--         img = 'https://gtacars.net/images/4b6f726db6c90968c397d12eb569d586'
--     },
	
-- 	['visione'] = {
--         label = 'Visione',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `visione`,
--         img = 'https://gtacars.net/images/0699d68a4b054d19386995135ac603a7'
--     },
	
-- 	['voltic'] = {
--         label = 'Voltic',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `voltic`,
--         img = 'https://gtacars.net/images/11c98c09d5ecd5673d186451e264de6d'
--     },
	
-- 	['prototipo'] = {
--         label = 'X80 Proto',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `prototipo`,
--         img = 'https://gtacars.net/images/c84c5b76abaec9030a170629753b7bab'
--     },
	
-- 	['xa21'] = {
--         label = 'XA-21',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `xa21`,
--         img = 'https://gtacars.net/images/7dcf1c5b0b701405edf3c6d9d264233e'
--     },
	
-- 	['zeno'] = {
--         label = 'Zeno',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `zeno`,
--         img = 'https://gtacars.net/images/d9598a35e3b37425331dbee1003977d2'
--     },
	
-- 	['zentorno'] = {
--         label = 'Zentorno',
--         price = 120000, 
--         class = 'a',
--         category = 'Supers',
--         hash = `zentorno`,
--         img = 'https://gtacars.net/images/2d10df4b2a87755c924fa1f3cc57cc18'
--     },
	
-- 	['zorrusso'] = {
--         label = 'Zorrusso',
--         price = 120000, 
--         class = 's',
--         category = 'Supers',
--         hash = `zorrusso`,
--         img = 'https://gtacars.net/images/1ae5701d3074736143c13cc10d8b81b2'
--     },
-- --MUSCLECARS	

-- 	['arbitergt'] = {
--         label = 'Arbiter GT',
--         price = 120000, 
--         class = 'D',
--         category = 'Muscle',
--         hash = `arbitergt`,
--         img = 'https://gtacars.net/images/c904b40c035a0f92bc58ef3616e627d1'
--     },

-- 	['dukes3'] = {
--         label = 'Beater Dukes',
--         price = 120000, 
--         class = 'S',
--         category = 'Muscle',
--         hash = `dukes3`,
--         img = 'https://gtacars.net/images/5bb4475e7d27897d73b21ce337173080'
--     },
	
-- 	['blade'] = {
--         label = 'Blade',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `blade`,
--         img = 'https://gtacars.net/images/c388adc678417c5eaf4f82297defc40b'
--     },
	
-- 	['buccaneer'] = {
--         label = 'Buccaneer',
--         price = 120000, 
--         class = 'D',
--         category = 'Muscle',
--         hash = `buccaneer`,
--         img = 'https://gtacars.net/images/c7937175856209978d455b86e62574b8'
--     },
	
-- 	['buccaneer2'] = {
--         label = 'Buccaneer Custom',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `buccaneer2`,
--         img = 'https://gtacars.net/images/5477c210f54f26c6337ce787be48043e'
--     },
	
-- 	['buffalo4'] = {
--         label = 'Buffalo STX',
--         price = 120000, 
--         class = 'B',
--         category = 'Muscle',
--         hash = `buffalo4`,
--         img = 'https://gtacars.net/images/40971556f6679d95a508e5928e3e3cca'
--     },
	
-- 	['chino'] = {
--         label = 'Chino',
--         price = 120000, 
--         class = 'D',
--         category = 'Muscle',
--         hash = `chino`,
--         img = 'https://gtacars.net/images/0b89ebbc0c4ffdfe457a704fbd63bb79'
--     },
	
-- 	['chino2'] = {
--         label = 'Chino Custom',
--         price = 120000, 
--         class = 'D',
--         category = 'Muscle',
--         hash = `chino2`,
--         img = 'https://gtacars.net/images/428cfe3d41a8b440cc9570abfca83c71'
--     },
	
-- 	['clique'] = {
--         label = 'Clique',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `clique`,
--         img = 'https://gtacars.net/images/1ac4fda47f628764d839441c98c20a2a'
--     },
	
-- 	['coquette3'] = {
--         label = 'Coquette BlackFin',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `coquette3`,
--         img = 'https://gtacars.net/images/1b636d1a6fefa5831f8da41480d97c6a'
--     },
	
-- 	['deviant'] = {
--         label = 'Deviant',
--         price = 120000, 
--         class = 'A',
--         category = 'Muscle',
--         hash = `deviant`,
--         img = 'https://gtacars.net/images/cf659aef537592b0a21e6d61b269ca64'
--     },
	
-- 	['dominator'] = {
--         label = 'Dominator',
--         price = 120000, 
--         class = 'D',
--         category = 'Muscle',
--         hash = `dominator`,
--         img = 'https://gtacars.net/images/b2f7e36dd4f86575c7cd35738d385fc1'
--     },
	
-- 	['dominator7'] = {
--         label = 'Dominator ASP',
--         price = 120000, 
--         class = 'B',
--         category = 'Muscle',
--         hash = `dominator7`,
--         img = 'https://gtacars.net/images/f3c52e761ff8f2492d62dd873dfaee76'
--     },
	
-- 	['dominator8'] = {
--         label = 'Dominator GTT',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `dominator8`,
--         img = 'https://gtacars.net/images/a5ad50c571d38a1d917f67ce5e4cbbb9'
--     },
	
-- 	['dominator3'] = {
--         label = 'Dominator GTX',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `dominator3`,
--         img = 'https://gtacars.net/images/9d0be641faeb67579fb05f473b1fcbf7'
--     },
	
-- 	['yosemite2'] = {
--         label = 'Drift Yosemite',
--         price = 120000, 
--         class = 'B',
--         category = 'Muscle',
--         hash = `yosemite2`,
--         img = 'https://gtacars.net/images/4b90410d551ca25e40cc214ffd3e798c'
--     },
	
-- 	['dukes'] = {
--         label = 'Dukes',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `dukes`,
--         img = 'https://gtacars.net/images/cb06e0bbcf9a6d7760908cf30307500c'
--     },
	
-- 	['ellie'] = {
--         label = 'Ellie',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `ellie`,
--         img = 'https://gtacars.net/images/946b18f32360e987433c4ef21bb6a3e2'
--     },
	
-- 	['faction'] = {
--         label = 'Faction',
--         price = 120000, 
--         class = 'B',
--         category = 'Muscle',
--         hash = `faction`,
--         img = 'https://gtacars.net/images/d26a512e3798b7ac017cdea5caf9f849'
--     },
	
-- 	['faction2'] = {
--         label = 'Faction Custom',
--         price = 120000, 
--         class = 'B',
--         category = 'Muscle',
--         hash = `faction2`,
--         img = 'https://gtacars.net/images/1ee0059ce9c665f727f5ba2c5d73a7e2'
--     },
	
-- 	['faction3'] = {
--         label = 'Faction Custom Donk',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `faction3`,
--         img = 'https://gtacars.net/images/a4bd70d532bffb8f23e6a2c0407525dc'
--     },
	
-- 	['gauntlet'] = {
--         label = 'Gauntlet',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `gauntlet`,
--         img = 'https://gtacars.net/images/a83f21bac1fedb428b4180594984f271'
--     },
	
-- 	['gauntlet3'] = {
--         label = 'Gauntlet Classic',
--         price = 120000, 
--         class = 's',
--         category = 'Muscle',
--         hash = `gauntlet3`,
--         img = 'https://gtacars.net/images/773ee32e8ea693da3dc647182f4255d6'
--     },
	
-- 	['gauntlet5'] = {
--         label = 'Gauntlet Classic Custom',
--         price = 120000, 
--         class = 'B',
--         category = 'Muscle',
--         hash = `gauntlet5`,
--         img = 'https://gtacars.net/images/f9eca43cace77bd24d6d02392cc2fcf6'
--     },
	
-- 	['gauntlet4'] = {
--         label = 'Gauntlet Hellfire',
--         price = 120000, 
--         class = 'A',
--         category = 'Muscle',
--         hash = `gauntlet4`,
--         img = 'https://gtacars.net/images/ede307a542416908f1d6c5eb33bef6fc'
--     },
	
-- 	['hermes'] = {
--         label = 'Hermes',
--         price = 120000, 
--         class = 'D',
--         category = 'Muscle',
--         hash = `hermes`,
--         img = 'https://gtacars.net/images/ce014a0f3cba011b5aa1403127fb1727'
--     },
	
-- 	['hotknife'] = {
--         label = 'Hotknife',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `hotknife`,
--         img = 'https://gtacars.net/images/c00e209db025784239347e3c8ae706ed'
--     },
	
-- 	['hustler'] = {
--         label = 'Hustler',
--         price = 120000, 
--         class = 'B',
--         category = 'Muscle',
--         hash = `hustler`,
--         img = 'https://gtacars.net/images/8804e8f909a7da3ded52ec91a21c4273'
--     },
	
-- 	['impaler'] = {
--         label = 'Impaler',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `impaler`,
--         img = 'https://gtacars.net/images/cb61654e87b8e80c2a882c425cad9fb5'
--     },
	
-- 	['slamvan2'] = {
--         label = 'Lost Slamvan',
--         price = 120000, 
--         class = 'D',
--         category = 'Muscle',
--         hash = `slamvan2`,
--         img = 'https://gtacars.net/images/875e046561a9a7debcd8b594c927c7de'
--     },
	
-- 	['lurcher'] = {
--         label = 'Lurcher',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `lurcher`,
--         img = 'https://gtacars.net/images/3804bf7622e5939bc6cb28af4b9b8c53'
--     },
	
-- 	['manana2'] = {
--         label = 'Manana Custom',
--         price = 120000, 
--         class = 'D',
--         category = 'Muscle',
--         hash = `manana2`,
--         img = 'https://gtacars.net/images/574952442267d5e1d63ecc109981bc8f'
--     },
	
-- 	['moonbeam'] = {
--         label = 'Moonbeam',
--         price = 120000, 
--         class = 'B',
--         category = 'Muscle',
--         hash = `moonbeam`,
--         img = 'https://gtacars.net/images/9e575bbb2f15fa9714c92affb1c75bb8'
--     },
	
-- 	['moonbeam2'] = {
--         label = 'Moonbeam Custom',
--         price = 120000, 
--         class = 'B',
--         category = 'Muscle',
--         hash = `moonbeam2`,
--         img = 'https://gtacars.net/images/1f7d0fb0484b2526b8619f97488e4e4f'
--     },
	
-- 	['nightshade'] = {
--         label = 'Nightshade',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `nightshade`,
--         img = 'https://gtacars.net/images/2b659a00f8801616c3d1faefd6ac23ed'
--     },
	
-- 	['peyote2'] = {
--         label = 'Peyote Gasser',
--         price = 120000, 
--         class = 'B',
--         category = 'Muscle',
--         hash = `peyote2`,
--         img = 'https://gtacars.net/images/7f52028e0aea8c337ac2f6e72bfedf66'
--     },
	
-- 	['phoenix'] = {
--         label = 'Phoenix',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `phoenix`,
--         img = 'https://gtacars.net/images/1684d6c87f583f8c73cb5e1a3dc73a47'
--     },
	
-- 	['picador'] = {
--         label = 'Picador',
--         price = 120000, 
--         class = 'D',
--         category = 'Muscle',
--         hash = `picador`,
--         img = 'https://gtacars.net/images/44facb19c62aeb4658866c466a6f5e17'
--     },
	
-- 	['ratloader'] = {
--         label = 'Rat-Loader',
--         price = 120000, 
--         class = 'D',
--         category = 'Muscle',
--         hash = `ratloader`,
--         img = 'https://gtacars.net/images/f94e9cc6c7a12efe0c69679df98d0df9'
--     },
	
-- 	['ratloader2'] = {
--         label = 'Rat-Truck',
--         price = 120000, 
--         class = 'C',
--         category = 'Muscle',
--         hash = `ratloader2`,
--         img = 'https://gtacars.net/images/0589cc8500bbd05bcb07f0d69a77c855'
--     },
	
-- 	['ruiner'] = {
--         label = 'Ruiner',
--         price = 120000, 
--         class = 'B',
--         category = 'Muscle',
--         hash = `ruiner`,
--         img = 'https://gtacars.net/images/1825ca4b99bf4f5c260c8baf0b98b25c'
--     },
	
-- 	['sabregt'] = {
--         label = 'Sabre Turbo',
--         price = 120000, 
--         class = 'd',
--         category = 'Muscle',
--         hash = `sabregt`,
--         img = 'https://gtacars.net/images/69b56b0ba5bcaeaedb68765ece77062e'
--     },
	
-- 	['sabregt2'] = {
--         label = 'Sabre Turbo Custom',
--         price = 120000, 
--         class = 'c',
--         category = 'Muscle',
--         hash = `sabregt2`,
--         img = 'https://gtacars.net/images/c3c7c6d0557659827248ce0bc0b523f7'
--     },
	
-- 	['slamvan'] = {
--         label = 'Slamvan',
--         price = 120000, 
--         class = 'b',
--         category = 'Muscle',
--         hash = `slamvan`,
--         img = 'https://gtacars.net/images/b66b40d2ee1ad0b3568b3f743b46d49f'
--     },
 	
-- 	['slamvan3'] = {
--         label = 'Slamvan Custom',
--         price = 120000, 
--         class = 'c',
--         category = 'Muscle',
--         hash = `slamvan3`,
--         img = 'https://gtacars.net/images/a8e4561f229801324d330eb0c129b708'
--     },
 	
-- 	['stalion'] = {
--         label = 'Stallion',
--         price = 120000, 
--         class = 'c',
--         category = 'Muscle',
--         hash = `stalion`,
--         img = 'https://gtacars.net/images/4904d0f05089536d09ed18989487af98'
--     },
 	
-- 	['tampa'] = {
--         label = 'Tampa',
--         price = 120000, 
--         class = 'b',
--         category = 'Muscle',
--         hash = `tampa`,
--         img = 'https://gtacars.net/images/5decfcda9d082403831a72df24aa9c78'
--     },
 	
-- 	['tulip'] = {
--         label = 'Tulip',
--         price = 120000, 
--         class = 'c',
--         category = 'Muscle',
--         hash = `tulip`,
--         img = 'https://gtacars.net/images/82c1bd3a0939adabf2b4217c6580ae22'
--     },
 	
-- 	['vamos'] = {
--         label = 'Vamos',
--         price = 120000, 
--         class = 'c',
--         category = 'Muscle',
--         hash = `vamos`,
--         img = 'https://gtacars.net/images/b86e5ec4bf9ff13259ef237f0e1d16a2'
--     },
 	
-- 	['vigero'] = {
--         label = 'Vigero',
--         price = 60000, 
--         class = 'c',
--         category = 'Muscle',
--         hash = `vigero`,
--         img = 'https://gtacars.net/images/e50a5491d4613da09f83a50d17be5b75'
--     },
 	
-- 	['virgo'] = {
--         label = 'Virgo',
--         price = 120000, 
--         class = 'd',
--         category = 'Muscle',
--         hash = `virgo`,
--         img = 'https://gtacars.net/images/7870e17d0235f77044a84446cdf53793'
--     },
 	
-- 	['virgo3'] = {
--         label = 'Virgo b',
--         price = 120000, 
--         class = 'd',
--         category = 'Muscle',
--         hash = `virgo3`,
--         img = 'https://gtacars.net/images/8554bec4abd692463210fcd101726125'
--     },
 	
-- 	['virgo3'] = {
--         label = 'Virgo b Custom',
--         price = 120000, 
--         class = 'd',
--         category = 'Muscle',
--         hash = `virgo3`,
--         img = 'https://gtacars.net/images/48a310a2ebba8280dcc1bd3444656df6'
--     },
 	
-- 	['voodoo2'] = {
--         label = 'Voodoo',
--         price = 120000, 
--         class = 'c',
--         category = 'Muscle',
--         hash = `voodoo2`,
--         img = 'https://gtacars.net/images/b950545adee46cf5f508090ef53e8d7f'
--     },
 	
-- 	['voodoo'] = {
--         label = 'Voodoo Custom',
--         price = 120000, 
--         class = 'd',
--         category = 'Muscle',
--         hash = `voodoo`,
--         img = 'https://gtacars.net/images/2e21d64db23865cdca6fa8685f99efd3'
--     },
 	
-- 	['yosemite'] = {
--         label = 'Yosemite',
--         price = 120000, 
--         class = 'c',
--         category = 'Muscle',
--         hash = `yosemite`,
--         img = 'https://gtacars.net/images/368352c6c1a6304cdb9f94662584a78b'
--     },

--  --Sport classics	
-- 	['z190'] = {
--         label = 'Karin 190z',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports Classics',
--         hash = `z190`,
--         img = 'https://gtacars.net/images/15bdda7a7065a07747469a7adf3b9c90'
--     },
 	
-- 	['ardent'] = {
--         label = 'Ardent',
--         price = 120000, 
--         class = 'a',
--         category = 'Sports Classics',
--         hash = `ardent`,
--         img = 'https://gtacars.net/images/fa33bdf21afb3b2e625847474143978c'
--     },
  	
-- 	['casco'] = {
--         label = 'Casco',
--         price = 120000, 
--         class = 'd',
--         category = 'Sports Classics',
--         hash = `casco`,
--         img = 'https://gtacars.net/images/cffbfa1e7ebbd8158548852444d3155f'
--     },
  	
-- 	['cheburek'] = {
--         label = 'Cheburek',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports Classics',
--         hash = `cheburek`,
--         img = 'https://gtacars.net/images/ffa5abdb48c00d0b715e203fd5970110'
--     },
  	
-- 	['cheetah2'] = {
--         label = 'Cheetah Classic',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `cheetah2`,
--         img = 'https://gtacars.net/images/ba4ba835632f6768a67a7726a620974b'
--     },
  	
-- 	['coquette2'] = {
--         label = 'Coquette Classic',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports Classics',
--         hash = `coquette2`,
--         img = 'https://gtacars.net/images/e1b1dd3201de4a8e9158924398988a1c'
--     },
  	
-- 	['dynasty'] = {
--         label = 'Dynasty',
--         price = 120000, 
--         class = 'd',
--         category = 'Sports Classics',
--         hash = `dynasty`,
--         img = 'https://gtacars.net/images/8e48457eb42799c288bd252e6d466877'
--     },
  	
-- 	['fagaloa'] = {
--         label = 'Fagaloa',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports Classics',
--         hash = `fagaloa`,
--         img = 'https://gtacars.net/images/f266a9befaec2e78e8c19aed07ea9662'
--     },
  	
-- 	['btype2'] = {
--         label = 'Fränken Stange',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports Classics',
--         hash = `btype2`,
--         img = 'https://gtacars.net/images/3fc92bfee5c7c893c9eeb86adf284b73'
--     },
  	
-- 	['gt500'] = {
--         label = 'GT500',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `gt500`,
--         img = 'https://gtacars.net/images/7b8e2f1c957bf4e4daf551a863743470'
--     },
  	
-- 	['infernus2'] = {
--         label = 'Infernus b',
--         price = 120000, 
--         class = 's',
--         category = 'Sports Classics',
--         hash = `infernus2`,
--         img = 'https://gtacars.net/images/0d0838a019bd6bf7d122110f0c78bed1'
--     },
  	
-- 	['mamba'] = {
--         label = 'Mamba',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports Classics',
--         hash = `mamba`,
--         img = 'https://gtacars.net/images/3f20a676700da328ea7632082f2beb8f'
--     },
  	
-- 	['manana'] = {
--         label = 'Manana',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports Classics',
--         hash = `manana`,
--         img = 'https://gtacars.net/images/ed55c6f3580ff292ff7ec4a9aa621327'
--     },
  	
-- 	['michelli'] = {
--         label = 'Michelli GT',
--         price = 120000, 
--         class = 'd',
--         category = 'Sports Classics',
--         hash = `michelli`,
--         img = 'https://gtacars.net/images/4300a845c6a5b78e85be4ff094cd2c34'
--     },
  	
-- 	['monroe'] = {
--         label = 'Monroe',
--         price = 120000, 
--         class = 'd',
--         category = 'Sports Classics',
--         hash = `monroe`,
--         img = 'https://gtacars.net/images/fc9fd322616ca1dd6d21b150d835f2e8'
--     },
  	
-- 	['nebula'] = {
--         label = 'Nebula Turbo',
--         price = 120000, 
--         class = 's',
--         category = 'Sports Classics',
--         hash = `nebula`,
--         img = 'https://gtacars.net/images/75c5e8363fd622daa90febafcfe78c55'
--     },
  	
-- 	['peyote'] = {
--         label = 'Peyote',
--         price = 120000, 
--         class = 'd',
--         category = 'Sports Classics',
--         hash = `peyote`,
--         img = 'https://gtacars.net/images/46d06ebc7442f843c140ffb97a9b41bd'
--     },
  	
-- 	['peyote3'] = {
--         label = 'Peyote Custom',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `peyote3`,
--         img = 'https://gtacars.net/images/c3106a1445e8c98a998641128f7829c8'
--     },
  	
-- 	['pigalle'] = {
--         label = 'Pigalle',
--         price = 120000, 
--         class = 'd',
--         category = 'Sports Classics',
--         hash = `pigalle`,
--         img = 'https://gtacars.net/images/c3b4c1d996c96134453341c5dc5255dc'
--     },
  	
-- 	['rapidgt3'] = {
--         label = 'Rapid GT Classic',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports Classics',
--         hash = `rapidgt3`,
--         img = 'https://gtacars.net/images/40d2bc05ee99cd9f3c21b236be4dedf0'
--     },
  	
-- 	['retinue'] = {
--         label = 'Retinue',
--         price = 120000, 
--         class = 'd',
--         category = 'Sports Classics',
--         hash = `retinue`,
--         img = 'https://gtacars.net/images/7a39c2efd494f583d2a2c961e1c832ab'
--     },
  	
-- 	['retinue2'] = {
--         label = 'Retinue Mk II',
--         price = 120000, 
--         class = 'd',
--         category = 'Sports Classics',
--         hash = `retinue2`,
--         img = 'https://gtacars.net/images/0a08e9603e2fdad76d638484b6330147'
--     },
  	
-- 	['btype'] = {
--         label = 'Roosevelt',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports Classics',
--         hash = `btype`,
--         img = 'https://gtacars.net/images/0a08e9603e2fdad76d638484b6330147'
--     },
  	
-- 	['btype3'] = {
--         label = 'Roosevelt Valor',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports Classics',
--         hash = `btype3`,
--         img = 'https://gtacars.net/images/c3ec48eee15c6b4e5e09cea36ee27db8'
--     },
  	
-- 	['savestra'] = {
--         label = 'Savestra',
--         price = 120000, 
--         class = 'c',
--         category = 'Sports Classics',
--         hash = `savestra`,
--         img = 'https://gtacars.net/images/ef30e44906df118895548af408f8e76b'
--     },
  	
-- 	['stinger'] = {
--         label = 'Stinger',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `stinger`,
--         img = 'https://gtacars.net/images/2e09d34ae6d4df014b806e81466da59b'
--     },
  	
-- 	['stingergt'] = {
--         label = 'Stinger GT',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `stingergt`,
--         img = 'https://gtacars.net/images/8193f7c115438fad82613cff2a5d3418'
--     },
  	
-- 	['feltzer3'] = {
--         label = 'Stirling GT',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `feltzer3`,
--         img = 'https://gtacars.net/images/16caeba19daa8f48d96a62e2facf3662'
--     },
  	
-- 	['stromberg'] = {
--         label = 'Stromberg',
--         price = 120000, 
--         class = 'b',
--         hash = `stromberg`,
--         img = 'https://gtacars.net/images/87144d2d77131bc42e7a425d2814e77c'
--     },
  	
-- 	['swinger'] = {
--         label = 'Swinger',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `swinger`,
--         img = 'https://gtacars.net/images/2edbe62476081a6748ce398854d0504b'
--     },
  	
-- 	['toreador'] = {
--         label = 'Toreador',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `toreador`,
--         img = 'https://gtacars.net/images/24fbeca2674881922284323b7d20845f'
--     },
  	
-- 	['torero'] = {
--         label = 'Torero',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `torero`,
--         img = 'https://gtacars.net/images/82028c7e552b59b486a953377568db8a'
--     },
  	
-- 	['tornado3'] = {
--         label = 'Tornado Beater',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `tornado3`,
--         img = 'https://gtacars.net/images/9805252ab9e64524c442d13b1a8e55f4'
--     },
  	
-- 	['tornado2'] = {
--         label = 'Tornado Convertible',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `tornado2`,
--         img = 'https://gtacars.net/images/08207b9f55a9a0853ced5547731df36b'
--     },
  	
-- 	['tornado4'] = {
--         label = 'Tornado Mariachi',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `tornado4`,
--         img = 'https://gtacars.net/images/75b122f9de4379cd5e48c710491bed52'
--     },
  	
-- 	['tornado'] = {
--         label = 'Tornado',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `tornado`,
--         img = 'https://gtacars.net/images/dd71f6ac91f93c6c16eaf4fbbb1c3948'
--     },
  	
-- 	['tornado5'] = {
--         label = 'Tornado Custom',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `tornado5`,
--         img = 'https://gtacars.net/images/526327f174cc54063d857f5a8ed76269'
--     },
  	
-- 	['tornado6'] = {
--         label = 'Tornado Rat Rod',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `tornado6`,
--         img = 'https://gtacars.net/images/9abc8c884be4dada7de781c325acc50f'
--     },
  	
-- 	['turismo2'] = {
--         label = 'Turismo b',
--         price = 120000, 
--         class = 's',
--         category = 'Sports Classics',
--         hash = `turismo2`,
--         img = 'https://gtacars.net/images/aee8a5bc5135b026a3708e9ee8eeb38c'
--     },
  	
-- 	['viseris'] = {
--         label = 'Viseris',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `viseris`,
--         img = 'https://gtacars.net/images/58b643ca12764427411342363738fc11'
--     },
  	
-- 	['ztype'] = {
--         label = 'Z-Type',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `ztype`,
--         img = 'https://gtacars.net/images/f39273f124d491f0d0d9f6254c5ecef8'
--     },
  	
-- 	['zion3'] = {
--         label = 'Zion b',
--         price = 120000, 
--         class = 'b',
--         category = 'Sports Classics',
--         hash = `zion3`,
--         img = 'https://gtacars.net/images/a420ea8cce3fbe525746df8b7deff4ab'
--     },
-- --MOTOBIKES

-- 	['akuma'] = {
--         label = 'Akuma',
--         price = 30000, 
--         class = 'b',
--         category = 'Motorcycles',
--         hash = `akuma`,
--         img = 'https://gtacars.net/images/39c76d9f98271dc1b45db2facbcfc543'
--     },
	
-- 	['avarus'] = {
--         label = 'Avarus',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `avarus`,
--         img = 'https://gtacars.net/images/82ce2ae3ed51e44507a95f5ac9549bcc'
--     },
	
-- 	['bf400'] = {
--         label = 'BF400',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `bf400`,
--         img = 'https://gtacars.net/images/f9d9fd33166da0ea09aded035d0f00df'
--     },
	
-- 	['bagger'] = {
--         label = 'Bagger',
--         price = 60000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `bagger`,
--         img = 'https://gtacars.net/images/f9d21aeb604cf6920b86bbc0c9d5b4a1'
--     },
	
-- 	['bati'] = {
--         label = 'Bati 801',
--         price = 50000, 
--         class = 'd',
--         category = 'Motorcycles',
--         hash = `bati`,
--         img = 'https://gtacars.net/images/4d18e6b30e8ad542c24bd5f6ae60aed9'
--     },
	
-- 	['bati2'] = {
--         label = 'Bati 801RR',
--         price = 120000, 
--         class = 'b',
--         category = 'Motorcycles',
--         hash = `bati2`,
--         img = 'https://gtacars.net/images/2d719b787719bafd374c5c0092a42b52'
--     },
	
-- 	['carbonrs'] = {
--         label = 'Carbon RS',
--         price = 120000, 
--         class = 'b',
--         category = 'Motorcycles',
--         hash = `carbonrs`,
--         img = 'https://gtacars.net/images/dcf9bd7aaab76670935d319b09b0daad'
--     },
	
-- --[[	['chimera'] = {
--         label = 'Chimera',
--         price = 120000, 
--         class = 'c',
--         hash = `chimera`,
--         img = 'https://gtacars.net/images/4de643f0e6f9014a21c016034dbce4d8'
--     },]]
	
-- 	['cliffhanger'] = {
--         label = 'Cliffhanger',
--         price = 50000, 
--         class = 'd',
--         category = 'Motorcycles',
--         hash = `cliffhanger`,
--         img = 'https://gtacars.net/images/9e4b5372d911d4024e1768cc89449699'
--     },
	
-- 	['daemon'] = {
--         label = 'Daemon Lost MC',
--         price = 40000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `daemon`,
--         img = 'https://gtacars.net/images/6d88616a80d8f359d4fa92bfbaa14a79'
--     },
	
-- 	['daemon2'] = {
--         label = 'Daemon Regular',
--         price = 50000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `daemon2`,
--         img = 'https://gtacars.net/images/7db85df3a18dde52e8dfc3ca6c4b9829'
--     },
	
-- 	['defiler'] = {
--         label = 'Defiler',
--         price = 50000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `defiler`,
--         img = 'https://gtacars.net/images/ca229f1a1721be755f28be2f94142472'
--     },
	
-- 	['diablous'] = {
--         label = 'Diabolus',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `diablous`,
--         img = 'https://gtacars.net/images/757ad6ec2eb8dc3a46398cc6eb943a09'
--     },
	
-- 	['diablous2'] = {
--         label = 'Diabolus Custom',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `diablous2`,
--         img = 'https://gtacars.net/images/1688aeb81e99ade197be07139d58e99d'
--     },
	
-- 	['double'] = {
--         label = 'Double-T',
--         price = 120000, 
--         class = 'd',
--         category = 'Motorcycles',
--         hash = `double`,
--         img = 'https://gtacars.net/images/389fcc1d7919c02d204d768234e67c34'
--     },
	
-- 	['enduro'] = {
--         label = 'Enduro',
--         price = 50000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `enduro`,
--         img = 'https://gtacars.net/images/f2d2741969000e6bda655a8fefa86930'
--     },
	
-- 	['esskey'] = {
--         label = 'Esskey',
--         price = 30000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `esskey`,
--         img = 'https://gtacars.net/images/8cfcc847bd7044a7d19dae8bb031c627'
--     },
	
-- 	['fcr'] = {
--         label = 'FCR 1000',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `fcr`,
--         img = 'https://gtacars.net/images/a88e4cdff2b75f31ef3d44c3090babe9'
--     },
	
-- 	['fcr2'] = {
--         label = 'FCR 1000 Custom',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `fcr2`,
--         img = 'https://gtacars.net/images/52ba3127b052024e1bf4a9e5407e19be'
--     },
	
-- 	['faggio2'] = {
--         label = 'Faggio',
--         price = 15000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `faggio2`,
--         img = 'https://gtacars.net/images/490d53928ed54a3b2c656681ab98159c'
--     },

--     ['faggio3'] = {
--         label = 'Faggio Mod',
--         price = 40000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `faggio3`,
--         img = 'https://gtacars.net/images/e41dc1c0ffe80722833980303c2b1f6c'
--     },
	
-- 	['faggio'] = {
--         label = 'Faggio Sport',
--         price = 11250, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `faggio`,
--         img = 'https://gtacars.net/images/4e9d4b550889326ab411e4a631566987'
--     },
	
-- 	['gargoyle'] = {
--         label = 'Gargoyl',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `gargoyle`,
--         img = 'https://gtacars.net/images/edcb569b63d70194852303b20845d76d'
--     },
	
-- 	['hakuchou'] = {
--         label = 'Hakuchou',
--         price = 120000, 
--         class = 'a',
--         category = 'Motorcycles',
--         hash = `hakuchou`,
--         img = 'https://gtacars.net/images/ba59d1b9eeef08d59659f2c25ffb8bea'
--     },
	
-- 	['hakuchou2'] = {
--         label = 'Hakuchou Drag',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `hakuchou2`,
--         img = 'https://gtacars.net/images/5d690c0611092463e056bedf5b7eff71'
--     },
	
-- 	['hexer'] = {
--         label = 'Hexer',
--         price = 50000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `hexer`,
--         img = 'https://gtacars.net/images/31520d63077b264408009b47863d07f1'
--     },
	
-- 	['innovation'] = {
--         label = 'Innovation',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `innovation`,
--         img = 'https://gtacars.net/images/26c1a9ed24988dc3b452fd5d18a6d4b9'
--     },
	
-- 	['lectro'] = {
--         label = 'Lectro',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `lectro`,
--         img = 'https://gtacars.net/images/c56b558fbbe7e269fff2a8138b9e44b0'
--     },
	
-- 	['manchez'] = {
--         label = 'Manchez',
--         price = 120000, 
--         class = 'c',
--         hash = `manchez`,
--         img = 'https://gtacars.net/images/b6762b67d3c8c0fde50895a12413bcb2'
--     },
	
-- 	['manchez2'] = {
--         label = 'Manchez Scout',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `manchez2`,
--         img = 'https://gtacars.net/images/d6f6ff79b8d83cc7a635913ede689f4e'
--     },
	
-- 	['nemesis'] = {
--         label = 'Nemesis',
--         price = 30000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `nemesis`,
--         img = 'https://gtacars.net/images/5855e87bf698bb6972b6b44d717c7316'
--     },
	
-- 	['nightblade'] = {
--         label = 'Nightblade',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `nightblade`,
--         img = 'https://gtacars.net/images/b9779afc60e4fd991782b32ef8fe02d6'
--     },
	
-- 	['pcj'] = {
--         label = 'PCJ 600',
--         price = 30000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `pcj`,
--         img = 'https://gtacars.net/images/8f0e6d8ca52cd7187e328dc09ff35bc0'
--     },
	
-- 	-- ['rrocket'] = {
--     --     label = 'Rampant Rocket',
--     --     price = 120000, 
--     --     class = 'c',
--     --     category = 'Motorcycles',
--     --     hash = `rrocket`,
--     --     img = 'https://gtacars.net/images/e5fc7fb01a5985979dd8a855e16bc143'
--     -- },
	
-- 	['ratbike'] = {
--         label = 'Rat Bike',
--         price = 20000, 
--         class = 'd',
--         category = 'Motorcycles',
--         hash = `ratbike`,
--         img = 'https://gtacars.net/images/af2e5d124ede74cf6ae7f9a9f13531c7'
--     },
	
-- 	['reever'] = {
--         label = 'Reever',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `reever`,
--         img = 'https://gtacars.net/images/804190eafde87e39284d34980bf4bb2a'
--     },
	
-- 	['ruffian'] = {
--         label = 'Ruffian',
--         price = 30000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `ruffian`,
--         img = 'https://gtacars.net/images/e7e611f65de29da6c14420c9558f80f1'
--     },
	
-- 	['sanchez2'] = {
--         label = 'Sanchez',
--         price = 120000, 
--         class = 'd',
--         category = 'Motorcycles',
--         hash = `sanchez2`,
--         img = 'https://gtacars.net/images/e33eb1aaa4195a614fc52e4acad57c9f'
--     },
	
-- 	['sanchez'] = {
--         label = 'Sanchez (livery)',
--         price = 120000, 
--         class = 'd',
--         category = 'Motorcycles',
--         hash = `sanchez`,
--         img = 'https://gtacars.net/images/d2bfd4be35aa1df4f839c18694e1b2be'
--     },
	
-- 	['sanctus'] = {
--         label = 'Sanctus',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `sanctus`,
--         img = 'https://gtacars.net/images/04dc218ddda578aa19481451fd20bcac'
--     },
	
['taxi'] = {
    label = 'Taxi',
    price = 20000, -- või pane mis hinda tahad
    class = 'c',
    category = 'Sedans',
    hash = `taxi`,
    img = 'https://wiki.rage.mp/images/d/d2/Taxi.png'
},

-- 	['sovereign'] = {
--         label = 'Sovereign',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `sovereign`,
--         img = 'https://gtacars.net/images/824ebba8736286e34743a3873d55f720'
--     },
	
-- 	['stryder'] = {
--         label = 'Stryder',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `stryder`,
--         img = 'https://gtacars.net/images/6836762d8e4cdab961ee237fc0a11160'
--     },
	
-- 	['thrust'] = {
--         label = 'Thrust',
--         price = 120000, 
--         class = 'd',
--         category = 'Motorcycles',
--         hash = `thrust`,
--         img = 'https://gtacars.net/images/78ebcb350c39968e1931fff0cfe0a6b7'
--     },
	
-- 	['vader'] = {
--         label = 'Vader',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `vader`,
--         img = 'https://gtacars.net/images/80a66b707f159131553c27b680a89cb5'
--     },
	
-- 	['vindicator'] = {
--         label = 'Vindicator',
--         price = 120000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `vindicator`,
--         img = 'https://gtacars.net/images/0d0dbae42df527680895e2792e31dc99'
--     },
	
-- 	['vortex'] = {
--         label = 'Vortex',
--         price = 40000, 
--         class = 'b',
--         category = 'Motorcycles',
--         hash = `vortex`,
--         img = 'https://gtacars.net/images/cded2d00aac8bfd7d4cc7c3cb1115fb0'
--     },
	
-- 	['wolfsbane'] = {
--         label = 'Wolfsbane',
--         price = 40000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `wolfsbane`,
--         img = 'https://gtacars.net/images/cded2d00aac8bfd7d4cc7c3cb1115fb0'
--     },
	
-- 	['zombiea'] = {
--         label = 'Zombie Bobber',
--         price = 40000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `zombiea`,
--         img = 'https://gtacars.net/images/646bf4c795541fe30e5deaf74af0ba5e'
--     },
	
-- 	['zombieb'] = {
--         label = 'Zombie Chopper',
--         price = 60000, 
--         class = 'c',
--         category = 'Motorcycles',
--         hash = `zombieb`,
--         img = 'https://gtacars.net/images/7c7bc5e1ccad869bfa2cd8c251e62b53'
--     },
	
-- 	['bmx'] = {
--         label = 'BMX',
--         price = 120000, 
--         class = 'c',
--         category = 'Cycles',
--         hash = `bmx`,
--         img = 'https://gtacars.net/images/4596bd7f7aab3d7e1d537ea929b239e4'
--     },
	
-- 	['cruiser'] = {
--         label = 'Cruiser',
--         price = 120000, 
--         class = 'c',
--         category = 'Cycles',
--         hash = `cruiser`,
--         img = 'https://gtacars.net/images/9ba8ac906e802139d944306a9b93c9f1'
--     },
	
-- 	['tribike2'] = {
--         label = 'Endurex Race Bike',
--         price = 120000, 
--         class = 'c',
--         category = 'Cycles',
--         hash = `tribike2`,
--         img = 'https://gtacars.net/images/974e78da5a4d5dfb3769029bc4c6c0d9'
--     },
	
-- 	['fixter'] = {
--         label = 'Fixter',
--         price = 120000, 
--         class = 'c',
--         category = 'Cycles',
--         hash = `fixter`,
--         img = 'https://gtacars.net/images/d68a6db35a1b6cafd73aa6d16fdf59c6'
--     },
	
-- 	['scorcher'] = {
--         label = 'Scorcher',
--         price = 120000,
--         class = 'c',
--         category = 'Cycles',
--         hash = `scorcher`,
--         img = 'https://gtacars.net/images/015ed1fc03952611c4602f3e9370e7b9'
--     },
	
-- 	['tribike3'] = {
--         label = 'Tri-Cycles Race Bike',
--         price = 120000, 
--         class = 'c',
--         category = 'Cycles',
--         hash = `tribike3`,
--         img = 'https://gtacars.net/images/581b41af5bda1a54851f6cdd5cf17e1b'
--     },
	
-- 	['tribike'] = {
--         label = 'Whippet Race Bike',
--         price = 120000, 
--         class = 'c',
--         category = 'Cycles',
--         hash = `tribike`,
--         img = 'https://gtacars.net/images/99265646a1a1a77f003b4824e87e9ddb'
--     }
}

exports('getVehicles', function(class)
    local returnable = {}

    for k,v in pairs(vehicles) do
        if string.upper(v.category) == class then
            local data = v; v.modelName = k

            returnable[#returnable + 1] = data
        end
    end

    return returnable
end)   

exports('getVehiclePrice', function(model)
    local returnable = nil

    for k,v in pairs(vehicles) do
        if joaat(k) == model then
            returnable = v.price
        end
    end

    return returnable
end)


lib.callback.register('kk-vehicleshop:recieveVehicles', function(source)
    return vehicles
end)

lib.callback.register('kk-vehicleshop:fetchSpecial', function(source)
    local specialVehicles = {}

    for k, v in pairs(vehicles) do
        if v.specialVehicle then
            specialVehicles[k] = v
        end
    end

    return specialVehicles
end)


lib.callback.register('kk-vehicleshop:fetchPolice', function(source)
    local police_vehicles = {}

    for k, v in pairs(vehicles) do
        if v.specialVehicle then
            police_vehicles[k] = v
        end
    end

    return police_vehicles
end)


local vehicle_stocks = {}

MySQL.Async.fetchAll('SELECT * FROM vehicle_stocks', {}, function(result)
    for _, stock in ipairs(result) do
        vehicle_stocks[stock.vehicle] = { vehicle = stock.vehicle, stock = stock.stock }
    end
end)


lib.callback.register('kk-vehicleshop:recieveStocks', function(source)
    for k, v in pairs(vehicles) do
        if not vehicle_stocks[k] then
            vehicle_stocks[k] = { vehicle = k, stock = 10 }
            -- Insert into database (optional)
            MySQL.Async.execute('INSERT INTO vehicle_stocks (vehicle, stock) VALUES (@vehicle, @stock)', {
                ['@vehicle'] = k,
                ['@stock'] = 10
            })
        end
    end

    return vehicle_stocks
end)



local function getRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return getRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

local function getRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return getRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

local function generatePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		generatedPlate = string.upper(getRandomLetter(4) .. getRandomNumber(4))

        MySQL.Async.fetchAll('SELECT * FROM user_vehicles WHERE plate = ?', {generatedPlate}, function(result)
            if not result[1] then
				doBreak = true
			end
        end)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

exports('generatePlate', generatePlate)


RegisterServerEvent('kk-vehicleshop:server:buyVehicle', function(name)
    local src = source
    local xPlayer = KKF.GetPlayerFromId(src)

    if xPlayer then
        local selectedCar = vehicles[name]
        if not selectedCar then
            TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sõidukit ei leitud!')
            return
        end

        local taxValue = exports['kk-taxes']:getTax('primary').value
        local finalPrice = selectedCar.price + KKF.Math.Round(KKF.Math.Percent(taxValue, selectedCar.price))
        if xPlayer.getMoney() >= finalPrice then
            if vehicle_stocks[name] and vehicle_stocks[name].stock and vehicle_stocks[name].stock > 0 then
                local plate = generatePlate()

                xPlayer.removeMoney(finalPrice)
                vehicle_stocks[name].stock = vehicle_stocks[name].stock - 1

                MySQL.Async.execute('UPDATE vehicle_stocks SET stock = stock - 1 WHERE vehicle = @vehicle', {
                    ['@vehicle'] = name
                }, function(affectedRows)
                    if affectedRows > 0 then
                        MySQL.Async.execute('INSERT INTO user_vehicles (owner, plate, vehicle, stored,location, ownername, model) VALUES (?, ?, ?, ?,?, ?, ?)', {
                            xPlayer.identifier,
                            plate,
                            json.encode({ model = selectedCar.hash, plate = plate }),
                            1,
                            'cardealer',
                            xPlayer.name,
                            name
                        }, function(rowsChanged)
                            TriggerClientEvent('KKF.UI.ShowNotification', src, 'success', 'Soetasite sõiduki ' .. selectedCar.label .. ' $' .. finalPrice .. ' eest.')

                            exports['kk-scripts']:sendLog(xPlayer.identifier, 'SÕIDUKID', 'Soetas sõiduki (' .. selectedCar.label .. '; PLATE: ' .. plate .. ') $' .. finalPrice .. ' eest.')

                            -- TriggerEvent('Society.AddMoney', 'doj', KKF.Math.Round(KKF.Math.Percent(20, finalPrice)))

                            Wait(500)
                            TriggerClientEvent('KKF.UI.ShowNotification', src, 'info', 'Sõiduk toimetatakse autopoe garaazi.')
                        end)
                    else
                        vehicle_stocks[name].stock = vehicle_stocks[name].stock + 1
                        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sõiduki laoseisu värskendamine ebaõnnestus!')
                    end
                end)
            else
                TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Sõiduk ' .. selectedCar.label .. ' on otsas!')
            end
        else
            TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Teil ei ole piisavalt raha!')
        end
    else
        TriggerClientEvent('KKF.UI.ShowNotification', src, 'error', 'Mängijat ei leitud!')
    end
end)