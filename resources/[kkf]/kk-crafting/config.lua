Config = {}

Config.Sounds = {
    ["burgershot_chopping"] = "chopping",
    ["burgershot_drinks"] = "drinks",
    ["burgershot_grill"] = "grill",
    ["burgershot_ice_cream"] = "icecream",
    ["burgershot_fryer"] = "fryer",

    ["uwucafe_chopping"] = "chopping",
    ["uwucafe_drinks"] = "drinks",
    ["uwucafe_grill"] = "grill",
    ["uwucafe_ice_cream"] = "icecream",
    ["uwucafe_fryer"] = "fryer",

    ["bean_chopping"] = "chopping",
    ["bean_drinks"] = "drinks",
    ["bean_grill"] = "grill",
    ["bean_ice_cream"] = "icecream",
    ["bean_fryer"] = "fryer",
   -- ["bean_drinks_new"] = "drinksnew"
}


Config.Items = {
    {
        item = "brown_fabric_piece",
        amount = 4,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["brown_fabric"] = 1
        }
    },
    {
        item = "green_fabric_piece",
        amount = 4,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["green_fabric"] = 1
        }
    },
    {
        item = "red_fabric_piece",
        amount = 4,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["red_fabric"] = 1
        }
    },
    {
        item = "beige_fabric_piece",
        amount = 4,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["beige_fabric"] = 1
        }
    },
    {
        item = "blue_fabric_piece",
        amount = 4,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["blue_fabric"] = 1
        }
    },
    {
        item = "black_fabric_piece",
        amount = 4,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["black_fabric"] = 1
        }
    },
    {
        item = "orange_fabric_piece",
        amount = 4,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["orange_fabric"] = 1
        }
    },
    {
        item = "green_fabric",
        amount = 1,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["green_fabric_color"] = 1,
            ["cotton"] = 1
        }
    },
    {
        item = "red_fabric",
        amount = 1,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["red_fabric_color"] = 1,
            ["cotton"] = 1
        }
    },
    {
        item = "beige_fabric",
        amount = 2,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["beige_fabric_color"] = 1,
            ["cotton"] = 1
        }
    },
    {
        item = "blue_fabric",
        amount = 1,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["blue_fabric_color"] = 1,
            ["cotton"] = 1
        }
    },
    {
        item = "black_fabric",
        amount = 1,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["black_fabric_color"] = 1,
            ["cotton"] = 1
        }
    },
    {
        item = "orange_fabric",
        amount = 1,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["orange_fabric_color"] = 1,
            ["cotton"] = 1
        }
    },
    {
        item = "brown_fabric",
        amount = 1,
        tables = {"fabric_cut"},
        progressTime = 11000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["brown_fabric_color"] = 1,
            ["cotton"] = 1
        }
    },
    {
        item = "boxers",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.1,
            lvlRequired = 1
        },
        needs = {
            ["beige_fabric_piece"] = 1,
            ["beige_thread"] = 1
        }
    },
    {
        item = "strew_hat",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.2,
            lvlRequired = 2
        },
        needs = {
            ["beige_fabric_piece"] = 1,
            ["beige_thread"] = 1
        }
    },
    {
        item = "gray_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.21,
            lvlRequired = 3
        },
        needs = {
            ["beige_fabric_piece"] = 1,
            ["beige_thread"] = 1
        }
    },
    {
        item = "white_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.22,
            lvlRequired = 6
        },
        needs = {
            ["beige_fabric_piece"] = 1,
            ["beige_thread"] = 1
        }
    },
    {
        item = "yellow_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.23,
            lvlRequired = 8
        },
        needs = {
            ["orange_fabric_piece"] = 1,
            ["orange_thread"] = 1
        }
    },
    {
        item = "brown_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.24,
            lvlRequired = 10
        },
        needs = {
            ["orange_fabric_piece"] = 1,
            ["brown_thread"] = 1
        }
    },
    {
        item = "blue_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.25,
            lvlRequired = 12
        },
        needs = {
            ["blue_fabric_piece"] = 1,
            ["blue_thread"] = 1
        }
    },
    {
        item = "purple_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.26,
            lvlRequired = 15
        },
        needs = {
            ["blue_fabric_piece"] = 1,
            ["blue_thread"] = 1
        }
    },
    {
        item = "orange_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.27,
            lvlRequired = 18
        },
        needs = {
            ["orange_fabric_piece"] = 1,
            ["brown_thread"] = 1
        }
    },
    {
        item = "black_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.28,
            lvlRequired = 21
        },
        needs = {
            ["black_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "necktie",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.4,
            lvlRequired = 24
        },
        needs = {
            ["black_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "socks",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.41,
            lvlRequired = 28
        },
        needs = {
            ["black_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "yellow_dress",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.42,
            lvlRequired = 32
        },
        needs = {
            ["orange_fabric_piece"] = 1,
            ["orange_thread"] = 1
        }
    },
    {
        item = "green_ironed_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.8,
            lvlRequired = 36
        },
        needs = {
            ["green_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "red_ironed_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.81,
            lvlRequired = 44
        },
        needs = {
            ["red_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "brown_ironed_shirt_1",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.82,
            lvlRequired = 52
        },
        needs = {
            ["brown_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "brown_ironed_shirt_2",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.83,
            lvlRequired = 60
        },
        needs = {
            ["brown_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "brown-beige_ironed_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.84,
            lvlRequired = 68
        },
        needs = {
            ["brown_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "orange_ironed_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.85,
            lvlRequired = 77
        },
        needs = {
            ["orange_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "orange-beige_ironed_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.86,
            lvlRequired = 86
        },
        needs = {
            ["orange_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "beige_ironed_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.87,
            lvlRequired = 95
        },
        needs = {
            ["beige_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "blue_ironed_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.88,
            lvlRequired = 104
        },
        needs = {
            ["blue_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "blue-green_ironed_shirt",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.89,
            lvlRequired = 113
        },
        needs = {
            ["blue_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "bra",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.9,
            lvlRequired = 122
        },
        needs = {
            ["blue_fabric_piece"] = 1,
            ["blue_thread"] = 1
        }
    },
    {
        item = "w_underwear",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.91,
            lvlRequired = 131
        },
        needs = {
            ["blue_fabric_piece"] = 1,
            ["blue_thread"] = 1
        }
    },
    {
        item = "coat",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 1,
            lvlRequired = 140
        },
        needs = {
            ["black_fabric_piece"] = 1,
            ["black_thread"] = 1
        }
    },
    {
        item = "bandage",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 0.28,
            lvlRequired = 20
        },
        needs = {
            ["black_fabric_piece"] = 1,
            ["green_thread"] = 1
        }
    },
    {
        item = "camo_vest_2",
        amount = 1,
        tables = {"sewing"},
        progressTime = 23000, -- (ms)
        skill = {
            name = "sewing",
            progress = 1,
            lvlRequired = 160
        },
        needs = {
            ["beige_fabric_piece"] = 5,
            ["black_fabric_piece"] = 5,
            ["orange_fabric_piece"] = 5,
            ["green_fabric_piece"] = 5,
            ["black_thread"] = 3,
            ['armor_plate'] = 2
        }
    },
    -------------------------------------
    {
        item = "a_c_boar_carcass",
        amount = 1,
        tables = {"hanging"},
        progressTime = 90000, -- (ms)
        needs = {
            ["a_c_boar"] = 1
        }
    },
    -- {
    -- 	item = 'a_c_cow_carcass',
    -- 	amount = 1,
    --     tables = {'hanging'},
    --     progressTime = 90000, -- (ms)

    --     needs = {
    --         ['a_c_cow'] = 1,
    --     }
    -- },

    {
        item = "a_c_coyote_carcass",
        amount = 1,
        tables = {"hanging"},
        progressTime = 90000, -- (ms)
        needs = {
            ["a_c_coyote"] = 1
        }
    },
    {
        item = "a_c_deer_carcass",
        amount = 1,
        tables = {"hanging"},
        progressTime = 90000, -- (ms)
        needs = {
            ["a_c_deer"] = 1
        }
    },
    {
        item = "a_c_mtlion_carcass",
        amount = 1,
        tables = {"hanging"},
        progressTime = 90000, -- (ms)
        needs = {
            ["a_c_mtlion"] = 1
        }
    },
    {
        item = "a_c_rabbit_carcass",
        amount = 1,
        tables = {"hanging"},
        progressTime = 90000, -- (ms)
        needs = {
            ["a_c_rabbit_01"] = 1
        }
    },
    {
        item = "a_c_hen_carcass",
        amount = 1,
        tables = {"hanging"},
        progressTime = 90000, -- (ms)
        needs = {
            ["a_c_hen"] = 1
        }
    },
    {
        item = "a_c_steak",
        amount = 13,
        tables = {"cutting"},
        progressTime = 60000, -- (ms)
        needs = {
            ["a_c_boar_carcass"] = 1
        }
    },
    -- {
    -- 	item = 'a_c_steak',
    -- 	amount = 42,
    --     tables = {'cutting'},
    --     progressTime = 60000, -- (ms)

    --     needs = {
    --         ['a_c_cow_carcass'] = 1,
    --     }
    -- },

    {
        item = "a_c_steak",
        amount = 8,
        tables = {"cutting"},
        progressTime = 60000, -- (ms)
        needs = {
            ["a_c_coyote_carcass"] = 1
        }
    },
    {
        item = "a_c_steak",
        amount = 36,
        tables = {"cutting"},
        progressTime = 60000, -- (ms)
        needs = {
            ["a_c_deer_carcass"] = 1
        }
    },
    {
        item = "a_c_steak",
        amount = 9,
        tables = {"cutting"},
        progressTime = 60000, -- (ms)
        needs = {
            ["a_c_mtlion_carcass"] = 1
        }
    },
    {
        item = "a_c_steak",
        amount = 5,
        tables = {"cutting"},
        progressTime = 60000, -- (ms)
        needs = {
            ["a_c_rabbit_carcass"] = 1
        }
    },
    {
        item = "a_c_hen_filee",
        amount = 2,
        tables = {"cutting"},
        progressTime = 60000, -- (ms)
        needs = {
            ["a_c_hen_carcass"] = 1
        }
    },


    ------ BurgerShot
    {
        item = "sprunk_cup",
        amount = 1,
        tables = {"burgershot_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["sprunk_syrup"] = 1
        }
    },
    {
        item = "cola_cup",
        amount = 1,
        tables = {"burgershot_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["cola_syrup"] = 1
        }
    },
    {
        item = "orango_cup",
        amount = 1,
        tables = {"burgershot_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["orango_syrup"] = 1
        }
    },
    {
        item = "cola_light_cup",
        amount = 1,
        tables = {"burgershot_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["cola_syrup"] = 1
        }
    },
    {
        item = "orango_icecream",
        amount = 1,
        tables = {"burgershot_ice_cream"},
        progressTime = 7000, -- (ms)
        needs = {
            ["icecream"] = 1,
            ["orango_syrup"] = 1
        }
    },
    {
        item = "meteorite_icecream",
        amount = 1,
        tables = {"burgershot_ice_cream"},
        progressTime = 7000, -- (ms)
        needs = {
            ["icecream"] = 1,
            ["chocolate_syrup"] = 1
        }
    },
    {
        item = "beef_patty",
        amount = 6,
        tables = {"burgershot_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["minced_beef"] = 1
        }
    },
    {
        item = "tomato_slice",
        amount = 6,
        tables = {"burgershot_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["tomato"] = 1
        }
    },
    {
        item = "chopped_onion",
        amount = 6,
        tables = {"burgershot_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["onion"] = 1
        }
    },
    {
        item = "salad",
        amount = 12,
        tables = {"burgershot_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["cabbage"] = 1
        }
    },
    {
        item = "bun_slice",
        amount = 2,
        tables = {"burgershot_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["burger_bun"] = 1
        }
    },
    {
        item = "pickle_slice",
        amount = 18,
        tables = {"burgershot_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["pickle"] = 1
        }
    },
    {
        item = "bacon_slice",
        amount = 12,
        tables = {"burgershot_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bacon"] = 1
        }
    },
    {
        item = "french_fries",
        amount = 10,
        tables = {"burgershot_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["potato"] = 1
        }
    },
    {
        item = "sliced_chicken_fillet",
        amount = 4,
        tables = {"burgershot_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["chicken_fillet"] = 1
        }
    },
    {
        item = "fried_egg",
        amount = 1,
        tables = {"burgershot_grill"},
        progressTime = 5000, -- (ms)
        needs = {
            ["egg"] = 1
        }
    },
    {
        item = "grilled_chicken_fillet",
        amount = 1,
        tables = {"burgershot_grill"},
        progressTime = 5000, -- (ms)
        needs = {
            ["sliced_chicken_fillet"] = 1
        }
    },
    {
        item = "grilled_beef_patty",
        amount = 1,
        tables = {"burgershot_grill"},
        progressTime = 5000, -- (ms)
        needs = {
            ["beef_patty"] = 1
        }
    },
    {
        item = "grilled_bacon_slice",
        amount = 1,
        tables = {"burgershot_grill"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bacon_slice"] = 1
        }
    },
    {
        item = "fried_french_fries",
        amount = 1,
        tables = {"burgershot_fryer"},
        progressTime = 5000, -- (ms)
        needs = {
            ["french_fries"] = 1
        }
    },
    {
        item = "double_shot",
        amount = 1,
        tables = {"burgershot_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bun_slice"] = 3,
            ["grilled_beef_patty"] = 2,
            ["salad"] = 2,
            ["fried_egg"] = 2,
            ["sauce"] = 2,
            ["cheese"] = 2
        }
    },
    {
        item = "glorious",
        amount = 1,
        tables = {"burgershot_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bun_slice"] = 2,
            ["grilled_beef_patty"] = 2,
            ["tomato_slice"] = 1,
            ["salad"] = 2,
            ["sauce"] = 1,
            ["cheese"] = 2
        }
    },
    {
        item = "prickly",
        amount = 1,
        tables = {"burgershot_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bun_slice"] = 2,
            ["grilled_beef_patty"] = 1,
            ["tomato_slice"] = 1,
            ["salad"] = 2,
            ["spicy_sauce"] = 2,
            ["cheese"] = 1
        }
    },
    {
        item = "heart_stopper",
        amount = 1,
        tables = {"burgershot_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bun_slice"] = 2,
            ["grilled_beef_patty"] = 2,
            ["tomato_slice"] = 1,
            ["salad"] = 1,
            ["spicy_sauce"] = 3,
            ["cheese"] = 2
        }
    },
    {
        item = "simply",
        amount = 1,
        tables = {"burgershot_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bun_slice"] = 2,
            ["grilled_beef_patty"] = 1,
            ["grilled_bacon_slice"] = 2,
            ["fried_egg"] = 1,
            ["pickle_slice"] = 2,
            ["cheese"] = 1
        }
    },
    {
        item = "bleeder",
        amount = 1,
        tables = {"burgershot_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bun_slice"] = 2,
            ["grilled_beef_patty"] = 2,
            ["chopped_onion"] = 2,
            ["fried_egg"] = 1,
            ["salad"] = 2,
            ["cheese"] = 1,
            ["tomato_slice"] = 1
        }
    },
    {
        item = "goat_cheese_wrap",
        amount = 1,
        tables = {"burgershot_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["grilled_beef_patty"] = 2,
            ["tortilla"] = 1,
            ["tomato_slice"] = 1,
            ["salad"] = 2,
            ["chopped_onion"] = 1
        }
    },
    {
        item = "chicken_wrap",
        amount = 1,
        tables = {"burgershot_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["grilled_chicken_fillet"] = 2,
            ["tortilla"] = 1,
            ["tomato_slice"] = 1,
            ["salad"] = 2,
            ["chopped_onion"] = 1
        }
    },
    {
        item = "mexican_taco",
        amount = 1,
        tables = {"burgershot_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["grilled_chicken_fillet"] = 2,
            ["taco"] = 1,
            ["tomato_slice"] = 1,
            ["salad"] = 2,
            ["spicy_sauce"] = 1
        }
    },
    {
        item = "spicy_sauce",
        amount = 1,
        tables = {"burgershot_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["jalapeno"] = 1,
            ["sauce"] = 1
        }
    },

    --- UwuCafe
    {
        item = "sake",
        amount = 1,
        tables = {"uwucafe_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bottle"] = 1,
        }
        
    },
    {
        item = "ploomivein",
        amount = 1,
        tables = {"uwucafe_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bottle"] = 1,
        }
    },
    {
        item = "matcha_tea",
        amount = 1,
        tables = {"uwucafe_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
        }
    },
    {
        item = "mahl",
        amount = 1,
        tables = {"uwucafe_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["syrup"] = 1,
            ["bs_cup"] = 1
        }
    },
    {
        item = "sliced_chicken_fillet",
        amount = 4,
        tables = {"uwucafe_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["chicken_fillet"] = 1,
        }
    },
    {
        item = "chopped_onion",
        amount = 6,
        tables = {"uwucafe_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["onion"] = 1,
        }
    },
    {
        item = "sliced_fish",
        amount = 3,
        tables = {"uwucafe_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["fish"] = 1,
        }
    },
    {
        item = "sliced_beef",
        amount = 6,
        tables = {"uwucafe_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["beef"] = 1,
        }
    },
    {
        item = "salad",
        amount = 12,
        tables = {"uwucafe_chopping"},
        progressTime = 5000, -- (ms)
        needs = {
            ["cabbage"] = 1,
        }
    },
    {
        item = "grilled_chicken_fillet",
        amount = 1,
        tables = {"uwucafe_grill"},
        progressTime = 5000, -- (ms)
        needs = {
            ["sliced_chicken_fillet"] = 1,
        }
    },
    {
        item = "grilled_sliced_beef",
        amount = 1,
        tables = {"uwucafe_grill"},
        progressTime = 5000, -- (ms)
        needs = {
            ["sliced_beef"] = 1,
        }
    },
    {
        item = "yakitori",
        amount = 1,
        tables = {"uwucafe_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["grilled_chicken_fillet"] = 3,
            ["sauce"] = 1,
            ["chopped_onion"] = 2
        }
    },
    {
        item = "sashimi",
        amount = 1,
        tables = {"uwucafe_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["grilled_sliced_beef"] = 2,
            ["sliced_beef"] = 2,
            ["sliced_fish"] = 2
        }
    },
    {
        item = "ramen",
        amount = 1,
        tables = {"uwucafe_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["noodles"] = 1,
            ["chopped_onion"] = 2,
            ["grilled_chicken_fillet"] = 2,
            ["sauce"] = 1
        }
    },
    {
        item = "miso_soup",
        amount = 1,
        tables = {"uwucafe_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dashi"] = 1,
            ["miso"] = 1,
            ["chopped_onion"] = 4
        }
    },
    {
        item = "okonomiyaki",
        amount = 1,
        tables = {"uwucafe_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["salad"] = 6,
            ["sliced_fish"] = 2,
            ["sauce"] = 1
        }
    },
    {
        item = "gyoza",
        amount = 1,
        tables = {"uwucafe_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dough"] = 2,
            ["minced_beef"] = 2,
            ["chopped_onion"] = 1
        }
    },
    {
        item = "curry_rice",
        amount = 1,
        tables = {"uwucafe_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["grilled_chicken_fillet"] = 3,
            ["sauce"] = 1,
            ["rice"] = 2
        }
    },
    {
        item = "tempura",
        amount = 1,
        tables = {"uwucafe_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["sliced_fish"] = 2,
            ["dough"] = 2,
            ["jalapeno"] = 2
        }
    },
    ----- BeanMachine
    {
        item = "ice_tea",
        amount = 1,
        tables = {"bean_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
        }
    },
    {
        item = "ice_coffee",
        amount = 1,
        tables = {"bean_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["coffee_bean"] = 1,
        }
    },
    {
        item = "caramel_cocktail",
        amount = 1,
        tables = {"bean_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["caramel_syrup"] = 1,
        }
    },
    {
        item = "chocolate_cocktail",
        amount = 1,
        tables = {"bean_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["chocolate_syrup"] = 1,
        }
    },
    {
        item = "vanilla_cocktail",
        amount = 1,
        tables = {"bean_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["vanilla_syrup"] = 1,
        }
    },
    {
        item = "peppermint_chocolate_cocktail",
        amount = 1,
        tables = {"bean_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["peppermint"] = 1,
            ["chocolate_syrup"] = 1,
        }
    },
    {
        item = "mango_smoothie",
        amount = 1,
        tables = {"bean_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["mango"] = 1,
        }
    },
    {
        item = "banana_smoothie",
        amount = 1,
        tables = {"bean_drinks"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["banana"] = 1,
        }
    },
    {
        item = "filter_coffee",
        amount = 1,
        tables = {"bean_drinks_new"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["coffee_bean"] = 1,
        }
    },
    {
        item = "cappuccino",
        amount = 1,
        tables = {"bean_drinks_new"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["coffee_bean"] = 1,
        }
    },
    {
        item = "americano",
        amount = 1,
        tables = {"bean_drinks_new"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["coffee_bean"] = 1,
        }
    },
    {
        item = "espresso",
        amount = 1,
        tables = {"bean_drinks_new"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["coffee_bean"] = 1,
        }
    },
    {
        item = "latte",
        amount = 1,
        tables = {"bean_drinks_new"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["coffee_bean"] = 1,
        }
    },
    {
        item = "caramel_latte",
        amount = 1,
        tables = {"bean_drinks_new"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["coffee_bean"] = 1,
            ["caramel_syrup"] = 1,
        }
    },
    {
        item = "vanilla_latte",
        amount = 1,
        tables = {"bean_drinks_new"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["coffee_bean"] = 1,
            ["vanilla_syrup"] = 1,
        }
    },
    {
        item = "hot_chocolate",
        amount = 1,
        tables = {"bean_drinks_new"},
        progressTime = 5000, -- (ms)
        needs = {
            ["bs_cup"] = 1,
            ["coffee_bean"] = 1,
            ["chocolate_syrup"] = 1,
        }
    },
    {
        item = "brownie",
        amount = 1,
        tables = {"bean_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dough"] = 1,
            ["chocolate_syrup"] = 1,
        }
    },
    {
        item = "cheescake",
        amount = 1,
        tables = {"bean_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dough"] = 1,
            ["cheese"] = 1,
        }
    },
    {
        item = "gingerbreads",
        amount = 1,
        tables = {"bean_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dough"] = 1,
            ["peppermint"] = 1,
        }
    },
    {
        item = "cheese_sandwich",
        amount = 1,
        tables = {"bean_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dough"] = 1,
            ["cheese"] = 1,
        }
    },
    {
        item = "waffles",
        amount = 1,
        tables = {"bean_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dough"] = 1,
            ["caramel_syrup"] = 1,
        }
    },
    {
        item = "caramel_donut",
        amount = 1,
        tables = {"bean_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dough"] = 1,
        }
    },
    {
        item = "red_donut",
        amount = 1,
        tables = {"bean_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dough"] = 1,
        }
    },
    {
        item = "pink_donut",
        amount = 1,
        tables = {"bean_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dough"] = 1,
        }
    },
    {
        item = "blue_donut",
        amount = 1,
        tables = {"bean_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dough"] = 1,
        }
    },
    {
        item = "white_donut",
        amount = 1,
        tables = {"bean_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dough"] = 1,
        }
    },
    {
        item = "donut",
        amount = 1,
        tables = {"bean_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dough"] = 1,
        }
    },
    {
        item = "blue_pink_donut",
        amount = 1,
        tables = {"bean_put_together"},
        progressTime = 5000, -- (ms)
        needs = {
            ["dough"] = 1,
        }
    },


    --- Mining
    {
        item = "bronze_bar",
        amount = 1,
        tables = {"mining"},
        progressTime = 5000, -- (ms)
        needs = {
            ["copper_ore"] = 1,
            ["tin_ore"] = 1
        }
    },
    {
        item = "iron_bar",
        amount = 1,
        tables = {"mining"},
        progressTime = 5000, -- (ms)
        needs = {
            ["iron_ore"] = 2,
        }
    },
    {
        item = "silver_bar",
        amount = 1,
        tables = {"mining"},
        progressTime = 5000, -- (ms)
        needs = {
            ["silver_ore"] = 1,
        }
    },
    {
        item = "steel_bar",
        amount = 1,
        tables = {"mining"},
        progressTime = 5000, -- (ms)
        needs = {
            ["iron_ore"] = 1,
            ["coal"] = 1
        }
    },
    {
        item = "gold_bar",
        amount = 1,
        tables = {"mining"},
        progressTime = 5000, -- (ms)
        needs = {
            ["gold_ore"] = 1,
        }
    },

    
    ---- Omastamine -----

    --- Kõik omastatud lauad (röövid / kuulid jne...)
    {
        item = "drill",
        amount = 1,
        tables = {"ctf_a", "ctf_b", "ctf_c"},
        progressTime = 320000, -- (ms)

        skill = {
            name = "crafting",
            progress = 4,
            lvlRequired = 0
        },
        needs = {
            ["steel"] = 2,
            ["iron"] = 2,
        },
    },

    {
        item = "hacking_tablet",
        amount = 1,
        tables = {"ctf_a", "ctf_b", "ctf_c"},
        progressTime = 30000, -- (ms)

        skill = {
            name = "crafting",
            progress = 2,
            lvlRequired = 0
        },
        needs = {
            ["steel"] = 2,
            ["copper"] = 2,
            ["iron"] = 1
        },
    },

    {
        item = "c4_bank",
        amount = 1,
        tables = {"ctf_a", "ctf_b", "ctf_c"},
        progressTime = 320000, -- (ms)

        skill = {
            name = "crafting",
            progress = 5,
            lvlRequired = 0
        },
        needs = {
            ["steel"] = 2,
            ["ammo-pistol"] = 2,
            ["proccesedoil"] = 6
        }
    },

    {
        item = "ammo-pistol",
        amount = 1,
        tables = {"ctf_a", "ctf_b", "ctf_c"},
        progressTime = 1000, -- (ms)

        skill = {
            name = "crafting",
            progress = 0,
            lvlRequired = 0
        },
        needs = {
            ["copper"] =1,
            ["iron"] = 1,
        }
    },

    {
        item = "ammo-rifle",
        amount = 1,
        tables = {"ctf_a", "ctf_b", "ctf_c"},
        progressTime = 1000, -- (ms)

        skill = {
            name = "crafting",
            progress = 0,
            lvlRequired = 0
        },
        needs = {
            ["copper"] =1,
            ["iron"] = 1,
        }
    },

    {
        item = "ammo-shotgun",
        amount = 1,
        tables = {"ctf_a", "ctf_b", "ctf_c"},
        progressTime = 1000, -- (ms)

        skill = {
            name = "crafting",
            progress = 0,
            lvlRequired = 0
        },
        needs = {
            ["copper"] =1,
            ["iron"] = 1,
        }
    },


    {
        item = "WEAPON_KNUCKLE",
        amount = 1,
        tables = {"ctf_a", "ctf_b", "ctf_c"},
        progressTime = 4000, -- (ms)

        skill = {
            name = "crafting",
            progress = 5,
            lvlRequired = 0
        },
        needs = {
            ["iron"] = 10
        }
    },

    {
        item = "WEAPON_BAT",
        amount = 1,
        tables = {"ctf_a", "ctf_b", "ctf_c"},
        progressTime = 4000, -- (ms)

        skill = {
            name = "crafting",
            progress = 5,
            lvlRequired = 0
        },
        needs = {
            ["iron"] = 10
        }
    },
    


    ------------------
    -- A (relvad) ---
    ------------------
    {
        item = "WEAPON_PISTOL50",
        amount = 1,
        tables = {"ctf_a"},
        progressTime = 120000, -- (ms)

        skill = {
            name = "crafting",
            progress = 10,
            lvlRequired = 1
        },
        needs = {
            ["steel"] = 4,
            ["iron"] = 2,
            ["proccesedoil"] = 6
        }
    },

    {
        item = "WEAPON_HEAVYPISTOL",
        amount = 1,
        tables = {"ctf_a"},
        progressTime = 130000, -- (ms)

        skill = {
            name = "crafting",
            progress = 10,
            lvlRequired = 1
        },
        needs = {
            ["steel"] = 4,
            ["iron"] = 2,
            ["proccesedoil"] = 6
        }
    },

    {
        item = "WEAPON_ASSAULTRIFLE",
        amount = 1,
        tables = {"ctf_a"},
        progressTime = 150000, -- (ms)

        skill = {
            name = "crafting",
            progress = 10,
            lvlRequired = 4
        },
        needs = {
            ["small_spring"] = 1,
            ["small_trigger"] = 1,
            ["safety"] = 1,
            ["grip"] = 1,
            ["magazin"] = 1,
            ["cableties"] = 3,
            ["aluminium"] = 7
        }
    },

    {
        item = "WEAPON_MICROSMG",
        amount = 1,
        tables = {"ctf_a"},
        progressTime = 80000, -- (ms)

        skill = {
            name = "crafting",
            progress = 10,
            lvlRequired = 3
        },
        needs = {
            ["small_spring"] = 1,
            ["small_trigger"] = 1,
            ["safety"] = 1,
            ["grip"] = 1,
            ["magazin"] = 1,
            ["cableties"] = 3,
            ["aluminium"] = 7
        }
    },

    ---- B (narko)

    

    ---- C (relv)
    {
        item = "WEAPON_PUMPSHOTGUN",
        amount = 1,
        tables = {"ctf_c"},
        progressTime = 150000, -- (ms)

        skill = {
            name = "crafting",
            progress = 10,
            lvlRequired = 5
        },
        needs = {
            ["steel"] = 4,
            ["iron"] = 3,
            ["proccesedoil"] = 7
        }
    },

    {
        item = "WEAPON_HEAVYPISTOL",
        amount = 1,
        tables = {"ctf_b"},
        progressTime = 130000, -- (ms)

        skill = {
            name = "crafting",
            progress = 10,
            lvlRequired = 1
        },
        needs = {
            ["steel"] = 4,
            ["iron"] = 2,
            ["proccesedoil"] = 6
        }
    },

    {
        item = "WEAPON_ASSAULTRIFLE",
        amount = 1,
        tables = {"ctf_b"},
        progressTime = 150000, -- (ms)

        skill = {
            name = "crafting",
            progress = 10,
            lvlRequired = 4
        },
        needs = {
            ["small_spring"] = 1,
            ["small_trigger"] = 1,
            ["safety"] = 1,
            ["grip"] = 1,
            ["magazin"] = 1,
            ["cableties"] = 3,
            ["aluminium"] = 7
        }
    },

    ---- End of omastamine



    -- kk-mechanic
    --S kategooria
    {
        item = "fuel_injector_s",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["fuel_injector_s_box"] = 1,
        }
    },
    {
        item = "radiator_s",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["radiator_s_box"] = 1,
        }
    },
    {
        item = "axle_s",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["axle_s_box"] = 1,
        }
    },
    {
        item = "transmission_s",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["transmission_s_box"] = 1,
        }
    },
    {
        item = "electronics_s",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["electronics_s_box"] = 1,
        }
    },
    {
        item = "brakes_s",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["brakes_s_box"] = 1,
        }
    },
    {
        item = "clutch_s",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["clutch_s_box"] = 1,
        }
    },
    {
        item = "tire_s",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["tire_s_box"] = 1,
        }
    },
    
    -- A kategooria
    {
        item = "fuel_injector_a",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["fuel_injector_a_box"] = 1,
        }
    },
    {
        item = "radiator_a",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["radiator_a_box"] = 1,
        }
    },
    {
        item = "axle_a",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["axle_a_box"] = 1,
        }
    },
    {
        item = "transmission_a",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["transmission_a_box"] = 1,
        }
    },
    {
        item = "electronics_a",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["electronics_a_box"] = 1,
        }
    },
    {
        item = "brakes_a",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["brakes_a_box"] = 1,
        }
    },
    {
        item = "clutch_a",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["clutch_a_box"] = 1,
        }
    },
    {
        item = "tire_a",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["tire_a_box"] = 1,
        }
    },
    
    -- B kategooria
    {
        item = "fuel_injector_b",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["fuel_injector_b_box"] = 1,
        }
    },
    {
        item = "radiator_b",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["radiator_b_box"] = 1,
        }
    },
    {
        item = "axle_b",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["axle_b_box"] = 1,
        }
    },
    {
        item = "transmission_b",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["transmission_b_box"] = 1,
        }
    },
    {
        item = "electronics_b",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["electronics_b_box"] = 1,
        }
    },
    {
        item = "brakes_b",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["brakes_b_box"] = 1,
        }
    },
    {
        item = "clutch_b",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["clutch_b_box"] = 1,
        }
    },
    {
        item = "tire_b",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["tire_b_box"] = 1,
        }
    },
    
    -- C kategooria
    {
        item = "fuel_injector_c",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["fuel_injector_c_box"] = 1,
        }
    },
    {
        item = "radiator_c",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["radiator_c_box"] = 1,
        }
    },
    {
        item = "axle_c",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["axle_c_box"] = 1,
        }
    },
    {
        item = "transmission_c",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["transmission_c_box"] = 1,
        }
    },
    {
        item = "electronics_c",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["electronics_c_box"] = 1,
        }
    },
    {
        item = "brakes_c",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["brakes_c_box"] = 1,
        }
    },
    {
        item = "clutch_c",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["clutch_c_box"] = 1,
        }
    },
    {
        item = "tire_c",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["tire_c_box"] = 1,
        }
    },
    
    -- D kategooria
    {
        item = "fuel_injector_d",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["fuel_injector_d_box"] = 1,
        }
    },
    {
        item = "radiator_d",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["radiator_d_box"] = 1,
        }
    },
    {
        item = "axle_d",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["axle_d_box"] = 1,
        }
    },
    {
        item = "transmission_d",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["transmission_d_box"] = 1,
        }
    },
    {
        item = "electronics_d",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["electronics_d_box"] = 1,
        }
    },
    {
        item = "brakes_d",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["brakes_d_box"] = 1,
        }
    },
    {
        item = "clutch_d",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["clutch_d_box"] = 1,
        }
    },
    {
        item = "tire_d",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["tire_d_box"] = 1,
        }
    },
    
    -- M kategooria
    {
        item = "fuel_injector_m",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["fuel_injector_m_box"] = 1,
        }
    },
    {
        item = "radiator_m",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["radiator_m_box"] = 1,
        }
    },
    {
        item = "axle_m",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["axle_m_box"] = 1,
        }
    },
    {
        item = "transmission_m",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["transmission_m_box"] = 1,
        }
    },
    {
        item = "electronics_m",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["electronics_m_box"] = 1,
        }
    },
    {
        item = "brakes_m",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["brakes_m_box"] = 1,
        }
    },
    {
        item = "clutch_m",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["clutch_m_box"] = 1,
        }
    },
    {
        item = "tire_m",
        amount = 10,
        tables = {"mechanic_unboxer"},
        progressTime = 5000, -- (ms)
        skill = {
            name = "crafting",
            progress = 0.05,
            lvlRequired = 1
        },
        needs = {
            ["tire_m_box"] = 1,
        }
    },

        --------------
        {
            item = "a_c_boar_carcass",
            amount = 1,
            tables = {"hanging"},
            progressTime = 90000, -- (ms)
            needs = {
                ["a_c_boar"] = 1
            }
        },
        -- {
        -- 	item = 'a_c_cow_carcass',
        -- 	amount = 1,
        --     tables = {'hanging'},
        --     progressTime = 90000, -- (ms)
    
        --     needs = {
        --         ['a_c_cow'] = 1,
        --     }
        -- },
    
        {
            item = "a_c_coyote_carcass",
            amount = 1,
            tables = {"hanging"},
            progressTime = 90000, -- (ms)
            needs = {
                ["a_c_coyote"] = 1
            }
        },
        {
            item = "a_c_deer_carcass",
            amount = 1,
            tables = {"hanging"},
            progressTime = 90000, -- (ms)
            needs = {
                ["a_c_deer"] = 1
            }
        },
        {
            item = "a_c_mtlion_carcass",
            amount = 1,
            tables = {"hanging"},
            progressTime = 90000, -- (ms)
            needs = {
                ["a_c_mtlion"] = 1
            }
        },
        {
            item = "a_c_rabbit_carcass",
            amount = 1,
            tables = {"hanging"},
            progressTime = 90000, -- (ms)
            needs = {
                ["a_c_rabbit_01"] = 1
            }
        },
        {
            item = "a_c_hen_carcass",
            amount = 1,
            tables = {"hanging"},
            progressTime = 90000, -- (ms)
            needs = {
                ["a_c_hen"] = 1
            }
        },
        {
            item = "a_c_steak",
            amount = 13,
            tables = {"cutting"},
            progressTime = 60000, -- (ms)
            needs = {
                ["a_c_boar_carcass"] = 1
            }
        },
        -- {
        -- 	item = 'a_c_steak',
        -- 	amount = 42,
        --     tables = {'cutting'},
        --     progressTime = 60000, -- (ms)
    
        --     needs = {
        --         ['a_c_cow_carcass'] = 1,
        --     }
        -- },
    
        {
            item = "a_c_steak",
            amount = 8,
            tables = {"cutting"},
            progressTime = 60000, -- (ms)
            needs = {
                ["a_c_coyote_carcass"] = 1
            }
        },
        {
            item = "a_c_steak",
            amount = 36,
            tables = {"cutting"},
            progressTime = 60000, -- (ms)
            needs = {
                ["a_c_deer_carcass"] = 1
            }
        },
        {
            item = "a_c_steak",
            amount = 9,
            tables = {"cutting"},
            progressTime = 60000, -- (ms)
            needs = {
                ["a_c_mtlion_carcass"] = 1
            }
        },
        {
            item = "a_c_steak",
            amount = 5,
            tables = {"cutting"},
            progressTime = 60000, -- (ms)
            needs = {
                ["a_c_rabbit_carcass"] = 1
            }
        },
        {
            item = "a_c_hen_filee",
            amount = 2,
            tables = {"cutting"},
            progressTime = 60000, -- (ms)
            needs = {
                ["a_c_hen_carcass"] = 1
            }
        },
        ---------------------------
}
