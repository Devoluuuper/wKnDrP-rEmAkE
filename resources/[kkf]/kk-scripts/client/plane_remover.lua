CreateThread(function()
    -- Other stuff normally here, stripped for the sake of only scenario stuff
    local SCENARIO_TYPES = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL", -- Zancudo Small Planes
        "WORLD_VEHICLE_MILITARY_PLANES_BIG", -- Zancudo Big Planes
		'WORLD_VEHICLE_POLICE_BIKE',
		'WORLD_VEHICLE_POLICE_CAR',
		'WORLD_VEHICLE_POLICE',
		'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',		
		'WORLD_VEHICLE_SECURITY_CAR',
		"WORLD_MOUNTAIN_LION_REST",
		"WORLD_MOUNTAIN_LION_WANDER",
		"WORLD_BOAR_GRAZING",
		"WORLD_COYOTE_HOWL",
		"WORLD_COYOTE_REST",
		"WORLD_COYOTE_WANDER",
		"WORLD_COYOTE_WALK",
		"WORLD_DEER_GRAZING",
		"WORLD_DOG_BARKING_SHEPHERD",
		"WORLD_DOG_BARKING_SHEPHERD",
		"WORLD_DOG_SITTING_SHEPHERD",
		"WORLD_PIG_GRAZING",
		"WORLD_RABBIT_EATING",
		"WORLD_RABBIT_FLEE",
    }

    local SCENARIO_GROUPS = {
        2017590552, -- LSIA planes
        2141866469, -- Sandy Shores planes
        1409640232, -- Grapeseed planes
        "ng_planes", -- Far up in the skies jets
		"MP_POLICE",
		"BLIMP",
		"ARMY_GUARD",
		"ARMY_HELI",
		"GRAPESEED_PLANES",
		"Grapeseed_Planes",
		"SANDY_PLANES",
		"SCRAP_SECURITY",
    }

    local SUPPRESSED_MODELS = {
        "SHAMAL", -- They spawn on LSIA and try to take off
        "LUXOR", -- They spawn on LSIA and try to take off
        "LUXOR2", -- They spawn on LSIA and try to take off
        "JET", -- They spawn on LSIA and try to take off and land, remove this if you still want em in the skies
        "LAZER", -- They spawn on Zancudo and try to take off
        "TITAN", -- They spawn on Zancudo and try to take off
        "BARRACKS", -- Regularily driving around the Zancudo airport surface
        "BARRACKS2", -- Regularily driving around the Zancudo airport surface
        "CRUSADER", -- Regularily driving around the Zancudo airport surface
        "RHINO", -- Regularily driving around the Zancudo airport surface
        "AIRTUG", -- Regularily spawns on the LSIA airport surface
        "RIPLEY", -- Regularily spawns on the LSIA airport surface
		"BLIMP", -- Regularily spawns on the LSIA airport surface
        "BUZZARD", -- PD ROOF
        "BUZZARD2", -- PD ROOF
        "PARADISE",
        "RENTALBUS",
        "TOURBUS"
    }

    while true do
        for _, v in pairs(SCENARIO_TYPES) do
            SetScenarioTypeEnabled(v, false)
        end

        for _, v in pairs(SCENARIO_GROUPS) do
            SetScenarioGroupEnabled(v, false)
        end

        for _, v in pairs(SUPPRESSED_MODELS) do
            SetVehicleModelIsSuppressed(joaat(v), true)
        end

        Wait(10000)
    end
end)
