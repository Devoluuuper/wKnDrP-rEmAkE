Flags = {
    SyncFlags = {
        ['neonLights'] = 1,
        ['engineSound'] = 2,
        ['leftIndicator'] = 4,
        ['rightIndicator'] = 8,
        ['hazardIndicator'] = 16
    },
    SirenFlags = {
        ['sirenActive'] = 1,
        ['sirenMuted'] = 2,
        ['sirenAirhorn'] = 4,
        ['sirenNormal'] = 8,
        ['sirenAltern'] = 16,
        ['sirenWarning'] = 32,
    }
}

SirenPresets = {
    [1] = { -- STANDARD
        sirenAirhorn = 'SIRENS_AIRHORN',
        sirenNormal = 'VEHICLES_HORNS_SIREN_1',
        sirenAltern = 'VEHICLES_HORNS_SIREN_2',
        sirenWarning = 'VEHICLES_HORNS_POLICE_WARNING'
    },
    [2] = { -- EMERGENCY
        sirenAirhorn = 'SIRENS_AIRHORN',
        sirenNormal = 'VEHICLES_HORNS_SIREN_1',
        sirenAltern = 'VEHICLES_HORNS_SIREN_2',
        sirenWarning = 'VEHICLES_HORNS_AMBULANCE_WARNING'
    },
    [3] = { -- FIRETRUCK
        sirenAirhorn = 'VEHICLES_HORNS_FIRETRUCK_WARNING',
        sirenNormal = 'VEHICLES_HORNS_SIREN_1',
        sirenAltern = 'VEHICLES_HORNS_SIREN_2',
        sirenWarning = 'VEHICLES_HORNS_AMBULANCE_WARNING'
    }
}

ModelPreset = {
    [`FIRETRUK`] = 3,
    [`AMBULANCE`] = 2,
    [`LGUARD`] = 2,
    [`policebul`] = 2,
}

LockChance = 0.7

Immune = {
    [`bmx`] = true,
}

Vehicles = {
    -- Compacts --
    [0] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },


    -- Sedans --
    [1] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },


    -- SUVS --
    [2] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },


    -- COUPES --
    [3] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },


    -- MUSCLES --
    [4] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- SPORT CLASSICS --
    [5] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- Sports --
    [6] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- SUPERS --
    [7] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- MOTORCYCLES --
    [8] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        },

        noLocks = true -- This vehicle cannot be locked!
    },

    -- OFF-ROAD --
    [9] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- Industrial --
    [10] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- Utility --
    [11] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- Vans --
    [12] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- Cycles --
    [13] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        },

        noLocks = true -- This vehicle cannot be locked!
    },

    -- Boats --
    [14] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- Helicopters --
    [15] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- Planes --
    [16] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- Service --
    [17] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- Emergency --
    [18] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'very_slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- Military --
    [19] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- Commercial --
    [20] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- Trains --
    [21] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    },

    -- Open Wheel --
    [22] = {
        pickable = true, -- Can this vehicle be lock picked?
        pickItem = {  -- What item is required to lock pick this vehicle?
            lockpick = {
                difficulty = 'slow',
                degrade = {min = 1, max = 5}
            },

            advancedlockpick = {
                difficulty = 'medium',
                degrade = {min = 0, max = 2}
            }
        }
    }
}

Difficulties = {
    very_slow = { time = {min = 60, max = 70}, turns = {min = 3, max = 5} },
    slow = { time = {min = 60, max = 70}, turns = {min = 3, max = 5} },
    medium = { time = {min = 60, max = 70}, turns = {min = 2, max = 4} },
    fast = { time = {min = 60, max = 70}, turns = {min = 1, max = 2} }
}