var open = false;
var currentMenu = null;
var hairColors = null;
var makeupColors = null;
let headBlend = {};
var currentCamera = null;

var isService = false;

let whitelisted = {
    male:[
    ],
    female:[
    ]
};

/*whitelisted["male"] = {
    jackets:[19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,35,67,68,70,71,73,74,76,81,82,83,105,149,205],
    undershirts:[16,17,19,20,22,24,25,26,28,29,33,34,35,36,39,40,42,57,58,102,115,116,166,173,174],
    pants:[21,22,23,24,25,28,35],
    decals:[1,2,3,4,5,6,58],
    vest:[1,2,7,10,11,12,13,14,15,16,17,18,19,20,21,22,23],
    hats:[20,21,24,25,26,27,30,33,34,50,90,166],
}

whitelisted["female"] = {
    jackets:[17,18,19,20,21,22,23,24,25,26,27,28,29,30,67,68,102,157],
    undershirts:[16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,66,67,68,70,71,72,78,79,105,143,198],
    pants:[18,19,20,21,22,23,24,39],
    vest:[8,9,11,12,13,14,15,16,17,18,19,21,22],
    hats:[20,21,23,24,25,26,28,29,31,37,39,75,77,153],
}*/

const throttle = (func, limit) => {
    let inThrottle
    return (...args) => {
        if (!inThrottle) {
            func(...args)
            inThrottle = setTimeout(() => inThrottle = false, limit)
        }
    }
}

$(function () {
    window.addEventListener('message', function (event) {
        if (event.data.type == "enableclothesmenu") {
            open = event.data.enable;
            if (open) {
                currentMenu = event.data.menu
                isService = event.data.isService;

                setTimeout(() => {
                    document.getElementById(currentMenu).style.display = "flex";
                }, 1);
            } else {
                setTimeout(() => {
                    document.getElementById(currentMenu).style.display = "none";
                }, 1);
            }
        }

        // console.log(event.data.type)

        if (event.data.type == "colors") {
            hairColors = createPalette(event.data.hairColors);
            makeupColors = createPalette(event.data.makeupColors);
            AddPalettes();
            SetHairColor(event.data.hairColor);
        }

        if (event.data.type == "menutotals") {
            let drawTotal = event.data.drawTotal;
            let propDrawTotal = event.data.propDrawTotal;
            let textureTotal = event.data.textureTotal;
            let headoverlayTotal = event.data.headoverlayTotal;
            let skinTotal = event.data.skinTotal;
            UpdateTotals(drawTotal, propDrawTotal, textureTotal, headoverlayTotal, skinTotal);
        }
        if (event.data.type == "clothesmenudata") {
            let drawables = event.data.drawables;
            let props = event.data.props;
            let drawtextures = event.data.drawtextures;
            let proptextures = event.data.proptextures;
            let skin = event.data.skin;
            UpdateInputs(drawables, props, drawtextures, proptextures, skin);
        }

        if (event.data.type == "barbermenu") {
            headBlend = event.data.headBlend;
            SetupHeadBlend();
            SetupHeadOverlay(event.data.headOverlay);
            SetupHeadStructure(event.data.headStructure);
        }

        if (event.data.type == "tattoomenu") {
            headBlend = event.data.headBlend;
            SetupTatTotals(event.data.totals)
            SetupTatValues(event.data.values)
        }
    });

    $('.save').on('click', function() {
        CloseMenu(true)
    })


    $('.discard').on('click', function() {
        CloseMenu(false)
    })

    function CloseMenu(save) {
        $.post('https://kk-clothing/escape', JSON.stringify({save:save}));
    }

    $(document).on('contextmenu', function() {
        $.post('https://kk-clothing/togglecursor', JSON.stringify({}));
    })

    function UpdateTotals(drawTotal, propDrawTotal, textureTotal, headoverlayTotal, skinTotal) {
        for (var i = 0; i < Object.keys(drawTotal).length; i++) {
            if (drawTotal[i][0] == "hair") {
                $('.hair').each(function() {
                    $(this).find('.total-number').eq(0).text(drawTotal[i][1]);
                })
            }
            $("#" + drawTotal[i][0]).find('.total-number').eq(0).text(drawTotal[i][1]);
        }

        for (var i = 0; i < Object.keys(propDrawTotal).length; i++) {
            $("#" + propDrawTotal[i][0]).find('.total-number').eq(0).text(propDrawTotal[i][1]);
        }

        for (const key of Object.keys(textureTotal)) {
            $("#" + key).find('.total-number').eq(1).text(textureTotal[key]);
        }

        for (const key of Object.keys(headoverlayTotal)) {
            $("#" + key).find('.total-number').eq(0).text(headoverlayTotal[key]);
        }

        let skinConts = $('#skins').find('.total-number');
        skinConts.eq(0).text(skinTotal[0]+1);
        skinConts.eq(1).text(skinTotal[1]+1);
    }

    function UpdateInputs(drawables, props, drawtextures, proptextures, skin) {
        for (var i = 0; i < Object.keys(drawables).length; i++) {
            if (drawables[i][0] == "hair") {
                $('.hair').each(function() {
                    $(this).find('.input-number').eq(0).val(drawables[i][1]);
                })
            }
            $("#" + drawables[i][0]).find('.input-number').eq(0).val(drawables[i][1]);
        }

        for (var i = 0; i < Object.keys(props).length; i++) {
            $("#" + props[i][0]).find('.input-number').eq(0).val(props[i][1]);
        }

        for (var i = 0; i < Object.keys(drawtextures).length; i++) {
            $("#" + drawtextures[i][0]).find('.input-number').eq(1).val(drawtextures[i][1]);
        }
        for (var i = 0; i < Object.keys(proptextures).length; i++) {
            $("#" + proptextures[i][0]).find('.input-number').eq(1).val(proptextures[i][1]);
        }

        if (skin['name'] == "skin_male") {
            $('#skin_male').val(skin['value'])
            if($('#skin_female').val() != 0){$('#skin_female').val(0)}
        }
        else {
            $('#skin_female').val(skin['value'])
            if($('#skin_male').val() != 0){$('#skin_male').val(0)}
        }
    }

    $('.button-left').on('click', function () {
        var input = $(this).parent().find('.input-number')
        input.val(parseInt(input.val()) - 1)
        inputChange(input,false)
    })
    $('.button-right').on('click', function () {
        var input = $(this).parent().find('.input-number')
        input.val(parseInt(input.val()) + 1)
        inputChange(input,true)
    })

    $('.input-number').on('input', function () {
        inputChange($(this),true)
    })

    $('.input-number').on('mousewheel', function () {})

    function inputChange(ele,inputType) {
        var inputs = $(ele).parent().parent().parent().parent().find('.input-number');
        var total = 0;

        if (currentMenu == 'clothesmenu' || $(ele).parents('.panel').hasClass('hair')) {
            if (ele.is(inputs.eq(0))) {
                total = inputs.eq(0).parent().parent().parent().parent().parent().find('.total-number').eq(0).text();
                inputs.eq(1).val(0);
            } else {
                total = inputs.eq(1).parent().parent().parent().parent().parent().find('.total-number').eq(1).text();
            }

            if (parseInt($(ele).val()) > parseInt(total)-1) {
                $(ele).val(-1)
            } else if (parseInt($(ele).val()) < -1) {
                $(ele).val(parseInt(total)-1)
            }
            if (ele.is(inputs.eq(1)) && $(ele).val() == -1) {
                $(ele).val(0)
            }

            if(!isService && ($('#skin_female').val() == 1 || $('#skin_male').val() == 1)) {
                let clothingName = $(ele).parents('.panel').attr('id');
                let clothingID = parseInt($(ele).val());
                let isNotValid = true
                let gender = "male";
                if($('#skin_female').val() >= 1 && $('#skin_male').val() == 0)
                    gender = "female";

                if(ele.is(inputs.eq(0)) && whitelisted[gender][clothingName]){
                    while (isNotValid) {
                        if(whitelisted[gender][clothingName].indexOf(clothingID) > -1 ){
                            isNotValid = true
                            if(inputType){clothingID++;}else{clothingID--;}

                        }
                        else
                        {
                            isNotValid = false;
                        }
                    }
                }
                $(ele).val(clothingID)
            }

            if ($(ele).parents('.panel').attr('id') == "skins") {
                $.post('https://kk-clothing/setped', JSON.stringify({
                    "name": $(ele).attr('id'),
                    "value": $(ele).val()
                }))
            }
            else {
                let nameId = "";
                if (currentMenu == 'barbermenu')
                    nameId = "hair"
                else
                    nameId = $(ele).parent().parent().parent().parent().parent().attr('id').split('#')[0]

                $.post('https://kk-clothing/updateclothes', JSON.stringify({
                    "name": nameId,
                    "value": inputs.eq(0).val(),
                    "texture": inputs.eq(1).val()
                })).done(function (data) {
                    inputs.eq(1).parent().parent().parent().parent().parent().find('.total-number').eq(1).text(data);
                });
            }
        }
        else if (currentMenu == 'barbermenu') {
            if (ele.is(inputs.eq(0))) {
                total = inputs.eq(0).parent().parent().parent().parent().parent().find('.total-number').eq(0).text();
            } else {
                total = inputs.eq(1).parent().parent().parent().parent().parent().find('.total-number').eq(1).text();
            }

            var value = parseInt($(ele).val(), 10);
            total = parseInt(total, 10) - 1;

            if (value > 255) {
                value = 0;
            }
            else if (value === 254) {
                value = total;
            }
            else if (value < 0 || value > total) {
                value = 255;
            }

            $(ele).val(value);

            var activeID = $('#barbermenu').find('.active').attr('id'); 
            switch (activeID) {
                case "button-inheritance":
                    SaveHeadBlend();
                    break;
                case "button-appear":
                case "button-hair":
                case "button-features":
                    SaveHeadOverlay(ele);
                    break;
            }
        }
        else if (currentMenu == 'tattoomenu') {
            total = inputs.eq(0).parent().parent().parent().parent().parent().find('.total-number').eq(0).text();
            if (parseInt($(ele).val()) > parseInt(total)-1) {
                $(ele).val(0)
            } else if (parseInt($(ele).val()) < 0) {
                $(ele).val(parseInt(total)-1)
            }
            let tats = {}
            let categEles = $('#tattoos').children()
            categEles.each(function () {
                tats[$(this).attr('id')] = $(this).find('.input-number').val();
            })
            $.post('https://kk-clothing/settats', JSON.stringify({tats}))
        }
    }

    $('input[type=range]').on('input', function() {
        if (currentMenu == 'barbermenu') {
            var activeID = $('#barbermenu').find('.active').attr('id');
            switch (activeID) {
                case "button-inheritance":
                    SaveHeadBlend();
                    break;
                case "button-faceshape":
                    SaveFaceShape($(this));
                    break;
                case "button-appear":
                case "button-hair":
                case "button-features":
                    SaveHeadOverlay($(this));
                    break;
            }
        }
    })

    function toggleCam(ele) {
        if (currentCamera == ele[0]) {
            currentCamera = null;
        } else {
            currentCamera = ele[0];
        }
    }

    $('.tog_head').on('click', function() {
        toggleCam($(this));
        $.post('https://kk-clothing/switchcam', JSON.stringify({name: 'head'}))
    })
    $('.tog_torso').on('click', function() {
        toggleCam($(this));
        $.post('https://kk-clothing/switchcam', JSON.stringify({name: 'torso'}))
    })
    $('.tog_leg').on('click', function() {
        toggleCam($(this));
        $.post('https://kk-clothing/switchcam', JSON.stringify({name: 'leg'}))
    })
    $('.tog_cam').on('click', function() {
        toggleCam($(this));
        $.post('https://kk-clothing/switchcam', JSON.stringify({name: 'cam'}))
    })

    $('.tog_hat').on('click', function() {
        $.post('https://kk-clothing/toggleclothes', JSON.stringify({name: "hats"}))
    })
    $('.tog_glasses').on('click', function() {
        $.post('https://kk-clothing/toggleclothes', JSON.stringify({name: "glasses"}))
    })
    $('.tog_tops').on('click', function() {
        // dont look at this :)
        $.post('https://kk-clothing/toggleclothes', JSON.stringify({name: "jackets"}))
        $.post('https://kk-clothing/toggleclothes', JSON.stringify({name: "undershirts"}))
        $.post('https://kk-clothing/toggleclothes', JSON.stringify({name: "torsos"}))
        $.post('https://kk-clothing/toggleclothes', JSON.stringify({name: "vest"}))
        $.post('https://kk-clothing/toggleclothes', JSON.stringify({name: "bags"}))
        $.post('https://kk-clothing/toggleclothes', JSON.stringify({name: "neck"}))
        $.post('https://kk-clothing/toggleclothes', JSON.stringify({name: "decals"}))
    })
    $('.tog_legs').on('click', function() {
        $.post('https://kk-clothing/toggleclothes', JSON.stringify({name: "legs"}))
    })
    $('.tog_mask').on('click', function() {
        $.post('https://kk-clothing/toggleclothes', JSON.stringify({name: "masks"}))
    })

    $('#reset').on('click', function() {
        $.post('https://kk-clothing/resetped', JSON.stringify({}))
    })


    window.addEventListener("keydown", throttle(function (ev) {
        var input = $(ev.target);
        var num = input.hasClass('input-number');
        var _key = false;
        if (ev.which == 39 || ev.which == 68) {
            if (num === false) {
                _key = "left"
            }
            else if (num) {
                input.val(parseInt(input.val()) + 1)
                inputChange(input,true)
            }
        }
        if (ev.which == 37 || ev.which == 65) {
            if (num === false) {
                _key = "right"
            }
            else if (num) {
                input.val(parseInt(input.val()) - 1)
                inputChange(input,false)
            }
        }

        if (_key) {
            $.post('https://kk-clothing/rotate', JSON.stringify({key: _key}))
        }
    }, 50))

    // Barber
    function SetHairColor(data) {
        $('.hair').each(function() {
            var palettes = $(this).find('.color_palette_container').eq(0).find('.color_palette')
            $(palettes[data[0]]).addClass('active')
            palettes = $(this).find('.color_palette_container').eq(1).find('.color_palette')
            $(palettes[data[1]]).addClass('active')
        })
    }

    function SetupHeadBlend() {
        if (headBlend == null) return;
        var sf = $('#shapeFirstP');
        var ss = $('#shapeSecondP');
        var st = $('#shapeThirdP');

        sf.find('.input-number').eq(0).val(headBlend['shapeFirst'])
        sf.find('.input-number').eq(1).val(headBlend['skinFirst'])
        ss.find('.input-number').eq(0).val(headBlend['shapeSecond'])
        ss.find('.input-number').eq(1).val(headBlend['skinSecond'])
        st.find('.input-number').eq(0).val(headBlend['shapeThird'])
        st.find('.input-number').eq(1).val(headBlend['skinThird'])

        $('#fmix').find('input').val(parseFloat(headBlend['shapeMix']) * 100)
        $('#smix').find('input').val(parseFloat(headBlend['skinMix']) * 100)
        $('#tmix').find('input').val(parseFloat(headBlend['thirdMix']) * 100)
    }

    function SaveHeadBlend() {
        headBlend = {}
        headBlend["shapeFirst"] = $("#shapeFirst").val()
        headBlend["shapeSecond"] = $("#shapeSecond").val()
        headBlend["shapeThird"] = $("#shapeThird").val()
        headBlend["skinFirst"] = $("#skinFirst").val()
        headBlend["skinSecond"] = $("#skinSecond").val()
        headBlend["skinThird"] = $("#skinThird").val()
        headBlend["shapeMix"] = $("#shapeMix").val()
        headBlend["skinMix"] = $("#skinMix").val()
        headBlend["thirdMix"] = $("#thirdMix").val()
        $.post('https://kk-clothing/saveheadblend', JSON.stringify(headBlend))
    }

    function SaveFaceShape(ele) {
        $.post('https://kk-clothing/savefacefeatures', JSON.stringify({name: ele.attr('data-value'), scale: ele.val()}))
    }

    function SetupHeadStructure(data) {
        let sliders = $('#faceshape').find('.slider-range')
        for (const key of Object.keys(data)) {
            sliders.each(function() {
                if ($(this).attr('data-value') == key) {
                    $(this).val(parseFloat(data[key]) * 100)
                }
            })
        }
    }

    function SetupHeadOverlay(data) {
        for (var i = 0; i < data.length; i++) {
            var ele = $("#"+data[i]['name'])
            var inputs = ele.find("input")
            inputs.eq(0).val(parseInt(data[i]['overlayValue']))
            inputs.eq(1).val(parseInt(data[i]['overlayOpacity'] * 100))
            var palettes = ele.find('.color_palette_container').eq(0).find('.color_palette')
            $(palettes[data[i]['firstColour']]).addClass('active')
            palettes = ele.find('.color_palette_container').eq(1).find('.color_palette')
            $(palettes[data[i]['secondColour']]).addClass('active')
        }
    }

    function SaveHeadOverlay(ele) {
        var id = ele.parents('.panel').attr('id')
        var inputs = ele.parents('.panel').find('input')
        let opacity = inputs.eq(1).val() ? inputs.eq(1).val() : 0

        $.post('https://kk-clothing/saveheadoverlay', JSON.stringify({
            name: id,
            value: inputs.eq(0).val(),
            opacity: opacity
        }))
    }

    function AddPalettes() {
        $('.color_palette_container').each(function () {
            $(this).empty()
            if ($(this).hasClass('haircol')) {
                $(this).append($(hairColors))
            }
            if ($(this).hasClass('makeupcol')) {
                $(this).append($(makeupColors))
            }
        });
        $('.color_palette').on('click', function() {
            var palettes = $(this).parents('.panel').find('.color_palette_container')

            $(this).parent().find('.color_palette').removeClass('active')
            $(this).addClass('active')

            if ($(this).parents('.panel').hasClass('hair')) {
                $.post('https://kk-clothing/savehaircolor', JSON.stringify({
                    firstColour: palettes.eq(0).find('.active').attr('value'),
                    secondColour: palettes.eq(1).find('.active').attr('value')
                }));
            }
            else {
                $.post('https://kk-clothing/saveheadoverlaycolor', JSON.stringify({
                    firstColour: palettes.eq(0).find('.active').attr('value'),
                    secondColour: palettes.eq(1).find('.active').attr('value'),
                    name: $(this).parents('.panel').attr('id')
                }));
            }
        })
    }

    function createPalette(array) {
        var ele_string = ""
        for (var i = 0; i < Object.keys(array).length; i++) {
            var color = array[i][0]+","+array[i][1]+","+array[i][2]
            ele_string += '<div class="color_palette inline-block rounded h-7 w-7" style="background-color: rgb('+color+')" value="'+i+'"></div>'
        }
        return ele_string
    }

    function SetupTatTotals(totals) {
        for (let i = 0; i < Object.keys(totals).length; i++) {
            $('#'+totals[i][0]).find('.total-number').text(totals[i][1])
        }
    }

    function SetupTatValues(data) {
        for (const property in data) {
            $(`#${property}`).find('.input-number').val(`${data[property]}`);
        }
    }
});
