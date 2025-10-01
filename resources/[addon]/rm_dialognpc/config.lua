Config = {}

Config.targetScript = "ox_target" -- Target script name (qtarget or qb-target or ox_target or default (for showhelpnotification))

Config.Peds = {}

Config.funcs = { -- npc triggers
    ["sellDrugs"] = function()
        TriggerEvent('kk-factions:client:trySellDrugs')
    end,

    ["buyProperty"] = function()
        TriggerEvent('kk-properties2:client:buyProperty')
    end,

    ["no"] = function()
        
    end
}

Strings = {
    ["talk_npc"] = "Talk with %s"
}