local weaponEquipped = nil

local function deleteWeapon(name)
    local currentWeapon = Config.BackWeapons[name]
    DetachEntity(currentWeapon.entity, true, false); DeleteObject(currentWeapon.entity);
end

local function spawnWeapon(name)
    local currentWeapon = Config.BackWeapons[name]

    if DoesEntityExist(currentWeapon.entity) then
        deleteWeapon(name)
    end

    Config.BackWeapons[name].entity = exports['kk-scripts']:spawnAttachedObject(cache.ped, joaat(currentWeapon.model), 24816, currentWeapon.x, currentWeapon.y, currentWeapon.z, currentWeapon.xRot, currentWeapon.yRot, currentWeapon.zRot)
    Entity(Config.BackWeapons[name].entity).state.weapon = true
end

local function checkInventory()
	for k, v in pairs(Config.BackWeapons) do
        local itemCount = (exports.ox_inventory:Search('count', k) or 0)

		if itemCount > 0 then
			spawnWeapon(k)
        elseif itemCount < 1 then
            deleteWeapon(k)
		end
	end
end

local function removeWeapons()
	for k, v in pairs(Config.BackWeapons) do
        DetachEntity(v.entity, true, false); DeleteObject(v.entity);
	end
end

RegisterNetEvent('kk-scripts:client:reloadWeapons', checkInventory)
RegisterNetEvent('kk-scripts:client:removeWeapons', removeWeapons)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then 
        removeWeapons()
    end
end)

RegisterNetEvent('KKF.Player.Spawned', function()
    SetTimeout(2000, checkInventory)
end)

RegisterNetEvent('KKF.Player.Unloaded', removeWeapons)

AddEventHandler('ox_inventory:itemCount', function(name, count)
    for k,v in pairs(Config.BackWeapons) do
        if name == k then
            if count > 0 then
                spawnWeapon(name)
            elseif count < 1 then
                deleteWeapon(name)
            end
        end
    end
end)

AddEventHandler('ox_inventory:currentWeapon', function(currentWeapon)
    if currentWeapon then
        for k,v in pairs(Config.BackWeapons) do
            if k == currentWeapon.name then
                weaponEquipped = currentWeapon.name; deleteWeapon(currentWeapon.name); 
            end
        end
    else
        if weaponEquipped then
            spawnWeapon(weaponEquipped); weaponEquipped = nil
        end
    end
end)

CreateThread(function()
    while true do
        SetWeaponDamageModifier(`WEAPON_BAT`, 0.23)
        SetWeaponDamageModifier(`WEAPON_FLASHLIGHT`, 0.23)
        SetWeaponDamageModifier(`WEAPON_NIGHTSTICK`, 0.23)
        SetWeaponDamageModifier(`WEAPON_KNIFE`, 0.23)
        SetWeaponDamageModifier(`WEAPON_BOTTLE`, 0.23)
        SetWeaponDamageModifier(`WEAPON_KNUCKLE`, 0.23)
        SetWeaponDamageModifier(`WEAPON_KATANA_2`, 0.23)

        SetWeaponDamageModifier(`WEAPON_DAGGER`, 0.23)
        SetWeaponDamageModifier(`WEAPON_CROWBAR`, 0.23)
        SetWeaponDamageModifier(`WEAPON_GOLFCLUB`, 0.23)
        SetWeaponDamageModifier(`WEAPON_HAMMER`, 0.23)
        SetWeaponDamageModifier(`WEAPON_HATCHET`, 0.23)
        SetWeaponDamageModifier(`WEAPON_MACHETE`, 0.23)
        SetWeaponDamageModifier(`WEAPON_SWITCHBLADE`, 0.23)
        SetWeaponDamageModifier(`WEAPON_WRENCH`, 0.23)
        SetWeaponDamageModifier(`WEAPON_BATTLEAXE`, 0.23)

        Wait(0)
    end
end)