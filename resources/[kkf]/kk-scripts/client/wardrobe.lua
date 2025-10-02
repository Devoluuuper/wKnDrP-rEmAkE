local allMyOutfits = {}
local isCreating = false

exports('creatingCharacter', function()
	return isCreating
end)

RegisterNetEvent('wardrobe:clothingShop', function()
    lib.registerContext({
        id = 'wardrobe_shop',
        title = 'Riidekapp',
        options = {
            ['Vaheta riideid'] = {
                description = '',
                event = 'wardrobe:pickNewOutfit'
            },

			['Salvesta riidekomplekt'] = {
                description = '',
                event = 'wardrobe:saveOutfit'
            },

			['Kustuta riidekomplekt'] = {
                description = '',
                event = 'wardrobe:deleteOutfitMenu'
            }
        }
    })

    lib.showContext('wardrobe_shop')
end)

RegisterNetEvent('wardrobe:pickNewOutfit', function()
    local elements = {}

	TriggerEvent('wardrobe:getOutfits')

	Wait(300)

	for i=1, #allMyOutfits, 1 do
		elements[allMyOutfits[i].name] = {
			description = '',
			event = 'wardrobe:getOutfit',
			args = allMyOutfits[i].outfit
		}
	end

	lib.registerContext({
        id = 'wardrobe_picking',
        title = 'Riidekomplekti valimine',
		menu = 'wardrobe_shop',
        options = elements
    })

    lib.showContext('wardrobe_picking')
end)

RegisterNetEvent('wardrobe:getOutfit')
AddEventHandler('wardrobe:getOutfit', function(data)
	exports['kk-clothing']:SetSkin(data.model, true)

	SetTimeout(500, function()
		TriggerEvent('InteractSound_CL:PlayOnOne', 'Clothes1', 0.7)
		TriggerEvent('bluum-appearnance:loadClothes', data)
		TriggerServerEvent('bluum-appearnance:save', data)
	end)
end)

RegisterNetEvent('wardrobe:getOutfits')
AddEventHandler('wardrobe:getOutfits', function()
	TriggerServerEvent('wardrobe:getOutfits')
end)

RegisterNetEvent('wardrobe:sendOutfits')
AddEventHandler('wardrobe:sendOutfits', function(myOutfits)
	local Outfits = {}
	for i=1, #myOutfits, 1 do
		table.insert(Outfits, {id = myOutfits[i].id, name = myOutfits[i].name, outfit = myOutfits[i].outfit})
	end
	allMyOutfits = Outfits
end)

RegisterNetEvent('wardrobe:saveOutfit', function()
	local keyboard = lib.inputDialog('Riidekapp', {'Sisestage nimi'})

	if keyboard then
		local item = keyboard[1]

		if item then
			TriggerServerEvent('wardrobe:saveOutfit', item)
		end
	end
end)

RegisterNetEvent('wardrobe:deleteOutfitMenu', function()
    local elements = {}

	TriggerEvent('wardrobe:getOutfits')
	Citizen.Wait(450)

	for i=1, #allMyOutfits, 1 do
        elements[allMyOutfits[i].name] = {
			description = '',
            event = 'wardrobe:deleteOutfit',
            args = {id = allMyOutfits[i].id}
        }
	end

	lib.registerContext({
        id = 'wardrobe_delete',
        title = 'Riidekomplekti kustutamine',
		menu = 'wardrobe_shop',
        options = elements
    })

    lib.showContext('wardrobe_delete')
end)

RegisterNetEvent('wardrobe:deleteOutfit')
AddEventHandler('wardrobe:deleteOutfit', function(data)
	TriggerServerEvent('wardrobe:deleteOutfit', data.id)
end)

RegisterNetEvent('kk-skin:openRegisterMenu')
AddEventHandler('kk-skin:openRegisterMenu', function(sex)
	local model

	if sex == 'm' then 
		model = `mp_m_freemode_01`
	elseif sex == 'f' then
		model = `mp_f_freemode_01`
	end

	repeat Wait(200) until model ~= nil

	lib.requestModel(model)
	exports['kk-clothing']:SetSkin(model, true)
	SetModelAsNoLongerNeeded(model)
	SetPedAoBlobRendering(cache.ped, true)
	ResetEntityAlpha(cache.ped)

	TriggerEvent('bluum-appearnance:firstTime', true); first = true
	TriggerEvent('kk-clothing:startPlayerCustomization', function(appearance)
		first = false
	end, 'barbermenu')

	while first do
		Wait(50)
	end

	TriggerEvent('kk-clothing:startPlayerCustomization', function(appearance2)
		TriggerEvent('bluum-appearnance:firstTime', false)
		KKF.SetPlayerData('ped', PlayerPedId()) -- Fix for KKF legacy

		TriggerEvent('KKF.Clothing.Reload')

		DoScreenFadeOut(2); SetEntityCoords(cache.ped, vec3(264.016,-996.576,-99.008))
		TriggerEvent('kk-apartments:client:enterOwn', true)
		Wait(1250)
		DoScreenFadeIn(2500)
		TriggerEvent('kk-guide:client:open')
	end, 'clothesmenu')
end)