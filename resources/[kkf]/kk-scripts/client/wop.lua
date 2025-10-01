--[[local gunLimit, drugLimit, meleeLimit = 4, 5, 4
local ag, ad, am, ab = {}, {}, {}, {}
local w = {
    [1] = { ['type'] = 1, 'Carbine Rifle', ['item'] = 'WEAPON_CARBINERIFLE', ['model'] = '-2084633992', ['id'] = 'w_ar_carbinerifle', ['z'] = 0.1, ['rx'] = 0.0, ['ry'] = 0.0, ['rz'] = 0.0 },
	[2] = { ['type'] = 1, 'Pump Shotgun', ['item'] = 'WEAPON_PUMPSHOTGUN', ['model'] = '487013001', ['id'] = 'w_sg_pumpshotgun', ['z'] = 0.0, ['rx'] = 0.0, ['ry'] = 0.0, ['rz'] = 0.0 },
	[3] = { ['type'] = 1, 'Assault Rifle', ['item'] = 'WEAPON_ASSAULTRIFLE', ['model'] = '-1074790547', ['id'] = 'w_ar_assaultrifle', ['z'] = 0.0, ['rx'] = 0.0, ['ry'] = 0.0, ['rz'] = 0.0 },
	[4] = { ['type'] = 1, 'Sniper Rifle', ['item'] = 'WEAPON_SNIPERRIFLE', ['model'] = GetHashKey("WEAPON_SNIPERRIFLE"), ['id'] = 'w_sr_sniperrifle', ['z'] = 0.0, ['rx'] = 0.0, ['ry'] = 0.0, ['rz'] = 0.0 },
	[5] = { ['type'] = 1, 'Bat', ['item'] = 'WEAPON_BAT', ['model'] = GetHashKey("WEAPON_BAT"), ['id'] = 'w_me_bat', ['z'] = -0.2, ['rx'] = 0.0, ['ry'] = -270.0, ['rz'] = 0.0 },
}

local function deleteAttached()
	if #ag > 0 then for i = 1, #ag do DeleteEntity(ag[i]) end ag = {} end
	if #ad > 0 then for i = 1, #ad do DeleteEntity(ad[i]) end ad = {} end
	if #am > 0 then for i = 1, #am do DeleteEntity(am[i]) end am = {} end	
	if #ab > 0 then for i = 1, #ab do DeleteEntity(ab[i]) end ab = {} end
end

local function attachWeapons()
	if LocalPlayer.state.isLoggedIn then
		local ped = cache.ped
		local num, curw = GetCurrentPedWeapon(ped, false)
		local sheathed = false

		deleteAttached()

		for i = 1, #w do 
			if exports.ox_inventory:Search('count', w[i]['item']) > 0 then
				lib.requestModel(w[i]['id']); local mdl = GetHashKey(w[i]['id'])

				if w[i]['type'] == 1 and #ag < gunLimit and curw ~= tonumber(w[i]['model']) then
					local bone = GetPedBoneIndex(ped, 24818)
					ag[#ag+1] = CreateObject(mdl, 1.0, 1.0, 1.0, 1, 1, 0)
					SetEntityCollision(ag[#ag+1], false, false)
					AttachEntityToEntity(ag[#ag], ped, bone, w[i]['z'], -0.155, 0.21 - (#ag/10), w[i]['rx'], w[i]['ry'], w[i]['rz'], 0, 1, 0, 1, 0, 1)
				elseif w[i]['type'] == 2 and #ad < drugLimit and curw ~= tonumber(w[i]['model']) then
					local bone = GetPedBoneIndex(ped, 24817)
					ad[#ad+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
					AttachEntityToEntity(ad[#ad], ped, bone, w[i]['z']-0.1, -0.11, 0.24 - (#ad/10), w[i]['rx'], w[i]['ry'], w[i]['rz'], 0, 1, 0, 1, 0, 1)
					SetEntityCollision(ad[#ad+1], false, false)
				elseif w[i]['type'] == 3 and curw ~= tonumber(w[i]['model']) then
					local bone = GetPedBoneIndex(ped, 24817)
					am[#am+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
					SetEntityCollision(am[#am+1], false, false)
					-- melee weapons will be placed in specific spots pending on type here, sort of aids but we can have infinite really if they all have a belt spot or w./e
					-- also our item id is not the correct hash, so it fucks up atm. :)
					if w[i]['id'] == '3713923289' and curw ~= -581044007 then
						AttachEntityToEntity(am[#am], ped, bone, w[i]['z']-0.4, -0.135, -0.15, w[i]['rx'], w[i]['ry'], w[i]['rz'], 0, 1, 0, 1, 0, 1)
					end
				elseif w[i]['type'] == 4 and not sheathed then
					sheathed = true
					local bone = GetPedBoneIndex(ped, 24817)
					am[#am+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
					SetEntityCollision(am[#am+1], false, false)
					AttachEntityToEntity(am[#am], ped, bone, w[i]['z']-0.4, (w[i]['x'] or 0.0)-0.135, 0.0, w[i]['rx'], w[i]['ry'], w[i]['rz'], 0, 1, 0, 1, 0, 1)
				elseif w[i]['type'] == 5 and curw ~= tonumber(w[i]['model']) then
					am[#am+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
					SetEntityCollision(am[#am+1], false, false)
					local bone = GetPedBoneIndex(ped, 28422)
					AttachEntityToEntity(am[#am], ped, bone, 0.05, 0.01, -0.01, w[i]['rx'], w[i]['ry'], w[i]['rz'], 0, 1, 0, 1, 0, 1)
				elseif w[i]['type'] == 6 and curw ~= tonumber(w[i]['model']) then
					local bone = GetPedBoneIndex(ped, 24817)
					ab[#ab+1] = CreateObject(mdl, 1.0 ,1.0 ,1.0, 1, 1, 0)
					SetEntityCollision(ab[#ab+1], false, false)
					AttachEntityToEntity(ab[#ab], ped, bone, w[i]['z']-0.7, -0.02, 0.0, w[i]['rx'], w[i]['ry'], w[i]['rz'], 0, 1, 0, 1, 0, 1)
				end
			end
		end
	end
end

RegisterNetEvent('kk-scripts:client:attachWeapons', attachWeapons)

RegisterNetEvent('KKF.Player.Death', function() 
	attachWeapons()
end) 

RegisterNetEvent('kk-scripts:client:disableAttach', function(status)
	disabled = status

	if status then
		deleteAttached()
	else
		attachWeapons()
	end
end)]]