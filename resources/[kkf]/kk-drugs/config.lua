cfg = {}

cfg.potProp = "bkr_prop_weed_bucket_01a"
cfg.angle = 0.6
cfg.useSoil = true -- If false then you can plant anywhere
cfg.soil = {
    [2409420175] = 1.0,
    [3008270349] = 0.8,
    [3833216577] = 1.0,
    [223086562] = 1.1,
    [1333033863] = 0.9,
    [4170197704] = 1.0,
    [3594309083] = 0.8,
    [2461440131] = 0.8,
    [1109728704] = 1.5,
    [2352068586] = 1.1,
    [1144315879] = 0.9,
    [581794674] = 1.1,
    --[2128369009] = 0.8,
    [-461750719] = 1.0,
    [-1286696947] = 1.0,
}
cfg.updateinterval = 1 -- every one minute updates consumption and adds health

cfg.wateritem = 'water' -- used to water plant
cfg.fertilizer = 'fertilizer' -- used to fertilize plant
cfg.potitem = 'pot' -- Item used as pot

cfg.addwater = 25 -- so 1 water gives 25%
cfg.addfertilizer = 25 -- so 1 fertilizer gives 25%


cfg.progressbarlocation = 'bottom'
cfg.progressbarlengt = 2000

cfg.plantsList = {
    ['weed_seed'] = {
        label = 'Kanepiseeme',
        item = 'weed_plant', min = 1, max = 3,
        prop = 'prop_weed_02',
        health = 1.34,
        smell = true,
        smell_msg = 'Tunned kanepi lõhna...',
        consumption = {
            water = 1.34,
            fertilizer = 1.34
        }
    },

    ['weed_plant'] = {
        label = 'Kanepitaim',
        item = 'wet_weed', min = 3, max = 7,
        prop = 'prop_weed_01',
        health = 2.67,
        smell = true,
        smell_msg = 'Tunned kanepi lõhna...',
        consumption = {
            water = 2.667,
            fertilizer = 2.667
        }
    },

    ['tobacco_plant'] = {
        label = 'Tubakataim',
        item = 'wet_tobaccoleaf', min = 1, max = 5,
        prop = 'prop_agave_02',
        health = 8,
        consumption = {
            water = 2.5,
            fertilizer = 2.5
        }
    },

    ['coke_plant'] = {
        label = 'Kokataim',
        item = 'coca_leaf', min = 1, max = 5,
        prop = 'h4_prop_bush_cocaplant_01',
        health = 8,
        consumption = {
            water = 2.5,
            fertilizer = 2.5
        }
    }
}


cfg.UseDryer = true -- do you want to use dryer?
cfg.dryerprogressbarlengt = 1500
cfg.dryerTasks = {
    ['dried_weed'] = {label = 'Kuivata kanepiõisi', needs = {'wet_weed'}},
}
cfg.dropToGroundIfFull = true -- If inv is full item will be dropped to ground




-- Client notification function
cfg.ClientNotification = function(message, type)
    TriggerEvent('KKF.UI.ShowNotification', type, message)

    -- lib.notify({
    --     title = 'Growing',
    --     description = message,
    --     type = type or 'inform',
    --     duration = 5000
    -- })
end

-- Server notification function
cfg.ServerNotification = function(source, message, type)
    TriggerClientEvent('KKF.UI.ShowNotification', source, type, message)

    -- -- Add an optional additional notification using another framework, in this case 'ox_lib'
    -- TriggerClientEvent('ox_lib:defaultNotify', source, {
    --     title = 'Growing',
    --     status = type,
    --     duration = 7000,
    --     description = message
    -- })

end
cfg.messages = {
    -- Notifys: 
    max_water = 'See taim ei vaja rohkem vett',
    max_fertilizer = 'Seda taime ei ole vaja rohkem väetada',
    noting_to_grow = 'Teil ei ole siia midagi istutada!',
    too_close = 'Istuta see taim natukene kaugemale...',
    ground_not_flat = 'Maapind ei ole piisavalt sile',
    cant_grow_here = 'Siia ei saa taime istutada.',

    --- Context menus etc..
    target_inspect = 'Hoolda taime',

    delete_header = 'Saagi hävitamine',
    delete_content = 'Kas soovite saagi jäädavalt hävitada?',
    plant_seed = 'Istuta taim',

    harvest_title = 'Korja saak',
    harvest_description = 'Vajuta siia, et korjata saaki.',

    plant_title = 'Istuta taim',
    pant_description = 'Vajuta siia, et istutada taim potti.',

    destroy_pot_title = 'Hävita pott',
    destroy_pot_description = 'Vajuta siia, et hävitada pott.',

    delete_plant_title = 'Hävita saak',
    delete_plant_description = 'Vajuta siia, et hävitada saak.',

    water_pant = 'Kasta taime - ',
    water_pant_description = 'Vajuta siia, et kasta taime.',

    fertilize_plant = 'Väeta taime - ',
    fertilize_plant_description = 'Vajuta siia, et väetada taime.',

    plant_healt = 'Taimehooldus - ',

    dryer = 'Kuivati',

    ---- progress bars
    planting_pot = 'Paigutad potti...',
    destroying_pot = 'Hävitad potti...',
    destroying_plant = 'Hävitad saaki...',
    fertilizing_plant = 'Väetad taime...',
    watering_plant = 'Kastad taime...',
    planting_seed = 'Istutad taime...',
    harvesting_plant = 'Korjad saaki...',
    
    dryer_progress = 'Ootad...',
    dryer_donthave_right_items = 'Teil puuduvad vajalikud esemed kuivatamiseks.',
    dryer_inv_full = 'Teie taskud on liiga täis!',

    -------- Drop
    customdrop = 'Asjad #',

}