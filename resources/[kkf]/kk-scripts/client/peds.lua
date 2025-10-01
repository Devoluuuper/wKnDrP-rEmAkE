
--Peds
Citizen.CreateThread(function()
	for _, item in pairs(Config.Peds) do
		RequestModel(GetHashKey(item.model))
	
		while not HasModelLoaded(GetHashKey(item.model)) do
			Wait(1)
		end
	
		local npc = CreatePed(4, GetHashKey(item.model), item.x, item.y, item.z, item.h, false, true)
		DecorSetBool(npc, "is_spawned", 1)

		FreezeEntityPosition(npc, true)	
		SetEntityHeading(npc, item.h)
		SetEntityInvincible(npc, true)
		SetBlockingOfNonTemporaryEvents(npc, true)

		RequestAnimDict(item.animation)

		while not HasAnimDictLoaded(item.animation) do
			Citizen.Wait(1000)
		end
			
		Citizen.Wait(200)	
		TaskPlayAnim(npc,item.animation,item.animationName,1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
	end
end)