Config                 = {}
Config.DrawDistance    = 100.0
Config.MaxErrors       = 6
Config.SpeedMultiplier = 2.236936
Config.Locale          = 'en'

Config.Price = 1000

Config.Vehicle = joaat("regina")

Config.SpeedLimits = {
	town 	  = 80,
	freeway   = 999
}
Config.Ped = vec4(-1542.847, -437.685, 35.596, 272.052)


Config.Spawns = {
    {x = -1535.5780029297, y = -434.79559326172, z = 35.261596679688, h = 229.60629272461},
    {x = -1533.0461425781, y = -432.38241577148, z = 35.261596679688, h = 232.44094848633},
    {x = -1530.7912597656, y = -429.57363891602, z = 35.261596679688, h = 232.44094848633},
    {x = -1528.4439697266, y = -427.05493164063, z = 35.261596679688, h = 232.44094848633},
    {x = -1526.2153320313, y = -424.49670410156, z = 35.261596679688, h = 232.44094848633},
    {x = -1524.2241210938, y = -421.67471313477, z = 35.261596679688, h = 232.44094848633},
    {x = -1521.8637695313, y = -419.20880126953, z = 35.261596679688, h = 229.60629272461},
    {x = -1519.5823974609, y = -416.61099243164, z = 35.261596679688, h = 229.60629272461}
}

Config.CheckPoints = {
    -- Kui tahad kiiruse piirangut vahetada siis setCurrentZoneType('town') või setCurrentZoneType('freeway')
    {
        -- Näidis
        Pos = {x = -1518.0131835938, y = -448.97143554688, z = 35.261596679688}, --  samas formaadis kordinaat siia
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
            DrawMissionText("Kiirusepiirang linnades on 50 mph.", 5000)
        end
    },
    {
        Pos = {x = -1556.3736572266, y = -493.35824584961, z = 35.446899414063},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1556.3736572266, y = -493.35824584961, z = 35.446899414063},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1612.7471923828, y = -528.10546875, z = 34.553833007813},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1677.982421875, y = -551.22198486328, z = 35.126708984375},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1747.7406005859, y = -554.65057373047, z = 37.182373046875},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -2037.2307128906, y = -384.14505004883, z = 10.77880859375},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("freeway")
            DrawMissionText("Kiirusepiirangut kiirteel pole.", 5000)
        end
    },
    {
        Pos = {x = -1702.6549072266, y = -723.11206054688, z = 10.071044921875},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("freeway")
        end
    },
    {
        Pos = {x = -1702.6549072266, y = -723.11206054688, z = 10.071044921875},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("freeway")
            DrawMissionText("Kiirtee hakkab otsa saama! Valmistu sõitma 50 mph!", 5000)
        end
    },
    {
        Pos = {x = -1518.0659179688, y = -867.11206054688, z = 10.0205078125},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
            DrawMissionText("Kiirusepiirang on 50 mph.", 5000)
        end
    },
    {
        Pos = {x = -1431.2835693359, y = -908.69012451172, z = 10.761962890625},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1379.1823730469, y = -887.57800292969, z = 13.424194335938},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1321.1340332031, y = -874.95825195313, z = 14.114990234375},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1215.0856933594, y = -1191.5999755859, z = 7.5098876953125},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1166.1362304688, y = -1320.6065673828, z = 4.9150390625},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1114.8395996094, y = -1323.2043457031, z = 4.999267578125},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -981.59997558594, y = -1242.4879150391, z = 5.3699951171875},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -975.67913818359, y = -1168.9582519531, z = 3.802978515625},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1095.6922607422, y = -958.33843994141, z = 2.151611328125},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1081.9780273438, y = -907.22637939453, z = 3.5333251953125},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -863.55163574219, y = -948.79119873047, z = 15.597778320313},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -784.15386962891, y = -989.34063720703, z = 13.912841796875},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -700.43078613281, y = -960.36920166016, z = 19.052001953125},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -630.34283447266, y = -926.54504394531, z = 22.961181640625},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -605.98681640625, y = -854.79559326172, z = 25.2021484375},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -473.36703491211, y = -845.07690429688, z = 30.274047851563},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -222.35604858398, y = -880.24615478516, z = 29.717895507813},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -160.48352050781, y = -840.18463134766, z = 30.442504882813},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -132.22416687012, y = -742.79998779297, z = 34.250610351563},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -167.48571777344, y = -683.80218505859, z = 34.216796875},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -234.46153259277, y = -626.03076171875, z = 33.475463867188},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -110.04395294189, y = -253.70109558105, z = 44.107666015625},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -85.173622131348, y = -156.07911682129, z = 54.605102539063},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -132.67253112793, y = -79.621978759766, z = 55.430786132813},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -451.33184814453, y = 12.263737678528, z = 45.590454101563},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -548.67694091797, y = 45.692310333252, z = 47.022705078125},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -589.66156005859, y = 131.89450073242, z = 60.654174804688},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -704.99340820313, y = 117.01978302002, z = 56.0205078125},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -745.10766601563, y = 138.19779968262, z = 60.03076171875},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -800.74285888672, y = 221.16923522949, z = 75.7685546875},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1045.0549316406, y = 265.20001220703, z = 64.276977539063},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1080.3033447266, y = 196.98461914063, z = 60.82275390625},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -913.45056152344, y = -73.964828491211, z = 37.974365234375},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -957.82415771484, y = -144.23736572266, z = 37.569946289063},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1029.5736083984, y = -168.68571472168, z = 37.569946289063},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1140.4879150391, y = -129.63955688477, z = 38.934814453125},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1361.5384521484, y = -52.839561462402, z = 51.454223632813},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1399.806640625, y = -102.40879058838, z = 52.01025390625},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1441.7274169922, y = -193.92527770996, z = 47.342895507813},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1473.6395263672, y = -293.76263427734, z = 46.989013671875},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1418.5714111328, y = -363.04614257813, z = 39.170654296875},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },
    {
        Pos = {x = -1425.7978515625, y = -411.53405761719, z = 36.0029296875},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("Tuletan meelde kiirusepiirangud! Linnas 50 mph, asulavälistel teedel 80mph ja kiirteedel puudub kiirusepiirang! ")
        end
    },
    {
        Pos = {x = -1512.2504882813, y = -454.68130493164, z = 35.17724609375},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
            DrawMissionText("Pargi auto märgitud alasse ja load kantaksse andmebaasi! Palju õnne!", 5000)
        end
    },
    {
        -- Viimane punkt
        Pos = {x = -1531.1735839844, y = -442.81317138672, z = 35.126708984375}, --  samas formaadis kordinaat siia
        Action = function(playerPed, vehicle, setCurrentZoneType)
			TriggerEvent('kk-scripts:client:removeKey', GetVehicleNumberPlateText(vehicle))
			ESX.Game.DeleteEntity(vehicle)
		end		
    }
}