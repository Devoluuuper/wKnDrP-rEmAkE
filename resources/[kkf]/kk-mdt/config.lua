cfg = {}

cfg.removePoints = 20

cfg.jobs = {
    'police',
    'ranger',
    'sheriff',
    'state',
    'corrections',
    'metro',
    'park',
    'com'
}

cfg.punishments = {
    [1] = {
        label = 'SakS. 2103 Alarmsõiduki eiramine',
        fine = 1500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 2
    },
    [2] = {
        label = 'SakS. 2104 Liikluseeskirjade rikkumine',
        fine = 1500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 2
    },
    [3] = {
        label = 'SakS. 2105 Nõuetele mittevastav sõiduk',
        fine = 1000,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 2
    },
    [4] = {
        label = 'SakS. 2106 Hooletu juhtimine',
        fine = 1000,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 2
    },
    [5] = {
        label = 'SakS. 2107 3. astme kiirusületus',
        fine = 2000,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 2 
    },
    [6] = {
        label = 'SakS. 2108 2. astme kiirusületus',
        fine = 3500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 2 
    },
    [7] = {
        label = 'SakS. 2110 Juhilubadeta sõitmine',
        fine = 1000,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 2          
    },
    [8] = {
        label = 'SakS. 2112  Valesti parkimine',
        fine = 500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 2
    },
    [9] = {
        label = 'SakS. 2202 Ähvardamine',
        fine = 1500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0
    },
    [10] = {
        label = 'SakS. 2301 Pisivargus',
        fine = 1500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0
    },
    [11] = {
        label = 'SakS. 2308	Sõiduki rikkumine',
        fine = 2000,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0
    },
    [12] = {
        label = 'SakS. 2310 Sõiduki varguskatse',
        fine = 1500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0  
    },
    [13] = {
        label = 'SakS. 2311 Rööv',
        fine = 2000,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0   
    },
    [14] = {
        label = 'SakS. 2312 Röövi kaasaaitamine',
        fine = 1500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0
    },
    [15] = {
        label = 'SakS. 2316 Sissemurdmine',
        fine = 2000,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [16] = {
        label = 'SakS. 2317 Sissemurdmisele kaasaaitamine',
        fine = 1500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0  
    },
    [17] = {
        label = 'SakS. 2410 Maksmata lahkumine',
        fine = 1500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0
    },
    [18] = {
        label = 'SakS. 2501 Kalastusloata kalastamine/ Ülepüük',
        fine = 2000,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0
    },
    [19] = {
        label = 'SakS. 2502	Jahindusloata jahtimine',
        fine = 2000,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0
    },
    [20] = {
        label = 'SakS. 2504	Rahu häirimine',
        fine = 1500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0
    },
    [21] = {
        label = 'SakS. 2513 Maski kandmine',
        fine = 2000,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [22] = {
        label = 'SakS. 2517	Ametniku eiramine',
        fine = 2500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [23] = {
        label = 'SakS. 2617	Külmrelva omamine',
        fine = 3000,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [24] = {
        label = 'SakS. 2701	Narkootikumide omamine kuni 10g',
        fine = 2000,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [25] = {
        label = 'SakS. 2708	Risustamine',
        fine = 1500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [26] = {
        label = 'SakS. 2709	Avalikult alkoholi tarbimine',
        fine = 1000,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [27] = {
        label = 'SakS. 2801	Objektil turvanõuete eiramine',
        fine = 1500,
        jail = 0,
        color = 'sky-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [28] = {
        label = 'SakS. 2114	Tänavavõidusõit(lisada üksikuna)',
        fine = 6000,
        jail = 15,
        color = 'yellow-700', -- sky-800, red-800, yellow-700
        points = 15 
    },
    [29] = {
        label = 'SakS. 2220 Jõukudevaheline tulistamine(lisada üksikuna)',
        fine = 20000,
        jail = 50,
        color = 'yellow-700', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [30] = {
        label = 'SakS. 2101	Autojuhtimine joobesseisundis',
        fine = 3000,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 10 
    },
    [31] = {
        label = 'SakS. 2102	Politsei eest põgenemine (mittepeatumine)',
        fine = 5000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 15 
    },
    [32] = {
        label = 'SakS. 2109	1. astme kiirusületus',
        fine = 5000,
        jail = 15,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 15 
    },
    [33] = {
        label = 'SakS. 2111	Korduv juhilubadeta sõitmine',
        fine = 3000,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 10 
    },
    [34] = {
        label = 'SakS. 2113	Avariipaigalt põgenemine',
        fine = 1500,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 10 
    },
    [35] = {
        label = 'SakS. 2115	Illegaalne numbrimärk',
        fine = 3000,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 10 
    },
    [36] = {
        label = 'SakS. 2116	Korduv liikluseeskirjade rikkumine',
        fine = 3000,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 10 
    },
    [37] = {
        label = 'SakS. 2200	Väärkohtlemine',
        fine = 5000,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [38] = {
        label = 'SakS. 2201	Ohtuseadmine hooletuse tõttu',
        fine = 3000,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [39] = {
        label = 'SakS. 2203	Surmava relva näitamine',
        fine = 5000,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [40] = {
        label = 'SakS. 2204	Surmava relvaga ähvardamine',
        fine = 8000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [41] = {
        label = 'SakS. 2205	Rünnakule kaasaaitamine',
        fine = 8000,
        jail = 50,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [42] = {
        label = 'SakS. 2206	Inimrööv',
        fine = 8000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0
    },
    [43] = {
        label = 'SakS. 2207	Inimröövi kaasaaitamine',
        fine = 6000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [44] = {
        label = 'SakS. 2208	Valitsuse töötaja rööv',
        fine = 10000,
        jail = 35,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [45] = {
        label = 'SakS. 2209	Valitsuse töötaja röövile kaasaaitamine',
        fine = 8000,
        jail = 35,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [46] = {
        label = 'SakS. 2210	Liikumisvabaduse piiramine',
        fine = 8000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [47] = {
        label = 'SakS. 2211	Tunnistaja mõjutamine',
        fine = 7500,
        jail = 50,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [48] = {
        label = 'SakS. 2212	Mõrvakatse',
        fine = 10000,
        jail = 40,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [49] = {
        label = 'SakS. 2213	Mõrvakatse kaasaaitamine',
        fine = 9000,
        jail = 40,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [50] = {
        label = 'SakS. 2214	Valitsuse töötaja mõrvakatse',
        fine = 15000,
        jail = 40,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [51] = {
        label = 'SakS. 2215	Valitsuse töötaja mõrvakatsele kaasaaitamine',
        fine = 13000,
        jail = 40,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [52] = {
        label = 'SakS. 2216	Mõrv',
        fine = 20000,
        jail = 60,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [53] = {
        label = 'SakS. 2217	Mõrva kaasaaitamine',
        fine = 17500,
        jail = 60,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0
    },
    [54] = {
        label = 'SakS. 2218	Valitsuse töötaja mõrv',
        fine = 30000,
        jail = 60,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [55] = {
        label = 'SakS. 2219	Valitsuse töötaja mõrvale kaasaaitamine',
        fine = 25000,
        jail = 60,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [56] = {
        label = 'SakS. 2221	Julgeoleku ametniku väärkohtlemine',
        fine = 5000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [57] = {
        label = 'SakS. 2302	Vargus',
        fine = 3000,
        jail = 15,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [58] = {
        label = 'SakS. 2303	Varguses kaasaaitamine',
        fine = 1500,
        jail = 15,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [59] = {
        label = 'SakS. 2304	Sõiduki vargus',
        fine = 2000,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [60] = {
        label = 'SakS. 2305	Sõiduki varguses kaasaaitamine',
        fine = 1500,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [61] = {
        label = 'SakS. 2306	Alarmsõiduki vargus',
        fine = 15000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [62] = {
        label = 'SakS. 2307	Alarmsõiduki vargusel kaasaaitamine',
        fine = 10000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [63] = {
        label = 'SakS. 2309	Sõiduki tahlik hävitamine',
        fine = 4000,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [64] = {
        label = 'SakS. 2313	Panga rööv (Fleeca)',
        fine = 15000,
        jail = 40,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [65] = {
        label = 'SakS. 2314	Pacific Standard panga rööv',
        fine = 20000,
        jail = 45,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [66] = {
        label = 'SakS. 2315	Vangelico juveelipoe rööv',
        fine = 10000,
        jail = 40,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0
    },
    [67] = {
        label = 'SakS. 2318	Varastatud asjade omamine',
        fine = 2000,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [68] = {
        label = 'SakS. 2319	Varastatud isikutunnistuse omamine',
        fine = 2000,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [69] = {
        label = 'SakS. 2320	Varastatud esemete/vara müük',
        fine = 2000,
        jail = 15,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [70] = {
        label = 'SakS. 2321	Varastatud vara ostmine',
        fine = 1500,
        jail = 15,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [71] = {
        label = 'SakS. 2322	Prioriteetse sõiduki vargus',
        fine = 5000,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [72] = {
        label = 'SakS. 2323	Prioriteetse sõiduki vargus kaasaaitamine',
        fine = 3000,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0
    },
    [73] = {
        label = 'SakS. 2324	ATM rööv',
        fine = 3000,
        jail = 15,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0
    },
    [74] = {
        label = 'SakS. 2325	Relvalao rööv (bobcat)',
        fine = 10000,
        jail = 40,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0
        
    },
    [75] = {
        label = 'SakS. 2326	Kõrgklassi riietepoe rööv',
        fine = 7000,
        jail = 40,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0
        
    },
    [76] = {
        label = 'SakS. 2401	Identiteedivargus',
        fine = 5000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [77] = {
        label = 'SakS. 2402	Esitlemine kellegi teisena',
        fine = 2500,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [78] = {
        label = 'SakS. 2403	Julgeoleku ohvitserina esitlemine',
        fine = 10000,
        jail = 35,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [79] = {
        label = 'SakS. 2405	EMSina esitlemine',
        fine = 10000,
        jail = 35,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [80] = {
        label = 'SakS. 2406	Väljapressimine',
        fine = 3000,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [81] = {
        label = 'SakS. 2407	Pettus',
        fine = 5000,
        jail = 15,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [82] = {
        label = 'SakS. 2409	Sõiduki registreerimispettus',
        fine = 5000,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [83] = {
        label = 'SakS. 2411	Rahapesu',
        fine = 20000,
        jail = 50,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [84] = {
        label = 'SakS. 2412	Omastamine',
        fine = 5000,
        jail = 15,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [85] = {
        label = 'SakS. 2503	Looma väärkohtlemine',
        fine = 4000,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [86] = {
        label = 'SakS. 2505	Mäss',
        fine = 5000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [87] = {
        label = 'SakS. 2506	Vandalism',
        fine = 5000,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [88] = {
        label = 'SakS. 2507	Süütamine',
        fine = 5000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [89] = {
        label = 'SakS. 2508	Riigivara lõhkumine',
        fine = 8000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [90] = {
        label = 'SakS. 2509	Valituse vara hävitamine',
        fine = 1500,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [91] = {
        label = 'SakS. 2510	Avaliku asutuse häirimine',
        fine = 5000,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [92] = {
        label = 'SakS. 2511	911 süsteemi väärkasutamine',
        fine = 3500,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [93] = {
        label = 'SakS. 2512	Vale väljakutse',
        fine = 3500,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [94] = {
        label = 'SakS. 2514	Ahistamine',
        fine = 10000,
        jail = 60,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [95] = {
        label = 'SakS. 2515	Jälitamine',
        fine = 5000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [96] = {
        label = 'SakS. 2516	Õigusmõistmise takistamine',
        fine = 10000,
        jail = 60,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [97] = {
        label = 'SakS. 2518	Ametniku takistamine',
        fine = 7000,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [98] = {
        label = 'SakS. 2519	Altkäemaksu pakkumine',
        fine = 5000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [99] = {
        label = 'SakS. 2520	Vahialt põgenemine',
        fine = 8000,
        jail = 40,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [100] = {
        label = 'SakS. 2521	Vahialt põgenemine kaasaaitamine',
        fine = 7000,
        jail = 40,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [101] = {
        label = 'SakS. 2522	Vanglast põgenemise katse',
        fine = 8000,
        jail = 35,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [102] = {
        label = 'SakS. 2523	Vanglast põgenemine',
        fine = 10000,
        jail = 60,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [103] = {
        label = 'SakS. 2524	Tagaotsitava isiku varjamine',
        fine = 8000,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [104] = {
        label = 'SakS. 2525	Tõendite rikkumine',
        fine = 10000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [105] = {
        label = 'SakS. 2526	Valeütluste andmine',
        fine = 10000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [106] = {
        label = 'SakS. 2527	Arvete/Trahvide mitte maksmine',
        fine = 0,
        jail = 60,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [107] = {
        label = 'SakS. 2532	Arreteerimisele vastuhakk',
        fine = 5000,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [108] = {
        label = 'SakS. 2601	Tulirelva omamine (1.klass)',
        fine = 5000,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [109] = {
        label = 'SakS. 2602	Tulirelva omamine (2.klass)',
        fine = 8000,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [110] = {
        label = 'SakS. 2603	Tulirelva omamine (3.klass)',
        fine = 10000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [111] = {
        label = 'SakS. 2604	Relva lisaseadmete omamine',
        fine = 3000,
        jail = 10,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [112] = {
        label = 'SakS. 2605	Tulirelva kuritegelik kasutamine',
        fine = 10000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [113] = {
        label = 'SakS. 2606	Tulirelva müük (1.klass)',
        fine = 30000,
        jail = 15,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [114] = {
        label = 'SakS. 2607	Tulirelva müük (2.klass)',
        fine = 40000,
        jail = 25,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [115] = {
        label = 'SakS. 2608	Tulirelva müük (3.klass)',
        fine = 50000,
        jail = 35,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [116] = {
        label = 'SakS. 2609	Relvakaubandus',
        fine = 100000,
        jail = 50,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [117] = {
        label = 'SakS. 2610	Relvade varumine',
        fine = 50000,
        jail = 50,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [118] = {
        label = 'SakS. 2611	Lõhkeaine omamine',
        fine = 8000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [119] = {
        label = 'SakS. 2612	Lõhkeaine kuritegelik kasutamine',
        fine = 9000,
        jail = 40,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [120] = {
        label = 'SakS. 2613	Terrorism',
        fine = 50000,
        jail = 60,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [121] = {
        label = 'SakS. 2615	Kuritegelikus grupperingus tegutsemine',
        fine = 30000,
        jail = 60,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [122] = {
        label = 'SakS. 2702	Narkootikumide omamine koguses 11g - 40g',
        fine = 3500,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [123] = {
        label = 'SakS. 2703	Narkootikumide omamine üle 41g',
        fine = 5000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [124] = {
        label = 'SakS. 2704	Narkootikumide müük',
        fine = 5000,
        jail = 20,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [125] = {
        label = 'SakS. 2705	Narkootikumide käitlemine',
        fine = 7000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [126] = {
        label = 'SakS. 2706	Narkootikumide kaubandus',
        fine = 5000,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [127] = {
        label = 'SakS. 2707	Ravimi ebaseadulik käitlemine',
        fine = 3500,
        jail = 30,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [128] = {
        label = 'SakS. 2710	Inimkaubandus',
        fine = 10000,
        jail = 60,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    },
    [129] = {
        label = 'SakS. 2711	Inimkaubanduses kaasaaitamine',
        fine = 10000,
        jail = 60,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
        
    },
    [130] = {
        label = 'Distsiplinaar karistus',
        fine = 0,
        jail = 60,
        color = 'red-800', -- sky-800, red-800, yellow-700
        points = 0 
    }
}

cfg.intensives = {
    {
        name = "central",
        coords = vec3(342.0, -1420.3, 38.55),
        size = vec3(101.5, 90, 21.5),
        rotation = 50.0,
    }
}

cfg.factionCertificates = {
    ['corrections'] = {
        ['level_1'] = {
            label = 'Tase 1'
        },

        ['level_2'] = {
            label = 'Tase 2'
        },

        ['level_3'] = {
            label = 'Tase 3'
        },

        ['level_4'] = {
            label = 'Tase 4'
        },

        ['level_5'] = {
            label = 'Tase 5'
        },

        ['level_6'] = {
            label = 'Tase 6'
        },
        
        ['level_metro'] = {
            label = 'Tase Metro'
        },

        ['level_heli'] = {
            label = 'Tase Heli'
        },

        ['class_1'] = {
            label = 'Klass 1'
        },

        ['class_2'] = {
            label = 'Klass 2'
        },

        ['class_3'] = {
            label = 'Klass 3'
        },

        ['class_4'] = {
            label = 'Klass 4'
        },
    },
    ['metro'] = {
        ['level_1'] = {
            label = 'Tase 1'
        },

        ['level_2'] = {
            label = 'Tase 2'
        },

        ['level_3'] = {
            label = 'Tase 3'
        },

        ['level_4'] = {
            label = 'Tase 4'
        },

        ['level_5'] = {
            label = 'Tase 5'
        },

        ['level_6'] = {
            label = 'Tase 6'
        },
        
        ['level_metro'] = {
            label = 'Tase Metro'
        },

        ['level_heli'] = {
            label = 'Tase Heli'
        },

        ['class_1'] = {
            label = 'Klass 1'
        },

        ['class_2'] = {
            label = 'Klass 2'
        },

        ['class_3'] = {
            label = 'Klass 3'
        },

        ['class_4'] = {
            label = 'Klass 4'
        },
    },
    ['park'] = {
        ['level_1'] = {
            label = 'Tase 1'
        },

        ['level_2'] = {
            label = 'Tase 2'
        },

        ['level_3'] = {
            label = 'Tase 3'
        },

        ['level_4'] = {
            label = 'Tase 4'
        },

        ['level_5'] = {
            label = 'Tase 5'
        },

        ['level_6'] = {
            label = 'Tase 6'
        },
        
        ['level_metro'] = {
            label = 'Tase Metro'
        },

        ['level_heli'] = {
            label = 'Tase Heli'
        },

        ['class_1'] = {
            label = 'Klass 1'
        },

        ['class_2'] = {
            label = 'Klass 2'
        },

        ['class_3'] = {
            label = 'Klass 3'
        },

        ['class_4'] = {
            label = 'Klass 4'
        },
    },
    ['com'] = {
        ['level_1'] = {
            label = 'Tase 1'
        },

        ['level_2'] = {
            label = 'Tase 2'
        },

        ['level_3'] = {
            label = 'Tase 3'
        },

        ['level_4'] = {
            label = 'Tase 4'
        },

        ['level_5'] = {
            label = 'Tase 5'
        },

        ['level_6'] = {
            label = 'Tase 6'
        },
        
        ['level_metro'] = {
            label = 'Tase Metro'
        },

        ['level_heli'] = {
            label = 'Tase Heli'
        },

        ['class_1'] = {
            label = 'Klass 1'
        },

        ['class_2'] = {
            label = 'Klass 2'
        },

        ['class_3'] = {
            label = 'Klass 3'
        },

        ['class_4'] = {
            label = 'Klass 4'
        },
    },
    ['state'] = {
        ['level_1'] = {
            label = 'Tase 1'
        },

        ['level_2'] = {
            label = 'Tase 2'
        },

        ['level_3'] = {
            label = 'Tase 3'
        },

        ['level_4'] = {
            label = 'Tase 4'
        },

        ['level_5'] = {
            label = 'Tase 5'
        },

        ['level_6'] = {
            label = 'Tase 6'
        },
        
        ['level_metro'] = {
            label = 'Tase Metro'
        },

        ['level_heli'] = {
            label = 'Tase Heli'
        },

        ['class_1'] = {
            label = 'Klass 1'
        },

        ['class_2'] = {
            label = 'Klass 2'
        },

        ['class_3'] = {
            label = 'Klass 3'
        },

        ['class_4'] = {
            label = 'Klass 4'
        },
    },
    ['sheriff'] = {
        ['level_1'] = {
            label = 'Tase 1'
        },

        ['level_2'] = {
            label = 'Tase 2'
        },

        ['level_3'] = {
            label = 'Tase 3'
        },

        ['level_4'] = {
            label = 'Tase 4'
        },

        ['level_5'] = {
            label = 'Tase 5'
        },

        ['level_6'] = {
            label = 'Tase 6'
        },
        
        ['level_metro'] = {
            label = 'Tase Metro'
        },

        ['level_heli'] = {
            label = 'Tase Heli'
        },

        ['class_1'] = {
            label = 'Klass 1'
        },

        ['class_2'] = {
            label = 'Klass 2'
        },

        ['class_3'] = {
            label = 'Klass 3'
        },

        ['class_4'] = {
            label = 'Klass 4'
        },
    },
    ['ranger'] = {
        ['level_1'] = {
            label = 'Tase 1'
        },

        ['level_2'] = {
            label = 'Tase 2'
        },

        ['level_3'] = {
            label = 'Tase 3'
        },

        ['level_4'] = {
            label = 'Tase 4'
        },

        ['level_5'] = {
            label = 'Tase 5'
        },

        ['level_6'] = {
            label = 'Tase 6'
        },
        
        ['level_metro'] = {
            label = 'Tase Metro'
        },

        ['level_heli'] = {
            label = 'Tase Heli'
        },

        ['class_1'] = {
            label = 'Klass 1'
        },

        ['class_2'] = {
            label = 'Klass 2'
        },

        ['class_3'] = {
            label = 'Klass 3'
        },

        ['class_4'] = {
            label = 'Klass 4'
        },
    },
    ['police'] = {
        ['level_1'] = {
            label = 'Tase 1'
        },

        ['level_2'] = {
            label = 'Tase 2'
        },

        ['level_3'] = {
            label = 'Tase 3'
        },

        ['level_4'] = {
            label = 'Tase 4'
        },

        ['level_5'] = {
            label = 'Tase 5'
        },

        ['level_6'] = {
            label = 'Tase 6'
        },
        
        ['level_metro'] = {
            label = 'Tase Metro'
        },

        ['level_heli'] = {
            label = 'Tase Heli'
        },

        ['class_1'] = {
            label = 'Klass 1'
        },

        ['class_2'] = {
            label = 'Klass 2'
        },

        ['class_3'] = {
            label = 'Klass 3'
        },

        ['class_4'] = {
            label = 'Klass 4'
        },
    },
}

cfg.cellBlocks = {
    {
        name = "mrpd kongid",
        coords = vec3(629.4, -0.2, 75.6),
        size = vec3(18.5, 11.45, 3.25),
        rotation = 340.0,
    },
    {
        name = "lamesa",
        coords = vec3(-3154.57, 1129.0, 17.0),
        size = vec3(10.0, 13.0, 4.0),
        rotation = 335.0,
    },
    {
        name = "davispd",
        coords = vec3(361.15, -1609.15, 29.6),
        size = vec3(9.0, 7.25, 2.65),
        rotation = 320.75,
    },
    {
        name = "ranger station kongid",
        coords = vec3(380.0, 796.0, 187.0),
        size = vec3(7.0, 6.0, 6.0),
        rotation = 0.0,
    },
    {
        name = "SSPD kongid",
        coords = vec3(1809.0, 3677.0, 34.0),
        size = vec3(5.0, 10.0, 4.0),
        rotation = 30.0,
    },
    {
        name = "PBPD kongid",
        coords = vec3(-446.0, 6015.0, 28.0),
        size = vec3(10.0, 9.0, 4.0),
        rotation = 45.0,
    },
    {
        name = "vangla ärasaatmistpunkt",
        coords = vec3(1839.0, 2594.0, 46.0),
        size = vec3(6.0, 5.0, 5),
        rotation = 0.0,
    },
    {
        name = "fib",
        coords = vec3(135.0, -766.0, 242.0),
        size = vec3(18.0, 6.0, 4.0),
        rotation = 335.0,
    },
}

cfg.cand = {
    {
        name = "mrpd cand",
        coords = vec3(445.106, -980.676, 30.713),
        size = vec3(2, 2, 2),
        rotation = 0,
    },

}