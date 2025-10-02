cfg = {}

cfg.blip = vec4(2339.6572265625, 3056.3999023438, 48.151611328125, 218.2677154541)

cfg.skillAmount = 0.6
cfg.skillname = 'mechanic'

cfg.toolboxes = {
    ['fix_up_a'] = {
        durabilityLoss = function() return math.random(1, 75)* 0.1 end
    },
    ['fix_up_b'] = {
        durabilityLoss = function() return math.random(1, 60)* 0.1 end
    },
    ['fix_up_c'] = {
        durabilityLoss = function() return math.random(1, 45)* 0.1 end
    },
    ['fix_up_d'] = {
        durabilityLoss = function() return math.random(1, 30)* 0.1 end
    },
    ['fix_up_e'] = {
        durabilityLoss = function() return math.random(1, 15)* 0.1 end
    }
}

cfg.seller = vec4(2411.4064941406, 3032.3999023438, 48.151611328125, 36.850395202637)

cfg.repairLocations = {
    {
        coords = vec4(1311.0593261719, 3064.7868652344, 40.030029296875, 351.49606323242),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1539.1647949219, 3119.5122070312, 40.265991210938, 340.15747070312),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2530.5759277344, 2006.6900634766, 19.422729492188, 175.74803161621),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2549.8681640625, 1749.9428710938, 24.7978515625, 351.49606323242),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2518.140625, 1434.4615478516, 34.587524414062, 172.91339111328),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2472.9890136719, 1283.1955566406, 49.735473632812, 133.22833251953),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2144.123046875, 1366.9055175781, 75.397827148438, 22.677164077759),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1954.9187011719, 1640.8747558594, 72.1962890625, 226.77166748047),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1953.3758544922, 1729.3187255859, 67.05712890625, 17.007873535156),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1886.5582275391, 2189.4855957031, 54.13330078125, 5.6692910194397),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1819.8989257812, 2204.5187988281, 53.021240234375, 164.4094543457),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1993.3714599609, 2555.8549804688, 54.06591796875, 320.31497192383),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2319.876953125, 2976.2241210938, 46.955322265625, 240.94488525391),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2261.6044921875, 3187.54296875, 48.252807617188, 17.007873535156),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2125.4240722656, 3274.298828125, 45.489379882812, 79.370079040527),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2054.7561035156, 3286.1801757812, 44.98388671875, 266.45669555664),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1905.876953125, 3306.8571777344, 43.332641601562, 291.96850585938),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1850.1625976562, 3313.4108886719, 42.574340820312, 116.22047424316),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1748.7032470703, 3434.0571289062, 37.249877929688, 28.34645652771),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1927.2791748047, 3602.9143066406, 35.598510742188, 300.47244262695),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2105.8022460938, 3732.9626464844, 32.515014648438, 306.14172363281),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2191.5693359375, 3803.6176757812, 33.05419921875, 124.72441101074),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2413.5166015625, 3931.701171875, 35.733276367188, 314.64566040039),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2423.7495117188, 3987.1120605469, 36.373657226562, 155.90550231934),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2593.1472167969, 4245.2573242188, 41.563354492188, 328.81890869141),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2856.263671875, 4417.9516601562, 48.337036132812, 286.29919433594),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(3062.9274902344, 3995.1823730469, 72.16259765625, 218.2677154541),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2988.1845703125, 3563.8022460938, 70.89892578125, 218.2677154541),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2988.1186523438, 3437.736328125, 70.696655273438, 201.25984191895),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2971.3186035156, 4473.666015625, 45.7421875, 334.48818969727),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2914.4306640625, 4743.5869140625, 48.859375, 79.370079040527),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2811.6923828125, 4873.0551757812, 40.367065429688, 218.2677154541),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2788.5495605469, 4825.3188476562, 44.478393554688, 121.88976287842),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2645.4724121094, 4811.1694335938, 33.0205078125, 136.06298828125),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2488.0747070312, 4628.0571289062, 34.638061523438, 334.48818969727),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2452.8923339844, 4564.7075195312, 35.952392578125, 204.09449768066),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2476.0615234375, 4472.0966796875, 34.536987304688, 192.75592041016),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2456.5187988281, 4285.595703125, 36.154541015625, 354.33071899414),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1914.9890136719, 3646.298828125, 33.256469726562, 127.55905151367),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1732.7076416016, 3541.0153808594, 35.699584960938, 133.22833251953),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1881.3890380859, 2966.1362304688, 45.15234375, 104.88188934326),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1678.3780517578, 2876.3076171875, 42.169921875, 124.72441101074),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1664.8352050781, 2841.0329589844, 40.9736328125, 308.97637939453),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1510.5889892578, 2742.3559570312, 37.334106445312, 311.81103515625),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1342.4571533203, 2695.7143554688, 37.148681640625, 96.377944946289),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1311.771484375, 2667.0988769531, 37.1318359375, 283.4645690918),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1324.2462158203, 2593.4372558594, 37.671020507812, 232.44094848633),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1410.0, 2349.7978515625, 73.291625976562, 51.023624420166),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1474.9450683594, 2221.2526855469, 77.99267578125, 209.76377868652),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1512.8044433594, 2072.6242675781, 94.03369140625, 184.25196838379),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1470.4088134766, 1854.3560791016, 106.90698242188, 144.56690979004),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1282.5098876953, 1947.0461425781, 80.351684570312, 56.69291305542),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1102.2725830078, 2055.1779785156, 52.86962890625, 76.535430908203),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1033.3846435547, 2101.1208496094, 49.381713867188, 36.850395202637),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(931.912109375, 2188.8659667969, 48.016845703125, 215.43309020996),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(739.64837646484, 2281.0549316406, 49.297485351562, 85.039367675781),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(554.98022460938, 2349.9956054688, 47.983154296875, 31.181102752686),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(403.14724731445, 2490.0, 44.98388671875, 73.700790405273),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(346.98461914062, 2517.1252441406, 44.259399414062, 201.25984191895),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(249.52087402344, 2753.4328613281, 43.180908203125, 209.76377868652),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(224.83515930176, 2879.578125, 43.06298828125, 238.11022949219),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(256.85275268555, 2907.7319335938, 42.608032226562, 311.81103515625),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(298.0087890625, 2948.4526367188, 42.287963867188, 277.79528808594),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1055.9868164062, 3139.6484375, 40.097412109375, 119.0551071167),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(825.44177246094, 3107.6440429688, 40.687133789062, 79.370079040527),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(314.00439453125, 3128.7956542969, 40.198486328125, 82.204727172852),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(119.23516845703, 3099.3625488281, 41.765625, 107.71653747559),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(37.780223846436, 3060.3295898438, 40.400756835938, 300.47244262695),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-60.026371002197, 3000.8835449219, 38.934814453125, 110.55118560791),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-283.00219726562, 2954.3999023438, 29.060791015625, 102.04724884033),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-395.96044921875, 2906.4790039062, 34.8740234375, 119.0551071167),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-603.63952636719, 2867.0373535156, 33.964111328125, 102.04724884033),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-749.22198486328, 2801.5517578125, 25.2021484375, 102.04724884033),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1009.2659301758, 2754.8967285156, 24.292358398438, 124.72441101074),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1073.9736328125, 2685.4946289062, 20.517944335938, 317.48031616211),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1257.0725097656, 2552.3999023438, 17.383911132812, 130.39370727539),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1408.0219726562, 2432.0043945312, 27.0556640625, 138.89762878418),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1693.6087646484, 2450.1494140625, 29.667358398438, 107.71653747559),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2220.10546875, 2317.6616210938, 32.0263671875, 144.56690979004),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2621.8022460938, 2273.3273925781, 25.75830078125, 294.80316162109),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2781.0593261719, 2237.5649414062, 23.9384765625, 130.39370727539),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2948.6506347656, 2144.4262695312, 39.81103515625, 144.56690979004),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2944.2724609375, 2100.9230957031, 40.80517578125, 334.48818969727),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-3010.2065429688, 1980.3560791016, 29.987548828125, 181.41732788086),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-3002.6242675781, 1917.2967529297, 27.982421875, 354.33071899414),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-3053.9208984375, 1808.8747558594, 33.357543945312, 189.92126464844),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-3031.595703125, 1657.1472167969, 33.391235351562, 209.76377868652),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-3003.4020996094, 1657.6746826172, 32.599243164062, 73.700790405273),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-3004.7077636719, 1510.03515625, 27.02197265625, 167.24407958984),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-3095.6440429688, 1359.0725097656, 19.557495117188, 195.5905456543),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-3068.123046875, 1181.0505371094, 20.871826171875, 308.97637939453),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2987.6176757812, 1305.5340576172, 34.570678710938, 317.48031616211),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2812.2329101562, 1308.8044433594, 70.713500976562, 311.81103515625),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2639.5517578125, 1521.7846679688, 118.853515625, 342.99212646484),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2512.5627441406, 1703.947265625, 153.783203125, 181.41732788086),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2517.6791992188, 1856.8879394531, 165.62854003906, 39.685039520264),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2476.6286621094, 1944.0263671875, 172.89086914062, 283.4645690918),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2377.0021972656, 1925.4066162109, 182.2255859375, 249.44882202148),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2233.7407226562, 1904.123046875, 186.57287597656, 303.30709838867),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2062.4174804688, 1934.5054931641, 187.49963378906, 206.92913818359),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1967.1560058594, 1752.4088134766, 176.42932128906, 269.29135131836),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1935.4813232422, 1772.8483886719, 173.29528808594, 150.23622131348),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1771.6746826172, 1889.4461669922, 148.89672851562, 93.543304443359),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1882.4835205078, 1967.6307373047, 142.93188476562, 235.27558898926),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1670.8879394531, 2233.0021972656, 85.642456054688, 68.031494140625),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2054.9802246094, 2287.490234375, 41.226318359375, 85.039367675781),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2051.68359375, 2312.9538574219, 36.120849609375, 308.97637939453),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1918.4703369141, 2361.6923828125, 33.660766601562, 294.80316162109),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1715.7362060547, 2427.8505859375, 30.7626953125, 277.79528808594),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1557.0856933594, 2272.3383789062, 52.532592773438, 198.42520141602),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1546.140625, 2198.7033691406, 55.397094726562, 206.92913818359),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1544.8352050781, 2137.5297851562, 55.228515625, 252.28346252441),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1486.3121337891, 2020.7604980469, 64.462280273438, 221.10237121582),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1435.7670898438, 1896.4088134766, 74.1171875, 184.25196838379),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1483.8198242188, 1782.4879150391, 85.861572265625, 155.90550231934),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1511.9340820312, 1650.2109375, 102.89672851562, 215.43309020996),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1463.7362060547, 1542.4483642578, 112.72009277344, 36.850395202637),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1531.0021972656, 1398.4219970703, 123.13330078125, 53.858268737793),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1611.5208740234, 1348.140625, 132.01318359375, 147.40158081055),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1636.0747070312, 1162.2989501953, 148.61022949219, 192.75592041016),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1647.8110351562, 1032.5274658203, 152.77221679688, 167.24407958984),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1701.0197753906, 898.91870117188, 148.34069824219, 161.57479858398),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1920.0791015625, 728.76922607422, 140.70764160156, 331.65353393555),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2010.5406494141, 811.30548095703, 159.8154296875, 357.16534423828),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2029.8198242188, 810.11865234375, 160.50622558594, 187.08660888672),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2107.2922363281, 964.65496826172, 184.02856445312, 62.362205505371),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2300.9143066406, 1024.5626220703, 194.89672851562, 325.98425292969),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2460.7121582031, 1049.3670654297, 191.94799804688, 79.370079040527),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2638.2592773438, 1320.052734375, 143.36999511719, 184.25196838379),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2622.4614257812, 1465.9384765625, 126.16625976562, 19.842519760132),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2640.7253417969, 1462.6153564453, 126.03149414062, 238.11022949219),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1569.7978515625, 953.47253417969, 159.158203125, 263.6220703125),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1465.7802734375, 919.75384521484, 179.1083984375, 62.362205505371),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1395.9296875, 739.92529296875, 182.2255859375, 260.78741455078),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1342.7868652344, 737.64398193359, 184.70251464844, 306.14172363281),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1264.3253173828, 846.79119873047, 190.06079101562, 0.0),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1151.5120849609, 946.60217285156, 198.38464355469, 354.33071899414),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1004.4263916016, 1185.9296875, 217.32385253906, 260.78741455078),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-900.65936279297, 1029.6658935547, 223.99633789062, 204.09449768066),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-785.63073730469, 974.62414550781, 236.66735839844, 283.4645690918),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-724.69451904297, 967.49011230469, 237.32458496094, 325.98425292969),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-554.41320800781, 955.31866455078, 242.43005371094, 229.60629272461),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-580.29888916016, 962.47912597656, 241.67175292969, 39.685039520264),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-715.42419433594, 1091.9340820312, 253.90478515625, 107.71653747559),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-744.71209716797, 1147.2263183594, 261.77368164062, 255.11810302734),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-745.33184814453, 1172.1889648438, 262.38024902344, 39.685039520264),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-804.47473144531, 1295.8813476562, 257.982421875, 238.11022949219),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-798.27691650391, 1402.7341308594, 245.193359375, 2.8346455097198),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-784.04833984375, 1543.5164794922, 221.1318359375, 178.58267211914),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-760.95825195312, 1672.1142578125, 201.55236816406, 342.99212646484),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-820.23297119141, 1681.1999511719, 195.41906738281, 96.377944946289),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-757.21319580078, 1865.2747802734, 159.47839355469, 150.23622131348),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-728.72967529297, 1859.1164550781, 156.91723632812, 320.31497192383),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-703.95166015625, 1939.6746826172, 141.17944335938, 215.43309020996),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-702.48791503906, 1965.2967529297, 138.06225585938, 59.52755355835),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-763.12084960938, 2000.8088378906, 128.50842285156, 70.866142272949),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-820.64172363281, 2101.5297851562, 113.00659179688, 181.41732788086),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-773.35382080078, 2294.4790039062, 75.347290039062, 331.65353393555),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-571.50329589844, 2485.1604003906, 51.167724609375, 320.31497192383),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-546.44836425781, 2586.6594238281, 47.309204101562, 14.173228263855),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-548.55822753906, 2728.9318847656, 40.720825195312, 308.97637939453),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(707.26153564453, 2218.3251953125, 56.643920898438, 158.74015808105),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(664.82635498047, 2173.5825195312, 62.305541992188, 300.47244262695),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(499.05493164062, 2161.7275390625, 81.514282226562, 317.48031616211),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(343.35824584961, 2097.4548339844, 100.53771972656, 96.377944946289),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(199.78022766113, 2112.3823242188, 120.43737792969, 85.039367675781),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(124.14066314697, 2095.0021972656, 135.8212890625, 286.29919433594),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(16.33846282959, 2035.4505615234, 164.36486816406, 107.71653747559),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-133.38461303711, 1981.0944824219, 188.52746582031, 150.23622131348),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-190.91868591309, 1879.9516601562, 197.27258300781, 119.0551071167),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-140.18901062012, 1855.859375, 197.42419433594, 272.1259765625),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-9.1648330688476, 1841.1164550781, 205.05712890625, 85.039367675781),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(10.997802734375, 1759.3450927734, 217.91357421875, 42.519683837891),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(137.16923522949, 1591.7010498047, 229.23657226562, 198.42520141602),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(212.14945983887, 1431.2307128906, 239.26232910156, 59.52755355835),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(234.65934753418, 1321.912109375, 236.7685546875, 195.5905456543),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(339.0989074707, 994.37805175781, 209.97729492188, 283.4645690918),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(480.39559936523, 860.99340820312, 197.50842285156, 260.78741455078),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(633.61315917969, 771.67913818359, 203.9619140625, 286.29919433594),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(779.53845214844, 844.57580566406, 213.22924804688, 340.15747070312),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(845.01098632812, 988.10107421875, 240.64392089844, 144.56690979004),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(978.68572998047, 934.49670410156, 215.38610839844, 206.92913818359),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(949.78021240234, 830.58459472656, 197.91284179688, 147.40158081055),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(918.32965087891, 735.77142333984, 182.61315917969, 184.25196838379),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(936.83074951172, 714.13189697266, 180.52380371094, 22.677164077759),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1029.6790771484, 678.46154785156, 159.32678222656, 328.81890869141),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1103.0241699219, 803.81536865234, 152.28356933594, 331.65353393555),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1147.9384765625, 1087.1208496094, 169.18383789062, 8.5039367675781),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1160.2681884766, 1181.9340820312, 166.21826171875, 164.4094543457),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1214.5450439453, 1304.6505126953, 143.47106933594, 226.77166748047),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1085.3406982422, 1464.1713867188, 170.80151367188, 73.700790405273),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(972.59338378906, 1718.4923095703, 163.94360351562, 289.13385009766),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(719.8681640625, 1720.5626220703, 182.47839355469, 76.535430908203),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(537.37585449219, 1793.8549804688, 215.67248535156, 73.700790405273),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(3267.1384277344, 5198.6899414062, 18.93408203125, 22.677164077759),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(3312.6066894531, 5140.7734375, 17.619750976562, 79.370079040527),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(3150.1318359375, 5111.3671875, 19.271118164062, 116.22047424316),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(3773.6044921875, 4471.4375, 5.9765625, 121.88976287842),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(3699.2834472656, 4462.9448242188, 22.759033203125, 56.69291305542),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(3692.0966796875, 4548.1450195312, 24.427124023438, 209.76377868652),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(3593.8813476562, 4527.7451171875, 42.018310546875, 62.362205505371),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(3492.421875, 4687.3715820312, 52.0439453125, 11.338582038879),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(3426.8176269531, 4885.7407226562, 34.317993164062, 56.69291305542),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(3299.0241699219, 4997.6044921875, 23.9384765625, 82.204727172852),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2841.982421875, 5007.9165039062, 31.85791015625, 147.40158081055),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2663.1164550781, 4830.4877929688, 32.902587890625, 150.23622131348),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2673.9956054688, 4708.0615234375, 37.435180664062, 201.25984191895),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2591.8154296875, 4839.61328125, 34.216796875, 51.023624420166),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2540.5319824219, 4706.1494140625, 32.936279296875, 138.89762878418),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2306.8879394531, 4726.826171875, 36.289428710938, 87.874015808105),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2127.1384277344, 4821.3100585938, 40.703979492188, 127.55905151367),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2011.1076660156, 4735.4111328125, 40.535522460938, 99.212593078613),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1959.3626708984, 4648.3383789062, 40.131103515625, 263.6220703125),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1816.3780517578, 4595.7231445312, 36.272583007812, 153.07086181641),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1682.4395751953, 4681.3452148438, 42.422729492188, 269.29135131836),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1681.7670898438, 4933.490234375, 41.445434570312, 325.98425292969),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1931.5120849609, 5162.6635742188, 44.478393554688, 155.90550231934),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2050.5100097656, 5020.4702148438, 40.383911132812, 232.44094848633),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2154.8703613281, 5089.75390625, 44.967041015625, 320.31497192383),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2107.8330078125, 4915.2529296875, 39.94580078125, 141.7322845459),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1897.2395019531, 4713.296875, 39.996337890625, 204.09449768066),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1414.6812744141, 4373.0771484375, 42.810302734375, 87.874015808105),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1364.5977783203, 4382.9272460938, 43.703247070312, 172.91339111328),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1314.2373046875, 4310.1098632812, 37.401489257812, 351.49606323242),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1381.2131347656, 4312.24609375, 36.82861328125, 5.6692910194397),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1366.1274414062, 4505.841796875, 55.616088867188, 119.0551071167),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1116.158203125, 4431.5737304688, 63.232177734375, 73.700790405273),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1051.5296630859, 4455.3891601562, 53.914306640625, 79.370079040527),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },                                            
    {
        coords = vec4(927.96923828125, 4472.7954101562, 50.561157226562, 73.700790405273),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(842.86157226562, 4507.015625, 53.358276367188, 42.519683837891),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(826.98461914062, 4491.2705078125, 52.717895507812, 116.22047424316),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(853.45056152344, 4243.2001953125, 50.139892578125, 144.56690979004),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(707.72308349609, 4174.140625, 40.14794921875, 286.29919433594),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(742.62860107422, 4260.1318359375, 55.363403320312, 99.212593078613),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(648.25054931641, 4231.2265625, 54.015380859375, 277.79528808594),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(549.85052490234, 4258.9711914062, 52.819091796875, 70.866142272949),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(483.52087402344, 4315.6220703125, 56.003662109375, 238.11022949219),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(432.79119873047, 4373.8549804688, 62.709838867188, 62.362205505371),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(381.56042480469, 4410.31640625, 61.783203125, 198.42520141602),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(341.30108642578, 4504.4174804688, 61.463012695312, 45.354328155518),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(196.99780273438, 4446.6723632812, 71.707641601562, 133.22833251953),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(181.76702880859, 4412.0571289062, 73.797119140625, 102.04724884033),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(126.54066467285, 4461.9296875, 81.24462890625, 39.685039520264),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-51.349449157715, 4422.2241210938, 56.829345703125, 249.44882202148),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-110.00439453125, 4298.755859375, 45.320922851562, 274.96063232422),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-123.6791229248, 4612.5361328125, 123.8916015625, 48.188972473145),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-513.83734130859, 4933.5034179688, 147.11059570312, 0.0),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-682.43078613281, 5260.0483398438, 75.93701171875, 48.188972473145),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-697.62194824219, 5319.0068359375, 69.601440429688, 255.11810302734),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-810.47473144531, 5422.9184570312, 33.424926757812, 113.38582611084),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-806.017578125, 5558.439453125, 31.520874023438, 257.95275878906),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-762.92309570312, 5549.0112304688, 32.85205078125, 175.74803161621),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-771.74505615234, 5694.4086914062, 21.073974609375, 209.76377868652),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-733.35821533203, 5801.2221679688, 16.962646484375, 317.48031616211),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-681.00659179688, 5848.3647460938, 16.541381835938, 17.007873535156),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-517.23956298828, 6275.7626953125, 9.2623291015625, 354.33071899414),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-541.85931396484, 6043.6748046875, 22.455688476562, 303.30709838867),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-416.25494384766, 6077.3276367188, 30.86376953125, 133.22833251953),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-423.44177246094, 6125.7890625, 30.7626953125, 223.93701171875),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-397.49011230469, 6114.6196289062, 30.661499023438, 320.31497192383),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-351.74505615234, 6334.984375, 29.24609375, 223.93701171875),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-208.03517150879, 6409.6088867188, 31.015380859375, 36.850395202637),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-152.59780883789, 6493.75390625, 28.993408203125, 325.98425292969),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(20.742858886719, 6665.7495117188, 30.914306640625, 184.25196838379),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(24.883518218994, 6541.8989257812, 30.678344726562, 70.866142272949),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-100.76043701172, 6400.4702148438, 30.813232421875, 42.519683837891),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-137.18241882324, 6308.3603515625, 30.86376953125, 226.77166748047),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(141.6791229248, 6496.2065429688, 30.7626953125, 311.81103515625),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(428.80880737305, 6552.6723632812, 26.684936523438, 314.64566040039),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(668.79559326172, 6507.3627929688, 27.460083007812, 260.78741455078),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(761.98681640625, 6516.3823242188, 25.117919921875, 76.535430908203),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(968.55822753906, 6475.0947265625, 20.366333007812, 269.29135131836),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1026.2506103516, 6502.4174804688, 20.349487304688, 85.039367675781),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1296.9099121094, 6477.19140625, 19.540649414062, 269.29135131836),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1582.8000488281, 6448.0219726562, 24.460815429688, 153.07086181641),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1518.6197509766, 6416.0043945312, 22.657836914062, 252.28346252441),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1800.9099121094, 6417.138671875, 37.182373046875, 110.55118560791),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1870.5230712891, 6408.4877929688, 45.9443359375, 107.71653747559),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(1684.7340087891, 6434.7426757812, 31.655639648438, 192.75592041016),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2444.5583496094, 5606.2153320312, 44.276245117188, 206.92913818359),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2198.0439453125, 5565.4814453125, 53.223388671875, 314.64566040039),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2200.5495605469, 5618.4658203125, 53.594116210938, 328.81890869141),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2377.0153808594, 5494.1274414062, 51.319458007812, 238.11022949219),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(2475.1252441406, 5119.2265625, 45.77587890625, 79.370079040527),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1571.3538818359, 5156.755859375, 19.153076171875, 138.89762878418),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1561.3846435547, 4957.279296875, 61.1259765625, 161.57479858398),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1510.0087890625, 4963.3452148438, 62.01904296875, 283.4645690918),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2041.8857421875, 4458.1977539062, 56.576538085938, 147.40158081055),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2173.1340332031, 4451.419921875, 61.901123046875, 127.55905151367),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2230.9714355469, 4327.0551757812, 48.404418945312, 141.7322845459),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2229.9165039062, 4226.1889648438, 46.163330078125, 340.15747070312),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2365.2263183594, 4074.8439941406, 30.96484375, 170.07873535156),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2477.2087402344, 3761.2746582031, 17.552368164062, 164.4094543457),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2404.087890625, 3561.61328125, 17.484985351562, 187.08660888672),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2334.1845703125, 3436.7077636719, 29.734741210938, 107.71653747559),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-2035.4637451172, 3324.3955078125, 32.245361328125, 133.22833251953),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1716.1318359375, 2889.1911621094, 32.177978515625, 147.40158081055),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    },
    {
        coords = vec4(-1482.7912597656, 2781.1647949219, 19.254272460938, 277.79528808594),
        model = 'kuruma',
        description = "Vajab natuke kõpitsemist!"
    }
}

cfg.rewardLevels = {
    {
        level = 1,
        rewards = {
            { item = 'money', min = 50, max = 150 },
            { item = 'money', min = 40, max = 140 },
            { item = 'money', min = 30, max = 130 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 2,
        rewards = {
            { item = 'money', min = 70, max = 170 },
            { item = 'money', min = 50, max = 150 },
            { item = 'money', min = 40, max = 140 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 3,
        rewards = {
            { item = 'money', min = 90, max = 190 },
            { item = 'money', min = 60, max = 160 },
            { item = 'money', min = 50, max = 150 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 4,
        rewards = {
            { item = 'money', min = 110, max = 210 },
            { item = 'money', min = 70, max = 170 },
            { item = 'money', min = 60, max = 160 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 5,
        rewards = {
            { item = 'money', min = 130, max = 230 },
            { item = 'money', min = 80, max = 180 },
            { item = 'money', min = 70, max = 170 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 6,
        rewards = {
            { item = 'money', min = 150, max = 250 },
            { item = 'money', min = 90, max = 190 },
            { item = 'money', min = 80, max = 180 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 7,
        rewards = {
            { item = 'money', min = 170, max = 270 },
            { item = 'money', min = 100, max = 200 },
            { item = 'money', min = 90, max = 190 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 8,
        rewards = {
            { item = 'money', min = 170, max = 270 },
            { item = 'money', min = 100, max = 200 },
            { item = 'money', min = 90, max = 190 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 9,
        rewards = {
            { item = 'money', min = 190, max = 290 },
            { item = 'money', min = 110, max = 210 },
            { item = 'money', min = 100, max = 200 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 10,
        rewards = {
            { item = 'money', min = 210, max = 310 },
            { item = 'money', min = 120, max = 220 },
            { item = 'money', min = 110, max = 210 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 11,
        rewards = {
            { item = 'money', min = 230, max = 330 },
            { item = 'money', min = 130, max = 230 },
            { item = 'money', min = 120, max = 220 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 12,
        rewards = {
            { item = 'money', min = 250, max = 350 },
            { item = 'money', min = 140, max = 240 },
            { item = 'money', min = 130, max = 230 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 13,
        rewards = {
            { item = 'money', min = 270, max = 370 },
            { item = 'money', min = 150, max = 250 },
            { item = 'money', min = 140, max = 240 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 14,
        rewards = {
            { item = 'money', min = 290, max = 390 },
            { item = 'money', min = 160, max = 260 },
            { item = 'money', min = 150, max = 250 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
    {
        level = 15,
        rewards = {
            { item = 'money', min = 300, max = 400 },
            { item = 'money', min = 170, max = 270 },
            { item = 'money', min = 160, max = 260 },
            { item = 'shipping_document', min = 1, max = 1 }
        }
    },
}

return cfg