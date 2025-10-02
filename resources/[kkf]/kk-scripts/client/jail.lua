-- local isJailed = false
-- local jailTime = 0

-- RegisterNetEvent('KKF.Player.Loaded', function(xPlayer)
--     KKF.CreateBlip('jail', vec3(1635.277, 2501.774, 45.565), 'Vangla', 188, 1, 0.7)
-- end)

-- function JailProcess()
--     SetTimeout(
--         1000,
--         function()
--             if jailTime % 60 == 0 then
--                 TriggerEvent("kk-needs:client:addNeed", "hunger", 100000)
--                 TriggerEvent("kk-needs:client:addNeed", "thirst", 100000)


--                 TriggerServerEvent("kk-jail:updateJailed", jailTime)
--             end

--             if jailTime == 0 then
--                 TriggerServerEvent("kk-jail:updateJailed", 0)
--                 TriggerEvent('KKF.UI.ShowNotification',"info", "Sinu vangla karistus on läbi, mine valvuri juurde ja lase ennast välja")
--                 jailTime = 0
--                 isJailed = false
--             else
--                 jailTime = jailTime - 1

--                 if #(GetEntityCoords(cache.ped) - vec3(1635.277, 2501.774, 45.565)) > 500 then
-- 				    DoScreenFadeOut(4000)
-- 					Wait(4000)
-- 					DoScreenFadeIn(4000)
-- 					TriggerEvent("InteractSound_CL:PlayOnOne", "jaildoor", 1.0)
--                     SetEntityCoords(cache.ped, 1817.9754638672,2594.2690429688,45.722831726074)
--                     TriggerEvent('KKF.UI.ShowNotification',"error", "Kuhu põgenete? Oodake oma vangistus lõpuni.")
--                 end
--             end

--             if isJailed then
--                 JailProcess()
--             end
--         end
--     )
-- end

-- local function IsJailed()
--     return isJailed
-- end

-- exports('IsJailed', IsJailed)

-- RegisterNetEvent("kk-jail:setJailed")
-- AddEventHandler("kk-jail:setJailed",function(time, justJoined)
-- 	ClearPedTasks(cache.ped)
-- 	ClearPedSecondaryTask(cache.ped)
-- 	SetPedStealthMovement(cache.ped, false, "")
	
-- 	isJailed = true
	
-- 	if justJoined then
-- 		jailTime = time
-- 		SetEntityCoords(cache.ped, 1761.3972167969,2497.048828125,45.740772247314)
-- 		JailProcess()
-- 		TriggerEvent("chatMessage", "DOC", 2, "Teil on vanglas jäänud " .. KKF.Math.Round(time / 60) .. " kuud!")
-- 	else
-- 		takeMugshot(
-- 			function()
-- 	TriggerServerEvent('kk-jail:server:confiscateItems')
-- 				jailTime = time
-- 				SetEntityCoords(cache.ped, 1761.3972167969,2497.048828125,45.740772247314)
-- 				JailProcess()
	
-- 				TriggerEvent("chatMessage", "DOC", 2, "Teid on vangistatud " .. KKF.Math.Round(time / 60) .. " kuuks!")
-- 			end)
-- 	end
-- end)

-- local function loadAnimDict(dict)
-- 	while not HasAnimDictLoaded(dict) do
-- 		RequestAnimDict(dict)
-- 		Wait(5)
-- 	end
-- end



-- function takeMugshot(cb)	

--     lib.requestModel(`s_m_m_prisguard_01`)

-- 	local entity = CreatePed(4, `s_m_m_prisguard_01`, 1841.4197998047, 2594.28125, 46.01171875 - 1, 277.79528808594 or 0, false, false)

-- 	SetBlockingOfNonTemporaryEvents(entity, true)
-- 	SetPedDiesWhenInjured(entity, false)
-- 	SetPedCanPlayAmbientAnims(entity, true)
-- 	SetPedCanRagdollFromPlayerImpact(entity, false)
-- 	SetEntityInvincible(entity, true)
-- 	FreezeEntityPosition(entity, true)

-- 	loadAnimDict('amb@world_human_paparazzi@male@base')
-- 	TaskPlayAnim(entity, 'amb@world_human_paparazzi@male@base', 'base', 8.0, 1.0, -1, 49, 0, 0, 0, 0)

-- 	local newProp = CreateObject(`prop_pap_camera_01`, GetEntityCoords(entity).x, GetEntityCoords(entity).y, GetEntityCoords(entity).z + 0.2, true, true, true)

-- 	while not DoesEntityExist(newProp) do Wait(50) end
    
--        SetEntityCollision(newProp, false, false)
-- 	AttachEntityToEntity(newProp, entity, GetPedBoneIndex(entity, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
	
	
--     DoScreenFadeOut(2300)
--     Wait(2300)
--     DoScreenFadeIn(2300)
-- 	FreezeEntityPosition(ped, true)
	
--     TriggerEvent("InteractSound_CL:PlayOnOne", "uncuff", 0.3)
-- 	SetEntityCoords(cache.ped, 1844.47265625,2594.3911132813,45.0)
-- 	SetEntityHeading(cache.ped, 95.86)

	
-- 	ExecuteCommand("e mugshot")

--     Wait(2500)
--     TriggerEvent("InteractSound_CL:PlayOnOne", "photo", 0.3)

--     SetEntityHeading(cache.ped, 5.19)

--     Wait(2500)
--     TriggerEvent("InteractSound_CL:PlayOnOne", "photo", 0.3)

--     SetEntityHeading(cache.ped, 273.25)

--     Wait(2500)
--     TriggerEvent("InteractSound_CL:PlayOnOne", "photo", 0.3)

--     SetEntityHeading(cache.ped, 181.3)

--     Wait(2500)
--     TriggerEvent("InteractSound_CL:PlayOnOne", "photo", 0.3)

--     SetEntityHeading(cache.ped, 95.86)

--     Wait(2500)
--     TriggerEvent("InteractSound_CL:PlayOnOne", "photo", 0.4)

--     SetEntityHeading(cache.ped, 273.25)

--     Wait(2500)
--     TriggerEvent("InteractSound_CL:PlayOnOne", "photo", 0.4)

--     DoScreenFadeOut(2300)
--     Wait(2300)
--     DoScreenFadeIn(2300)

--     ClearPedTasksImmediately(cache.ped)
--     TriggerEvent("InteractSound_CL:PlayOnOne", "jaildoor", 1.0)
--     FreezeEntityPosition(cache.ped, false)
	
-- 	DeleteEntity(entity)
-- 	DeleteEntity(newProp)

--     cb()
-- end

-- RegisterNetEvent("kk-jail:unJail")
-- AddEventHandler("kk-jail:unJail",function()
--         jailTime = 0
--         isJailed = false

--         SetEntityCoords(cache.ped, 1837.3041992188,2589.3876953125,46.014335632324)

--         TriggerServerEvent("kk-jail:updateJailed", 0)
-- 		TriggerServerEvent('kk-jail:server:recieveConfiscatedItems')
-- end)


-- RegisterNetEvent('kk-jail:client:unJails')
-- AddEventHandler('kk-jail:client:unJails', function()
--     if jailTime == 0 and isJailed == false then
--         SetEntityCoords(cache.ped, 1837.3041992188,2589.3876953125,46.014335632324)
-- 		TriggerServerEvent('kk-jail:server:recieveConfiscatedItems')
--     else
--         TriggerEvent('KKF.UI.ShowNotification',"info", "Valvur: Kanna karistus lõpuni ikka...")
--     end
-- end)


-- RegisterNetEvent('kk-jail:client:checktime')
-- AddEventHandler('kk-jail:client:checktime', function()
--     ExecuteCommand("vangla")
-- end)

-- RegisterNetEvent('kk-jail:call')
-- AddEventHandler('kk-jail:call', function()
--     if isJailed then
--         local input = lib.inputDialog('Vangla telefon', {'Sisesta telefoninumber'})

--         if input then
--             local phoneNumber = input[1]
        
--             if phoneNumber then TriggerEvent('kk-phone:client:callBooth', phoneNumber) end
--         end
--     else
--         TriggerEvent('KKF.UI.ShowNotification',"error", "Valvur: Antud teenus on ainult vangidele!")
--     end
-- end)

-- RegisterCommand(
--     "vangla",
--     function(source, args)
--         if isJailed then
--             TriggerEvent('KKF.UI.ShowNotification',
--                 "info",
--                 "Teil on jäänud vanglas umbes " .. KKF.Math.Round(jailTime / 60) .. " kuud."
--             )
--         else
--             TriggerEvent('KKF.UI.ShowNotification',"error", "Te ei kanna hetkel ühtegi karistust.")
--         end
--     end,
--     false
-- )

-- TriggerEvent("chat:addSuggestion", "/vangla", "Vaata palju on veel jäänud kanda vanglakaristust.", {})

-- RegisterNetEvent('kk-jail:openjailmenu')
-- AddEventHandler('kk-jail:openjailmenu', function()
--     local elements = {
--         [1] = {
--             title = 'Laena telefoni',
--             event = 'kk-jail:call'
--         },
--         [2] = {
--             title = 'Vaheta Karakterit',
--             serverEvent = 'kk-core:server:unload'
--         },
--         [3] = {
--             title = 'Aega veel:',
--             event = 'kk-jail:client:checktime',
--             description = 'Sul on aega järele: ' .. KKF.Math.Round(jailTime / 60) .. ' kuud'
--         }
--     }
    
--     if jailTime == 0 and isJailed == false then
--         elements[#elements + 1] = {
--             title = 'Kirjuta ennast vanglast välja',
--             event = 'kk-jail:client:unJails'
--         }
--     end

--     lib.registerContext({
--         id = 'jailmenu',
--         title = 'Vangivalvur',
--         options = elements
--     })

--     lib.showContext('jailmenu')	
-- end)

-- --ajail
-- local isAJailed = false
-- local AJailTime = 0


-- function AJailProcess()
--     SetTimeout(
--         1000,
--         function()
--             if AJailTime % 60 == 0 then
--                 TriggerEvent("kk-needs:client:addNeed", "hunger", 100000)
--                 TriggerEvent("kk-needs:client:addNeed", "thirst", 100000)


--                 TriggerServerEvent("kk-AJail:updateAJailed", AJailTime)
--             end

--             if AJailTime == 0 then
--                 TriggerServerEvent("kk-AJail:updateAJailed", 0)
--                 TriggerEvent('kk-AJail:unAJail')
--                 AJailTime = 0
--                 isAJailed = false
--             else
--                 AJailTime = AJailTime - 1

--                 if #(GetEntityCoords(cache.ped) - vec3(2703.6525878906,1619.5941162109,41.82303237915)) > 250 then
--                     SetEntityCoords(cache.ped, 2703.6525878906,1619.5941162109,41.82303237915)
--                     TriggerEvent('KKF.UI.ShowNotification',"error", "Kuhu põgenete? Oodake oma vangistus lõpuni.")
--                 end
--             end

--             if isAJailed then
--                 AJailProcess()
--             end
--         end
--     )
-- end

-- local function IsAJailed()
--     return isAJailed
-- end

-- exports('IsAJailed', IsAJailed)

-- RegisterNetEvent("kk-AJail:setAJailed")
-- AddEventHandler('kk-AJail:setAJailed', function(time, justJoined)
--         ClearPedTasks(cache.ped)
--         ClearPedSecondaryTask(cache.ped)
--         SetPedStealthMovement(cache.ped, false, "")

--         isAJailed = true

--         if justJoined then
--             AJailTime = time
--             SetEntityCoords(cache.ped, 2703.6525878906,1619.5941162109,41.82303237915)
--             AJailProcess()
--             TriggerEvent("chatMessage", "AJAIL", 2, "Teil on admin vanglas jäänud " .. KKF.Math.Round(time / 60) .. " Minutit!")
-- 			TriggerEvent("InteractSound_CL:PlayOnOne", "jaildoor", 1.0)
--         else
-- 			TriggerServerEvent('kk-jail:server:confiscateItems')
--             AJailTime = time
-- 			DoScreenFadeOut(2300)
--             Wait(2300)
--             DoScreenFadeIn(2300)
--             SetEntityCoords(cache.ped, 2703.6525878906,1619.5941162109,41.82303237915)
--             AJailProcess()	  
-- 			TriggerEvent("InteractSound_CL:PlayOnOne", "jaildoor", 1.0)
--         end
--     end)

-- RegisterNetEvent("kk-AJail:unAJail")
-- AddEventHandler("kk-AJail:unAJail", function()
--         AJailTime = 0
--         isAJailed = false

--         SetEntityCoords(cache.ped, -260.15863037109,-974.51568603516,31.220010757446)

--         TriggerServerEvent("kk-AJail:updateAJailed", 0)
-- 		DoScreenFadeOut(2300)
--         Wait(2300)
--         DoScreenFadeIn(2300)
-- 		TriggerServerEvent('kk-jail:server:recieveConfiscatedItems')
-- 		TriggerEvent('kk-ambulance:revive', true)
--     end)



-- RegisterCommand("ajail", function(source, args)
--         if isAJailed then
--             TriggerEvent('KKF.UI.ShowNotification',
--                 "info",
--                 "Teil on jäänud Admin vanglas veel umbes " .. KKF.Math.Round(AJailTime / 60) .. " minutit."
--             )
--         else
--             TriggerEvent('KKF.UI.ShowNotification',"error", "Te hetkel pole admin vanglas")
--         end
--     end, false)

-- TriggerEvent("chat:addSuggestion", "/ajail", "Vaata palju on veel jäänud kanda admin vanglakaristust.", {})



---------- SEDA SITTA MUL KA EI OLE VAJA