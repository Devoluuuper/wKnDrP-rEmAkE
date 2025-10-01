Config = {}
Config.DrawDistance = 100.0
Config.SpeedMultiplier = 2.236936
Config.Locale = "en"

Config.Price = 0

Config.Vehicle = joaat("bmx")

Config.SpeedLimits = {
    town = 50,
    freeway = 999
}

Config.Ped = vec4(1171.75390625, 252.42198181152, 81.885009765625, 226.77166748047)

Config.Spawn = { x = 1175.1823730469, y = 250.25933837891, z = 81.261596679688, h = 136.06298828125}

Config.CheckPoints = {
    {
        Pos = { x = 1175.1823730469, y = 250.25933837891, z = 81.261596679688, h = 136.06298828125},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1151.7230224609, y = 212.26812744141, z = 81.261596679688, h = 153.07086181641},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1129.3187255859, y = 176.74285888672, z = 81.278442382812, h = 147.40158081055},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1106.2153320312, y = 140.36044311523, z = 81.278442382812, h = 144.56690979004},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1083.2438964844, y = 104.2681350708, z = 81.278442382812, h = 144.56690979004},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1060.3648681641, y = 67.793411254883, z = 81.261596679688, h = 150.23622131348},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1038.3297119141, y = 31.661540985107, z = 81.278442382812, h = 147.40158081055},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1015.859375, y = -5.1032943725586, z = 81.278442382812, h = 164.4094543457},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1010.3076782227, y = -38.637359619141, z = 81.278442382812, h = 195.5905456543},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1030.3253173828, y = -66.329666137695, z = 81.261596679688, h = 238.11022949219},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1063.6351318359, y = -72.01318359375, z = 81.261596679688, h = 280.62991333008},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1090.9846191406, y = -52.799999237061, z = 81.278442382812, h = 331.65353393555},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1113.7846679688, y = -16.378017425537, z = 81.278442382812, h = 331.65353393555},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1137.3890380859, y = 19.846155166626, z = 81.278442382812, h = 331.65353393555},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1159.8198242188, y = 55.925273895264, z = 81.278442382812, h = 331.65353393555},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1182.5406494141, y = 91.898902893066, z = 81.278442382812, h = 328.81890869141},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1205.3670654297, y = 128.21539306641, z = 81.261596679688, h = 328.81890869141},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1227.876953125, y = 163.7142791748, z = 81.278442382812, h = 328.81890869141},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1250.1625976562, y = 201.62637329102, z = 81.261596679688, h = 331.65353393555},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1255.6219482422, y = 234.56703186035, z = 81.278442382812, h = 11.338582038879},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1236.5802001953, y = 262.76043701172, z = 81.278442382812, h = 56.69291305542},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        Pos = { x = 1203.0856933594, y = 267.94287109375, z = 81.278442382812, h = 107.71653747559},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType("town")
        end
    },

    {
        -- Viimane punkt
        Pos = { x = 1175.1823730469, y = 250.25933837891, z = 81.261596679688, h = 136.06298828125}, --  samas formaadis kordinaat siia
        Action = function(playerPed, vehicle, setCurrentZoneType)
            TriggerEvent('kk-scripts:client:removeKey', GetVehicleNumberPlateText(vehicle)); ESX.Game.DeleteEntity(vehicle); StopDriveTest(true)
        end
    }
}
