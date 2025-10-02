cfg = {}

cfg.rollingTasks = {
    ['weed_joint'] = {label = 'Kanepisuits', needs = {'dried_weed'}},
    ['cigarett'] = {label = 'Sigarett', needs = {'tobacco_powder'}},
    ['cigarello'] = {label = 'Sigarillo', needs = {'tobacco_powder', 'dried_tobacco'}}
}

cfg.scaleTasks = {
    ['amphetamine_pooch'] = {label = 'Pakendatud amfetamiin', needs = {'amphetamine', 'grip_bag'}},
    ['coke_pooch'] = {label = 'Pakendatud kokaiin', needs = {'coke', 'grip_bag'}},
    ['weed_pooch'] = {label = 'Pakendatud kanep', needs = {'dried_weed', 'grip_bag'}},
    ['heroin_pooch'] = {label = 'Pakendatud heroiin', needs = {'heroin', 'grip_bag'}}
}

------------------------------------------------------

cfg.mixerTasks = {
    ['snus'] = {label = 'Tups', needs = {'cloth', 'chemical_element', 'tobacco_mass'}},
    ['chemical_mass'] = {label = 'Keemiamass', needs = {'soda', 'water', 'aluminium', 'chemical_element'}},

    ['lsa'] = {label = 'LSA', needs = {'dried_barley', 'sulfur', 'chemical_element'}},
    ['lsd_extract'] = {label = 'LSD Ekstrakt', needs = {'lsa', 'water', 'chemical_element'}}
}

cfg.heaterTasks = {
    ['amphetamine_paste'] = {label = 'Amfetamiinipasta', needs = {'chemical_mass', 'soda', 'water', 'sulfur', 'chemical_element'}},
    ['morphine'] = {label = 'Morfiinibaas', needs = {'plaster', 'milky_juice'}},
    ['brown_heroin'] = {label = 'Pruun heroiin', needs = {'morphine', 'chemical_element', 'water', 'soda'}},
    ['heroin'] = {label = 'Heroiin', needs = {'brown_heroin', 'chemical_element'}}, 
    ['moonshine'] = {label = 'Puskar', needs = {'alcohol', 'bottle'}},
    ['tobacco_mass'] = {label = 'Tubakamass', needs = {'tobacco_powder', 'water', 'salt'}}
}

cfg.dryerTasks = {
    ['amphetamine'] = {label = 'Amfetamiin', needs = {'amphetamine_paste'}},
    ['dried_weed'] = {label = 'Kuivata kanepiõisi', needs = {'wet_weed'}},
    ['coke_plate'] = {label = 'Kokaiiniplaat', needs = {'chemical_element', 'processed_coke'}},
    ['dried_tobacco'] = {label = 'Kuivatatud tubakaleht', needs = {'wet_tobaccoleaf'}},
    ['dried_barley'] = {label = 'Kuivatatud oder', needs = {'barley'}}
}

cfg.crusherTasks = {
    ['kief'] = {label = 'Purusta õis ja eemalda kiff', needs = {'dried_weed'}},
    ['tobacco_powder'] = {label = 'Tubakapuru', needs = {'dried_tobacco'}},
    ['wet_tobacco'] = {label = 'Niiske tubakapuru', needs = {'wet_tobacco'}},
    ['coke'] = {label = 'Kokaiin', needs = {'coke_plate'}},
    ['sulp'] = {label = 'Sulp', needs = {'potato', 'barley', 'water', 'soda'}},
    ['processed_coke'] = {label = 'Töödeldud kokalehed', needs = {'coca_leaf', 'plaster', 'water'}}
}

cfg.packerTasks = {
    ['cigarett_pack'] = {label = 'Sigaretipakk', needs = {['cigarett'] = 10}},
    ['cigarett_block'] = {label = 'Sigaretiblokk', needs = {['cigarett_pack'] = 10}},
    ['cigarello_pack'] = {label = 'Sigarillo pakk', needs = {['cigarello'] = 10}},
    ['snus_pack'] = {label = 'Tupsukarp', needs = {['snus'] = 10, ['plastic'] = 1}},
    ['snus_tower'] = {label = 'Tupsutorn', needs = {['snus_pack'] = 10, ['film'] = 1}},
    ['hash'] = {label = 'Hash (brownie)', needs = {['kief'] = 1}},
    ['lsd'] = {label = 'LSD', needs = {['lsd_extract'] = 1, ['lsd_blotter_empty'] = 1}}
}

cfg.barrelTasks = {
    ['alcohol'] = {label = 'Alkohol', needs = {'sulp'}}
}