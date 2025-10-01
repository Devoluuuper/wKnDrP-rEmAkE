
-- Cocaine lockup: 1093.6, -3196.6, -38.99841

exports('GetBikerCocaineObject', function()
    return BikerCocaine
end)

BikerCocaine = {
    interiorId = 247553,
    Ipl = {
        Interior = {
            ipl = "bkr_biker_interior_placement_interior_4_biker_dlc_int_ware03_milo",
            Load = function() EnableIpl(BikerCocaine.Ipl.Interior.ipl, true) end,
            Remove = function() EnableIpl(BikerCocaine.Ipl.Interior.ipl, false) end
        },
    },
    Style = {
        none = "",
        basic = {"set_up", "equipment_basic", "coke_press_basic", "production_basic", "table_equipment"},
        upgrade = {"set_up", "equipment_upgrade", "coke_press_upgrade", "production_upgrade", "table_equipment"},
        Set = function(style, refresh)
            BikerCocaine.Style.Clear(false)
            if (style ~= "") then
                SetIplPropState(BikerCocaine.interiorId, style, true, refresh)
            else
                if (refresh) then RefreshInterior(BikerCocaine.interiorId) end
            end
        end,
        Clear = function(refresh)
            SetIplPropState(BikerCocaine.interiorId, {BikerCocaine.Style.basic, BikerCocaine.Style.upgrade}, false, refresh)
        end
    },
    Security = {
        none = "", basic = "security_low", upgrade = "security_high",
        Set = function(security, refresh)
            BikerCocaine.Security.Clear(false)
            if (security ~= "") then
                SetIplPropState(BikerCocaine.interiorId, security, true, refresh)
            else
                if (refresh) then RefreshInterior(BikerCocaine.interiorId) end
            end
        end,
        Clear = function(refresh)
            SetIplPropState(BikerCocaine.interiorId, {BikerCocaine.Security.basic, BikerCocaine.Security.upgrade}, false, refresh)
        end
    },
    Details = {
        cokeBasic1 = "coke_cut_01",						-- On the basic tables
        cokeBasic2 = "coke_cut_02",						-- On the basic tables
        cokeBasic3 = "coke_cut_03",						-- On the basic tables
        cokeUpgrade1 = "coke_cut_04",					-- On the upgraded tables
        cokeUpgrade2 = "coke_cut_05",					-- On the upgraded tables
        Enable = function (details, state, refresh)
            SetIplPropState(BikerCocaine.interiorId, details, state, refresh)
        end
    },

    LoadDefault = function()
        BikerCocaine.Ipl.Interior.Load()
        BikerCocaine.Style.Set(BikerCocaine.Style.basic)
        BikerCocaine.Security.Set(BikerCocaine.Security.none)
        BikerCocaine.Details.Enable({BikerCocaine.Details.cokeBasic1, BikerCocaine.Details.cokeBasic2, BikerCocaine.Details.cokeBasic3}, true)
        RefreshInterior(BikerCocaine.interiorId)
        local laud1 = CreateObject(GetHashKey("prop_barrel_pile_05"), 1098.683, -3194.144, -40.029231, false, true, true)
        SetEntityHeading(laud1, 270.0)
        FreezeEntityPosition(laud1, true)

        local laud2 = CreateObject(GetHashKey("bkr_prop_weed_table_01b"), 1101.964, -3192.837, -40.02931, false, true, true)
        SetEntityHeading(laud2, 180.0)

        local laud3 = CreateObject(GetHashKey("prop_microwave_1"), 1101.964, -3192.837, -39.18991, false, true, true)
        SetEntityHeading(laud3, 0.0)
        PlaceObjectOnGroundProperly(laud3)
        FreezeEntityPosition(laud3, true)

        --CreateObject(304964818, 1099.28, -3195.737, -40.02931, false, true, true)

        local crusher = CreateObject(GetHashKey("prop_wheelbarrow01a"), 1103.603, -3196.194, -39.96161, false, true, true)
        SetEntityHeading(crusher, 270.913)
        PlaceObjectOnGroundProperly(crusher)
        FreezeEntityPosition(crusher, true)

        local crusher2 = CreateObject(GetHashKey("prop_tool_shovel5"), 1103.603, -3196.194, -39.64959, false, true, true)
        SetEntityHeading(crusher2, 270.913)
        --PlaceObjectOnGroundProperly(crusher2)
        FreezeEntityPosition(crusher2, true)

        --local crusher3 = CreateObject(GetHashKey("prop_tool_rake"), 1103.953, -3197.594, -39.30325, false, true, true)
        --SetEntityHeading(crusher3, 270.913)
        --PlaceObjectOnGroundProperly(crusher3)
        --FreezeEntityPosition(crusher3, true)

        

    end
}

