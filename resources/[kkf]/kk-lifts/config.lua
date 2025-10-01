ZONES = {
    ['fib_downstairs'] = {
        label = "FIB 1. korrus",
        coords = vec4(139.01538085938, -762.79119873047, 45.7421875, 221.10237121582),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'fib_upstairs'
        }
    },
    ['fib_upstairs'] = {
        label = "FIB 49. korrus",
        coords = vec4(136.04835510254, -761.64392089844, 242.1435546875, 164.4094543457),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'fib_downstairs'
        }
    },
    
    ['vhpd_down_1b_katus'] = {
        label = "Katus",
        coords = vec4(602.38684082031, -18.18461227417, 101.32971191406, 342.99212646484),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'vhpd_up_1',
            'vhpd_down_1',
            'vhpd_down_1b'
        }
    },

    ['vhpd_up_1'] = {
        label = "II korrus",
        coords = vec4(612.97583007812, -10.852745056152, 87.79931640625, 340.15747070312),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'vhpd_down_1b',
            'vhpd_down_1',
            'vhpd_down_1b_katus'
        }
    },

    ['vhpd_down_1'] = {
        label = "I korrus",
        coords = vec4(612.94946289062, -11.010986328125, 83.637329101562, 342.99212646484),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'vhpd_up_1',
            'vhpd_down_1b',
            'vhpd_down_1b_katus'
        }
    },

    ['vhpd_down_1b'] = {
        label = "-I korrus",
        coords = vec4(613.06811523438, -10.945053100586, 75.0439453125, 22.677164077759),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'vhpd_up_1',
            'vhpd_down_1',
            'vhpd_down_1b_katus'
        }
    },

    ['vhpd_down_2b_katus'] = {
        label = "Katus",
        coords = vec4(598.087890625, -16.773624420166, 101.32971191406, 337.32284545898),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'vhpd_up_2',
            'vhpd_down_2',
            'vhpd_down_2b'
        }
    },

    ['vhpd_up_2'] = {
        label = "II korrus",
        coords = vec4(608.40002441406, -9.1648330688476, 87.79931640625, 340.15747070312),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'vhpd_down_2b',
            'vhpd_down_2',
            'vhpd_down_2b_katus'
        }
    },

    ['vhpd_down_2'] = {
        label = "I korrus",
        coords = vec4(608.40002441406, -9.1648330688476, 83.637329101562, 342.99212646484),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'vhpd_up_2',
            'vhpd_down_2b',
            'vhpd_down_2b_katus'
        }
    },

    ['vhpd_down_2b'] = {
        label = "-I korrus",
        coords = vec4(608.36041259766, -9.2043914794922, 75.0439453125, 340.15747070312),
        interactDistance = 1.5,
        renderDistance = 5.0,
        directions = {
            'vhpd_up_2',
            'vhpd_down_2',
            'vhpd_down_2b_katus'
        }
    },

    ['union_down'] = {
        label = "Alumine korrus",
        coords = vec4(-0.26373291015625, -706.21978759766, 16.1201171875, 342.99212646484),
        interactDistance = 3.0,
        renderDistance = 5.0,
        directions = {
            'union_up'
        }
    },

    ['union_up'] = {
        label = "Ülemine korrus",
        coords = vec4(10.351649284363, -671.51208496094, 33.441772460938, 2.8346455097198),
        interactDistance = 3.0,
        renderDistance = 5.0,
        directions = {
            'union_down'
        }
    },
}