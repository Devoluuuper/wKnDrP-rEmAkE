if not IsDuplicityVersion() then
    local sent = {
        distress = false,
        panic = false
    }

    CreateThread(function()
        ESX.PlayerData = ESX.GetPlayerData()
    end)

    RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
        ESX.PlayerData = xPlayer
    end)

    RegisterNetEvent('KKF.Player.Unloaded', function()
        ESX.PlayerData = {}
    end)

    RegisterNetEvent('KKF.Player.JobUpdate', function(job)
	    ESX.PlayerData.job = job
    end)
    
    RegisterNetEvent('KKF.Player.DutyChange', function(value)
        ESX.PlayerData.job.onDuty = value
    end)

    RegisterNetEvent('radialmenu:client:sendDistressSignal', function()
        if not sent.distress then
            sent.distress = true
            TriggerEvent('kk-dispatch:client:sendDispatch', '10-47', 'ambulance', 'TEADVUSETU ISIK', nil, true); Wait(500)
            TriggerEvent('kk-dispatch:client:sendDispatch', '10-47', 'police', 'TEADVUSETU ISIK', nil, true)

            SetTimeout(5 * 60000, function()
                sent.distress = false
            end)
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Olete juba hädaabikutse saatnud!', 5000)
        end
    end)

    RegisterNetEvent('radialmenu:client:sendPanicSignal', function()
        if not sent.panic then
            sent.panic = true
            TriggerServerEvent('kk-society:server:activatePanic')

            SetTimeout(5 * 60000, function()
                sent.panic = false
            end)
        else
            TriggerEvent('KKF.UI.ShowNotification', 'error', 'Olete juba paanikaalarmi saatnud!', 5000)
        end
    end)
end



rootMenuConfig =  {
    {
        id = 'inGasStation',
        displayName = 'Osta kanister',
        icon = '#credit-card',
        functionName = 'ox_fuel:buyRCan',
        enableMenu = function()
            return not LocalPlayer.state.isDead and exports['ox_fuel']:inGasStation() and not cache.vehicle
        end
    },

    {
        id = 'corner',
        displayName = 'Alusta/Lõpeta tööd',
        icon = '#inside',
        functionName = 'kk-taxi:client:action',
        enableMenu = function()
            return not LocalPlayer.state.isDead and ESX.PlayerData.job.name == 'taxi' and ESX.PlayerData.job.onDuty
        end
    },
    
    {
        id = 'panicSignal',
        displayName = 'Paanikanupp',
        icon = '#dead',
        functionName = 'radialmenu:client:sendPanicSignal',
        enableMenu = function()
            return LocalPlayer.state.isDead and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'ambulance') and ESX.PlayerData.job.onDuty
        end
    },
    {
        id = 'distressSignal',
        displayName = 'Hädaabisignaal',
        icon = '#question',
        functionName = 'radialmenu:client:sendDistressSignal',
        enableMenu = function()
            return LocalPlayer.state.isDead
        end
    },
    -- {
    --     id = 'enterRobHouse',
    --     displayName = 'Sisene',
    --     icon = '#enter-door',
    --     functionName = 'kk-robberies:client:house:enter',
    --     enableMenu = function()
    --         return not LocalPlayer.state.isDead and exports['kk-robberies']:getRadial() == 'enter'
    --     end
    -- },
    -- {
    --     id = 'leaveRobHouse',
    --     displayName = 'Lahku',
    --     icon = '#close-door',
    --     functionName = 'kk-robberies:client:house:leave',
    --     enableMenu = function()
    --         return not LocalPlayer.state.isDead and exports['kk-robberies']:getRadial() == 'leave'
    --     end
    -- },
    {
        id = 'enterLab',
        displayName = 'Sisene',
        icon = '#enter-door',
        functionName = 'kk-druglabs:client:enterLab',
        enableMenu = function()
            return not LocalPlayer.state.isDead and exports['kk-druglabs']:pointLocation() == 'enter'
        end
    },
    {
        id = 'leaveLab',
        displayName = 'Lahku',
        icon = '#close-door',
        functionName = 'kk-druglabs:client:leaveLab',
        enableMenu = function()
            return not LocalPlayer.state.isDead and exports['kk-druglabs']:pointLocation() == 'leave'
        end
    },
    { 
        id = 'garage',
        displayName = 'Garaaž',
        icon = '#park',
        functionName = 'kk-garages:client:garageAction',
        enableMenu = function()
            return not LocalPlayer.state.isDead and exports['kk-garages']:isInGarageZone() == 'garage'
        end
    },
    { 
        id = 'impound',
        displayName = 'Kindlustus',
        icon = '#park',
        functionName = 'kk-garages:client:garageAction',
        enableMenu = function()
            return not LocalPlayer.state.isDead and exports['kk-garages']:isInGarageZone() == 'impound' and not cache.vehicle
        end
    },


    {
        id = 'garbage',
        displayName = 'Jäätmejaam',
        icon = '#trash',
        functionName = 'kk-garbage:client:deliverGarbage',
        enableMenu = function()
            return not LocalPlayer.state.isDead and exports['kk-garbage']:inDelivery() and (cache.vehicle and cache.seat == -1)
        end
    },
	{
        id = 'cleanhands',
        displayName = 'Puhasta Käsi',
        icon = '#hands',
        functionName = 'kk-police:client:cleanHandsWater',
        enableMenu = function()
            return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed and IsEntityInWater(cache.ped)
        end
    },

    {
        id = 'animations',
        displayName = 'Animatsioonid',
        icon = '#animations',
        enableMenu = function()
            return not LocalPlayer.state.isDead and LocalPlayer.state.isCuffed ~= 'hard' and exports['kk-emotes']:globalCanInteract()
        end,
        functionName = 'kk-emotes:client:openMenu'
    },
    
    {
        id = 'clotheMenu',
        displayName = 'Riided',
        icon = '#tshirt',
        enableMenu = function()
            return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed
        end,
        subMenus = {'clothes:bag', 'clothes:glasses', 'clothes:hat', 'clothes:mask', 'clothes:pants', 'clothes:shirt', 'clothes:shoes', 'clothes:top', 'clothes:vest'}
    },
    
    {
        id = 'blipMenu',
        displayName = 'Blipid',
        icon = '#icon-map',
        enableMenu = function()
            return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed
        end,
        subMenus = {'blips:appearance', 'blips:jobs'}
    },

    {
        id = 'carMenu',
        displayName = 'Sõiduk',
        icon = '#car',
        functionName = 'kk-vehiclemenu:client:openMenu',
        enableMenu = function()
            return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed and cache.vehicle
        end
    }, 

    {
        id = 'invoiceAction',
        displayName = 'Loo arve',
        icon = '#icon-clipboard',
        functionName = 'kk-scripts:client:openBillingMenu',
        enableMenu = function()
            return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed and (ESX.PlayerData.job.name == 'taxi' or ESX.PlayerData.job.name == 'doj') and ESX.PlayerData.job.onDuty
        end
    },

    {
        id = 'societyMenu',
        displayName = 'Fraktsiooni menüü',
        icon = '#mdt',
        functionName = 'kk-factions:openMenu',
        enableMenu = function()
            return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed
        end
    },
    {
        id = 'mdt',
        displayName = 'Infosüsteem',
        icon = '#mdt',
        functionName = 'kk-mdt:client:openMenu',
        enableMenu = function()
            return not LocalPlayer.state.isDead and LocalPlayer.state.isCuffed ~= 'hard' and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'ambulance') and ESX.PlayerData.job.onDuty
        end
    },
	
	{
        id = 'policeRadar',
        displayName = 'Auto radar',
        icon = '#icon-radar',
		functionName = 'wk:openRemote',
        enableMenu = function()
            return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed and cache.vehicle and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty)
        end,
    },

    {
        id = 'policeVehicleMenu',
        displayName = 'Politsei sõidukid',
        icon = '#car',
        enableMenu = function()
            return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed and not cache.vehicle and (ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.onDuty)
        end,
        subMenus = {'police:vehicle:impound'}
    },


    {
        id = 'ambulanceMenu',
        displayName = 'Kiirabi',
        icon = '#icon-ambulance',
        enableMenu = function()
            return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed and not cache.vehicle and (ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.onDuty)
        end,
        subMenus = {'ambulance:healNearby', 'ambulance:reviveNearby', 'police:escort', 'police:putVehicle', 'police:takeVehicle'}
    },

    {
        id = 'mechanicMenu',
        displayName = 'Mehaanik',
        icon = '#wrench',
        enableMenu = function()
            return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed and not cache.vehicle and exports['kk-mechanic']:canInteract()
        end,
        subMenus = {'mechanic:startRepair'}
    },

    {
        id = 'reviewVehicle',
        displayName = 'Tutvu sõidukiga',
        icon = '#search',
        functionName = 'kk-mechanic:client:reviewVehicle',
        enableMenu = function()
            return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed and cache.vehicle and exports['kk-mechanic']:inMechanic() and exports['kk-mechanic']:canInteract()
        end
    },

    {
        id = 'registrationPoint',
        displayName = 'Registratuur',
        icon = '#forms',
        functionName = 'kk-ambulance:client:registrationPoint',
        enableMenu = function()
            return exports['kk-ambulance']:registrationPoint()
        end
    },

    {
        id = 'carTuning',
        displayName = 'Tuunimine',
        icon = '#wrench',
        functionName = 'kk-customs:client:enterLocation',
        enableMenu = function()
            return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed and cache.vehicle and exports['qb-customs']:inZone()
        end
    },
     {
         id = 'carTuning',
         displayName = 'Stancer',
         icon = '#up',
         functionName = 'kk-stancer:client:openMenu',
         enableMenu = function()
             return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed and cache.vehicle and exports['kk-stancer']:inZone()
         end
     },

    {
        id = 'taxiAcion',
        displayName = 'Alusta/Lõpeta tööd',
        icon = '#inside',
        functionName = 'kk-taxi:client:startJob',
        enableMenu = function()
            return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed and cache.vehicle and ESX.PlayerData.job.name == 'taxi' and ESX.PlayerData.job.onDuty
        end
    },

    {
        id = 'exercise',
        displayName = 'Tee trenni',
        icon = '#walking',
        functionName = 'kk-gym:client:interact',
        enableMenu = function()
            return not cache.vehicle and not LocalPlayer.state.isDead and exports['kk-scripts']:currentExercise()
        end
    },
    

    {
        id = 'removeScuba',
        displayName = 'Võta seljast',
        icon = '#tshirt',
        functionName = 'kk-scripts:client:removeScuba',
        enableMenu = function()
            return not cache.vehicle and not LocalPlayer.state.isDead and exports['kk-scripts']:isUsingScuba()
        end
    },
}

newSubMenus = {
    -- Mechanic
    ['mechanic:startRepair'] = {
        title = 'Paranda',
        icon = '#wrench',
        functionName = 'kk-mechanic:client:startRepairMenu'
    },


    ['police:vehicle:impound'] = {
        title = 'Aresti sõiduk',
        icon = '#icon-impound',
        functionName = 'kk-police:client:requestImpound'
    },

    ['police:viewId'] = {
        title = 'Vaata ID-Kaarti',
        icon = '#icon-id',
        functionName = 'kk-police:client:checkId'
    },

    ['police:escort'] = {
        title = 'Eskordi',
        icon = '#icon-escort',
        functionName = 'kk-police:client:escortNearby'
    },

    ['police:putVehicle'] = {
        title = 'Pane sõidukisse',
        icon = '#icon-seat',
        functionName = 'kk-police:client:putToVehicle'
    },

    ['police:takeVehicle'] = {
        title = 'Võta sõidukist',
        icon = '#icon-unseat',
        functionName = 'kk-police:client:takeFromVehicle'
    },

    ['police:gsrTest'] = {
        title = 'Püssirohutest',
        icon = '#icon-search',
        functionName = 'kk-police:client:gsrtest'
    },
	
	['police:revive'] = {
        title = 'Elustamine',
        icon = '#icon-revive',
        functionName = 'kk-police:client:revive'
    },
	
	['police:gps'] = {
        title = 'Gps',
        icon = '#icon-gps',
        functionName = 'kk-scripts:client:toggleStation'
    },


 -- Clothes

    ['clothes:bag'] = {
        title = 'Kott',
        icon = '#bag',
        functionName = 'KKF.Clothes.Bag'
    },

    ['clothes:glasses'] = {
        title = 'Prillid',
        icon = '#glasses',
        functionName = 'KKF.Clothes.Glasses'
    },

    ['clothes:hat'] = {
        title = 'Peakate',
        icon = '#hat',
        functionName = 'KKF.Clothes.Hat'
    },

    ['clothes:mask'] = {
        title = 'Mask',
        icon = '#mask',
        functionName = 'KKF.Clothes.Mask'
    },

    ['clothes:pants'] = {
        title = 'Püksid',
        icon = '#pants',
        functionName = 'KKF.Clothes.Pants'
    },

    ['clothes:shirt'] = {
        title = 'Särk',
        icon = '#tshirt',
        functionName = 'KKF.Clothes.Shirt'
    },

    ['clothes:shoes'] = {
        title = 'Jalanõud',
        icon = '#shoes',
        functionName = 'KKF.Clothes.Shoes'
    },

    ['clothes:top'] = {
        title = 'Torso',
        icon = '#tshirt',
        functionName = 'KKF.Clothes.Top'
    },
    
    ['clothes:vest'] = {
        title = 'Vest',
        icon = '#vest',
        functionName = 'KKF.Clothes.Vest'
    },

    -- Blips

    ['blips:appearance'] = {
        title = 'Välimus',
        icon = '#icon-shirt',
        functionName = 'kk-clothes:client:appearanceBlips'
    },
}