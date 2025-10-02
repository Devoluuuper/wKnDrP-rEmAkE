cfg = {}

cfg.language = 'et'

cfg.exchangeLockpick = false -- requires item "lockpick" to have "usages" metadata

cfg.locations = {
    ['default'] = {
        name = 'Robert Son',
        model = `a_m_y_genstreet_01`,
        lockpick = true,
        pos = vec4(-5.242, 0.441, 71.214, 340.068),
        blip = true,
        tasks = {
            {
                context = 'Tervitus! Kas sa saaksid mind aidata? Konkreetsemalt, kas tooksid mulle kohalikust tööriistamarketist koti väetist?',
                location = vec3(28.575826644897, -1769.5252685547, 29.566284179688),
                
                items = {
                    ['fertilizer'] = 1,
                },

				reward = {
                    name = 'lockpick',
                    count = 1
                }
            },

            {
                context = 'Töö kiire ja korralik! Kas on palju palutud, et tooksid mulle poest ühe paki suitsu?',
                location = vec3(-707.9009, -914.5320, 19.2156),
                
                items = {
                    ['cigarett_pack'] = 1,
                },

				reward = {
                    name = 'pickaxe',
                    count = 1
                }
            },

			{
                context = 'Suurepärane. Kas saaksid mind veel ühe teenega aidata? Ole hea, sebi mulle üks vasemaak, ning üks tinamaak. Kirka viska rendika pagasnikusse seniks, kuidas sa muidu sõidad.',
                location = vec3(2958.0659179688, 2785.4240722656, 40.923095703125),
                items = {
                    ['tin_ore'] = 1,
                    ['copper_ore'] = 1,
                },

				reward = {
                    name = 'bronze_bar',
                    count = 1
                }
            },

			{
                context = 'Väga hea. Ole hea, mine tee mulle sellest pronkskangist kaks pronksitahvlit. Sealsamas saaksid ka ise sulatada, aga mul juhtus juba üks kang valmis olema.',
                location = vec3(1079.2484130859, -1998.6197509766, 30.914306640625),

                items = {
                    ['bronze_plate'] = 2,
                },

				reward = {
                    name = 'fishingrod',
                    count = 1
                }
            },
			{
                context = 'Noonii! Kuule, kui sa juba majandad, ole hea mine püüa mulle natukene värsket kala õhtuks. Kahest mudakalast peaks piisama.',
                location = vec3(-344.33407592773, 3007.1076660156, 15.9853515625),
                
                items = {
                    ['mudfish'] = 2,
                },

				reward = {
                    name = 'tablet',
                    count = 1
                }
            },
			{
                context = 'Hei! Kui sa mind veel natukene aitad, näitan sulle mida vinget selle tahvliga teha saad! Kas tooksid mulle uue jahivarustuse? Viimase viisid vargad minema.',
                location = vec3(-1490.9011230469, 4981.9384765625, 63.316528320312),

                items = {
                    ['hunting_gear'] = 1,
                },

				reward = {
                    name = 'boosting_stick',
                    count = 1
                }
            },

			{
                context = 'Hea töö! Kuidas rakendus meeldib? Kui huvi on, sebin sulle veel mõned rakendused. Kuid sellest räägime hiljem. Enne oleks mul tarvis ühte puuvillaseemet.',
                location = vec3(2473.6220703125, 4449.2573242188, 35.362670898438),

                items = {
                    ['cotton_seed'] = 1,
                },

				reward = {
                    name = 'cotton',
                    count = 2
                }
            }, 

            {
                context = 'Said väga hästi hakkama. Nüüd mine tee sellest puuvillast mulle palun uued bokserid.',
                location = vec3(712.65496826172, -959.76263427734, 30.391967773438),

                items = {
                    ['boxers'] = 1,
                },

				reward = {
                    name = 'WEAPON_HATCHET',
                    count = 1
                }
            },

            {
                context = 'Väga hea töö! Nüüd aga, vajan ma kahte männipakku, kas saaksid mind sellega aidata? Ära neid saekaatris laudadeks lase, mul on ainult pakkusid tarvis.',
                location = vec3(-538.03515625, 5458.8920898438, 69.129638671875),


                items = {
                    ['pine_stump'] = 2,
                },

				reward = {
                    name = 'panning_bowl',
                    count = 1
                }
            },

            {
                context = 'Suurepärane töö, nagu alati. Nüüd vajan ma ühte hõbeda tükikest, kui võimalik.',
                location = vec3(-1658.3472900391, 1658.0703125, 145.64465332031),

                items = {
                    ['silver_nugget'] = 1,
                },

				reward = {
                    name = 'droppy_stick',
                    count = 1
                }
            },

            {
                context = 'Hea töö. Mul oleks tarvis, et sa mulle ühe kupongi sebid. Tavaliselt toovad neid mulle elektrikud ja pakivedajad- kuid olen kuulnud, et viimasel ajal saavad neid ka prügivedajad.',
                location = vec3(-354.9098815918, -1515.5340576172, 27.712768554688),

                items = {
                    ['coupon'] = 1,
                },

				reward = {
                    name = 'WEAPON_CROWBAR',
                    count = 1
                }
            },

            {
                context = 'Kas oled autodega kõva käpp? Mul oleks vaja natukene vanarauda, kas tooksid ära? Sulatustehasest saad endale sõrgkangi osta.',
                location = vec3(2384.0439453125, 3077.7099609375, 48.16845703125),

                items = {
                    ['metal'] = 1,
                },

				reward = {
                    name = 'selling_stick',
                    count = 1
                }
            }
        }
    }
}

cfg.translations = {
    ['en'] = {
        -- Messages
        ['not_great_time'] = 'You feel that it is not the right time for this activity...',
        ['nice_work'] = 'It was a pleasure to work together!',
        ['no_need'] = 'I dont need you right now!',
        ['bring_me'] = 'Bring me: %s',
        ['exchange'] = 'Lockpicks',
        ['enough_exchange'] = 'You dont have enough broken multitools, bring more! You need at least three!',
        ['not_needed'] = 'You dont have all the items you need!',
        ['exchange_log'] = 'Exchanged %s lockpicks to %s lockpicks.',
        ['delivery_log'] = 'Finished [NPC: %s] job [ID: %s]'
    },

    ['et'] = {
        -- Messages
        ['not_great_time'] = 'Tunned, et antud tegevuse jaoks ei ole õige aeg...',
        ['nice_work'] = 'Oli meeldiv koostööd teha!',
        ['no_need'] = 'Mul pole sind hetkel vaja!',
        ['bring_me'] = 'Too mulle: %s',
        ['exchange'] = 'Multitööriistad',
        ['enough_exchange'] = 'Sul ei ole piisavalt katkiseid multitööriistu, too juurde! Vajad vähemalt kolme!',
        ['not_needed'] = 'Teil ei ole kõiki vajalikke esemeid!',
        ['exchange_log'] = 'Vahetas %s muukrauda %s vastu.',
        ['delivery_log'] = 'Lõpetas [NPC: %s] tööotsa [ID: %s]'
    }
}