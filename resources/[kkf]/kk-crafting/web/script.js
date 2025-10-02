$(document).ready(function() {
    let currentData = {}; 
    currentItem = '';

    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27') {
            $.post('https://kk-crafting/close', JSON.stringify({}), function(cb) {})  
        }
    });

    window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'open') {
            $('body').fadeIn()
            currentData = event.data;
            $("#itemList").html("");

            $.each(currentData, function(k, v) {
                if (v != 'none') {
                    if (v.blurred) {
                        $("#itemList").append(`
                            <div class="flex mb-1 blur-sm">
                                <div data-itemId="${k}" class="cursor-pointer bg-zinc-800 border border-zinc-700 rounded shadow text-zinc-300">
                                    <img class="m-auto h-20" src="nui://ox_inventory/web/images/${v.itemId}.png">
                                </div>
    
                                <div class="ml-1 mt-auto mb-auto">
                                    <p class="text-zinc-300 uppercase font-medium">${v.name} (${v.amount}x)</p>
                                    <p class="text-zinc-300 uppercase font-medium text-sm">${v.description}</p>
                                </div>
                            </div>
                        `);
                    } else {
                        $("#itemList").append(`
                            <div class="flex mb-1">
                                <div data-itemId="${k}" class="selectItem cursor-pointer bg-zinc-800 border border-zinc-700 rounded shadow text-zinc-300">
                                    <img class="m-auto h-20" src="nui://ox_inventory/web/images/${v.itemId}.png">
                                </div>
    
                                <div class="ml-1 mt-auto mb-auto">
                                    <p class="text-zinc-300 uppercase font-medium">${v.name} (${v.amount}x)</p>
                                    <p class="text-zinc-300 uppercase font-medium text-sm">${v.description}</p>
                                </div>
                            </div>
                        `);
                    }
                }
            });
        } else if (event.action === 'close') {
            $('body').fadeOut(); currentItem = ''; $('#secondContainer').hide()
        }
    });

    function loadItemData(item) {
        currentItem = item + +1; $('#secondContainer').fadeIn()

        $('#itemName').text(currentData[item].name);
        $('#timeToDo').html(currentData[item].time);

        if (currentData[item].skill) {
            $('#levelContainer').removeClass('hidden')
            $('#lvlRequired').html(currentData[item].skill.lvlRequired);
        } else {
            $('#levelContainer').addClass('hidden')
        }

        $('#secondContaImg').attr('src', 'nui://ox_inventory/web/images/' + currentData[item].itemId + '.png');

        var itemsNeeded = $("#itemsNeeded");

        $(itemsNeeded).html("");

        $.each(currentData[item].requirements, function(k, v){
            $(itemsNeeded).append(`
                <div class="bg-zinc-900 border border-zinc-700 rounded shadow flex h-12">
                    <img src="nui://ox_inventory/web/images/${v.item}.png">

                    <p class="mt-auto mb-auto font-medium uppercase text-sm">${v.label}</p>
                </div>
            `);
        });
    }

    $(document).on("click", "#buildItem", function () {
        if (currentItem != '') {
            $.post('https://kk-crafting/buildItem', JSON.stringify({item: currentItem, count: $('#itemCount').val()}), function(cb) {})  
        }
    });

    $(document).on("click", ".selectItem", function () {
        loadItemData($(this).data('itemid'))
    });
})