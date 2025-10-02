Dear Customer,

Thank you for purchasing my Plant Growing script! 
This versatile script can be utilized as a farming system,
drug system, or for any other creative purpose you envision. 
You have the freedom to customize it by adding as many plants as you like into the config.lua file, 
adjusting their growth time and other parameters to suit your needs. 
Additionally, it comes with four pre-installed plants for your convenience.

Support:

Encountering any issues or need assistance? Join our Discord server:
https://discord.gg/fkM22XjMns

How to Install:

1. Adding Items:
Insert the following items into ox_inventory's items.lua and include their images in the web/images folder:
-----------------------------------------------------------------------
['hairdryer'] = {
    label = 'Hairdryer',
    weight = 500,
    stack = true,
    description = '',
    consume = 0
},
['pot'] = {
    label = 'Pot',
    weight = 250,
    stack = true,
    consume = 0,
    description = 'A convenient place to plant a seed'
},
['weed_seed'] = {
    label = 'Cannabis Seed',
    weight = 200,
    stack = true,
    close = 0,
    consume = 0,
    description = ''
},
['weed_plant'] = {
    label = 'Cannabis Plant',
    weight = 2000,
    stack = true,
    close = 0,
    consume = 0,
    description = ''
},
['tobacco_plant'] = {
    label = 'Tobacco Plant',
    weight = 2000,
    stack = true,
    close = 0,
    consume = 0,
    description = ''
},
['coke_plant'] = {
    label = 'Coca Plant',
    weight = 2000,
    stack = true,
    close = 0,
    consume = 0,
    description = ''
},
-----------------------------------------------------------------------

2. Adding Code:
Insert the following code into \ox_inventory\modules\items\client.lua:
-----------------------------------------------------------------------
Item('pot', function(data, slot)
    ox_inventory:useItem(data, function(data)
        if data then
            TriggerEvent('atu-drugs:client:tryPlantPot')
        end
    end)
end)

Item('hairdryer', function(data, slot)
    ox_inventory:useItem(data, function(data)
        if data then
            TriggerEvent('atu-drugs:client:hairDrier')
        end
    end)
end)
-----------------------------------------------------------------------


3. Server Configuration:
Ensure to add "ensure atu-drugs" into your server.cfg file.



--- Atu Development, enjoy!


