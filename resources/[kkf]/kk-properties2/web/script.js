$(document).ready(function () {
    functions = {}

    let actionPossible = true;
    let currentPropertyId = null; // alguses null

    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27') {
            $.post('https://kk-properties2/closeTablet', JSON.stringify({}));
            $.post('https://kk-properties2/closeShop', JSON.stringify({}));
        }
    })

    $("#hovering").hover(
        function () {
            $("#computer").css("opacity", "0.5");
        },

        function () {
            $("#computer").css("opacity", "1");
        }
    );

    $("#hovering2").hover(
        function () {
            $("#catalogue").css("opacity", "0.5");
        },

        function () {
            $("#catalogue").css("opacity", "1");
        }
    );

    window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'open') {
            $('#computer').show()
            $('#propertyLabel').html(event.data.label);
            currentPropertyId = event.data.id;
            $('.no-permission').remove();

            if (event.data.type === 'warehouse') {
                $('#warehouseOptions').show()
                $('#propertyOptions').hide()
            } else {
                $('#propertyOptions').show()
                $('#warehouseOptions').hide()
            }

            if (event.data.warehouse) {
                $('#cryptoCount').text(`${event.data.warehouse.crypto}`)
                $('#computerCount').text(`${event.data.warehouse.computers} (~${event.data.warehouse.earnings}/h)`)

                setCurrentWarehouseLevel(event.data.warehouse.level);

                function formatInterval(totalMinutes) {
                    const minutesInDay = 60 * 24;
                    const minutesInWeek = minutesInDay * 7;

                    if (totalMinutes < minutesInDay) {
                        const hours = Math.floor(totalMinutes / 60);
                        const minutes = totalMinutes % 60;
                        let result = '';
                        if (hours > 0) result += `${hours}h `;
                        if (minutes > 0) result += `${minutes}min`;
                        return result.trim();
                    } else if (totalMinutes < minutesInWeek) {
                        const days = Math.floor(totalMinutes / minutesInDay);
                        const hours = Math.floor((totalMinutes % minutesInDay) / 60);
                        let result = '';
                        if (days > 0) result += `${days}p `;
                        if (hours > 0) result += `${hours}h`;
                        return result.trim();
                    } else {
                        const weeks = Math.floor(totalMinutes / minutesInWeek);
                        const days = Math.floor((totalMinutes % minutesInWeek) / minutesInDay);
                        let result = '';
                        if (weeks > 0) result += `${weeks}n `;
                        if (days > 0) result += `${days}p`;
                        return result.trim();
                    }
                }

                if (event.data.warehouse.shop) {
                    $('#shopItems').html('');

                    event.data.warehouse.shop.sort(function(a, b) {
                        return a.price - b.price;
                    });

                    function formatInterval(totalMinutes) {
                        const minutesInDay = 60 * 24;
                        const minutesInWeek = minutesInDay * 7;

                        if (totalMinutes < minutesInDay) {
                            const hours = Math.floor(totalMinutes / 60);
                            const minutes = totalMinutes % 60;
                            let result = '';
                            if (hours > 0) result += `${hours}h `;
                            if (minutes > 0) result += `${minutes}min`;
                            return result.trim();
                        } else if (totalMinutes < minutesInWeek) {
                            const days = Math.floor(totalMinutes / minutesInDay);
                            const hours = Math.floor((totalMinutes % minutesInDay) / 60);
                            let result = '';
                            if (days > 0) result += `${days}p `;
                            if (hours > 0) result += `${hours}h`;
                            return result.trim();
                        } else {
                            const weeks = Math.floor(totalMinutes / minutesInWeek);
                            const days = Math.floor((totalMinutes % minutesInWeek) / minutesInDay);
                            let result = '';
                            if (weeks > 0) result += `${weeks}n `;
                            if (days > 0) result += `${days}p`;
                            return result.trim();
                        }
                    }

                    $.each(event.data.warehouse.shop, function(k, v){
                        if (event.data.warehouse.level >= v.level) {
                            let maxDurationText = '';
                            let durabilityIntervalText = '';

                            if (v.durabilityLoss !== undefined && v.durabilityLoss !== null) {
                                const maxDuration = (100 / v.durabilityLoss) * event.data.warehouse.durabilityInterval;
                                maxDurationText = `<p class="text-xs text-zinc-400">Maksimaalne kestvus: ${formatInterval(maxDuration)}</p>`;

                                if (event.data.warehouse.durabilityInterval !== undefined && event.data.warehouse.durabilityInterval !== null) {
                                    durabilityIntervalText = `<p class="text-xs text-zinc-400">Kulumise intervall: ${formatInterval(event.data.warehouse.durabilityInterval)}</p>`;
                                }
                            }

                            $('#shopItems').append(`
                                <div class='flex justify-between bg-zinc-900 shadow rounded border border-zinc-700 p-2 mb-1'>
                                    <div class="flex gap-1">
                                        <img class="m-auto h-12" src="nui://ox_inventory/web/images/${v.name}.png">
                                        <div class="flex flex-col justify-center">
                                            <p class="text-sm text-zinc-200">${v.label}</p>
                                            <p class="text-xs text-zinc-400">Nõutav tase: ${v.level}</p>
                                            ${(v.durabilityLoss !== undefined) ? `<p class="text-xs text-zinc-400">Kulumise määr: ${v.durabilityLoss}</p>` : ''}
                                            ${durabilityIntervalText}
                                            ${maxDurationText}
                                            ${v.infoText ? `<p class="text-xs text-zinc-400 italic truncate mt-1">${v.infoText}</p>` : ''}
                                        </div>
                                    </div>

                                    <button data-id="${k}" class="buyShopItem px-2.5 py-1.5 h-min mt-auto mb-auto text-xs font-medium rounded shadow text-white bg-green-600 hover:bg-green-700">
                                        ${v.price} (EQ)
                                    </button>
                                </div>
                            `);
                        }
                    });
                }

                if (event.data.warehouse.missions) {
                    $('#chooseMissionItem').html('');

                    $.each(event.data.warehouse.missions, function(k, v){
                        $('#chooseMissionItem').append(`
                            <option value="${k}">${v.desc}</option>
                        `);
                    });
                }

                if (event.data.warehouse.level < 3) {
                    $('#warehouseMissions').hide()
                } else $('#warehouseMissions').show()
            }

            $('#buyKeysButton').text(`$${event.data.keyPrice}`);
            $('#buyLockButton').text(`$${event.data.lockPrice}`);

            if (event.data.canEdit) {
                $('#buyKeys').show();
                $('#buyLock').show();

                if (event.data.type != 'shop') {
                    $('#sellProperty').show();
                } else {
                    $('#sellProperty').hide();
                }
            } else {
                $('#buyKeys').hide();
                $('#buyLock').hide();
                $('#sellProperty').hide();
            }

            $('#logs').html('');

            if (event.data.logs) {
                $.each(event.data.logs, function(k, v){
                    let date = new Date(v.time);
                    let time = ('0'+date.getHours()).slice(-2)+":"+('0'+date.getMinutes()).slice(-2)+" "+('0'+date.getDate()).slice(-2)+"."+('0'+(date.getUTCMonth()+1)).slice(-2)+"."+date.getFullYear()
    
                    $('#logs').append(`
                        <div class='bg-zinc-900 shadow rounded border-zinc-700 border p-2 mb-1'>
                            <p class="ml-2 text-sm text-zinc-200">${v.name}</p>
                            <hr class="m-2 border-t-2 text-zinc-200">
                            <div class='flex justify-between'>
                                <p class="ml-2 text-lg font-medium text-zinc-200">${v.time}</p>
                                <p class="mr-2 text-lg font-medium text-zinc-200">${v.text}</p>
                            </div>
                        </div>
                    `);

                });
            } else {
                $('#logs').append(`
                    <h1 class="font-medium text-center">Teil ei ole piisavalt õigusi!</h1>
                `);
            }

            $('#bills').html('');

            if (event.data.bills) {
                $.each(event.data.bills, function(k, v){
                    $('#bills').append(`
                        <div class="flex justify-between bg-zinc-900 shadow rounded border-zinc-700 border p-2 mb-1">
                            <div class="flex">
                                <div class="ml-2 mt-auto mb-auto">
                                    <h1>${v.text} #${v.id}</h1>
                                    <h1 class="text-xs font-medium text-zinc-400 mb-1">Makse tuleb maksta, et kõigil oleks hea :)</h1>
                                </div>
                            </div>
    
                            <button data-id="${v.id}" class="payBill px-2.5 py-1.5 h-min mt-auto mb-auto text-xs font-medium rounded shadow text-white bg-green-600 hover:bg-green-700">$${v.amount}</button>
                        </div>
                    `);
                });
            } else {
                $('#bills').append(`
                    <h1 class="font-medium text-center">Teil ei ole piisavalt õigusi!</h1>
                `);
            }

            var visibleOptions = $('#propertyOptions div:visible').length;

            if (visibleOptions === 0) {
                $('#propertyOptions').append(`
                    <h1 class="no-permission font-medium text-center">Teil ei ole piisavalt õigusi!</h1>
                `);
            }

            var visibleBills = $('#bills div:visible').length;

            if (visibleBills === 0) {
                $('#bills').append(`
                    <h1 class="no-permission font-medium text-center">Teil ei ole ühtegi arvet!</h1>
                `);
            }
        } else if (event.action === 'close') {
            $('#computer').hide()
        } else if (event.action === 'updateCrypto') {
            if (event.data.crypto) {
                $('#cryptoCount').text(event.data.crypto)
            }
        } else if (event.action === 'openShop') {
            $('#catalogue').show()

            $('#propertiesSell').html('');

            $.each(event.data, function(k, v){
                var img = new Image();
                img.src = v.image;

                $('#propertiesSell').append(`
                    <div data-id="${v.id}" class="bg-zinc-900 border border-zinc-700 rounded shadow overflow-hidden h-max">
                        <img class="w-full h-56 object-cover" src="${v.image}" alt="Kinnisvara">

                        <div class="p-6">
                            <h2 class="text-xl font-semibold mb-2">${v.label}</h2>
                            <p class="text-red-600 font-semibold">NB!</p>
                            <p class="text-gray-400 mb-4">Enne soetamist tutvu kinnisvaraga ning veendu, et sul oleks raha ka maksudeks ja arveteks!</p>
                            <p class="text-green-600 font-semibold mb-2">Hind</p>
                            <p class="text-white text-2xl font-bold mb-4">$${v.price}</p>

                            <button class="buyProperty w-full bg-green-500 text-white py-2 rounded hover:bg-green-600 transition duration-200">Soeta</button>
                        </div>
                    </div>
                `);
            });
        } else if (event.action === 'closeShop') {
            $('#catalogue').hide()
        }
    });

    $(document).on("click", ".buyProperty", function () {
        if (actionPossible) {
            loadingBar(true);
            let elm = $(this)

            $.post('https://kk-properties2/buyProperty', JSON.stringify({id: elm.parent().parent().data('id')}), function(cb) {
                if (cb) {
                    elm.parent().parent().remove();
                }

                loadingBar(false);
            })  
        }
    });

    $(document).on("click", ".payBill", function () {
        if (actionPossible) {
            loadingBar(true);
            let elm = $(this)

            $.post('https://kk-properties2/payBill', JSON.stringify({id: elm.data('id')}), function(cb) {
                if (cb) {
                    elm.parent().remove();
                }

                loadingBar(false);
            })  
        }
    });
    
    $(".property-accept").click(function(e){
        $.post('https://kk-properties2/buy', JSON.stringify({}))
    });
    
    $(".property-cancel").click(function(e){
        $.post('https://kk-properties2/exit', JSON.stringify({}));
    });

    $(document).on("click", "#buyKeysButton", function () {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-properties2/buyKeysButton', JSON.stringify({}), function(cb) {
                loadingBar(false);
            })  
        }
    });

    $(document).on("click", "#buyLockButton", function () {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-properties2/buyLockButton', JSON.stringify({}), function(cb) {
                loadingBar(false);
            })  
        }
    });

    $(document).on("click", "#decorateButton", function () {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-properties2/decorateButton', JSON.stringify({}), function(cb) {
                loadingBar(false);

                $('#computer').hide();
            })  
        }
    }); 

    $(document).on("click", "#sellPropertyButton", function () {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-properties2/sellPropertyButton', JSON.stringify({}), function(cb) {
                loadingBar(false);

                $('#computer').hide();
            })  
        }
    });

    $(document).on("click", "#closeTablet", function () {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-properties2/closeTablet', JSON.stringify({}), function(cb) {
                loadingBar(false);

                $('#computer').hide();
            })  
        }
    });

    // level modal
    $(document).on("click", ".closeLevelModal", function () {
        if (actionPossible) {
            $('#levelModal').fadeOut(200); selectedPerson = 0;
        }
    });

    $(document).on("click", "#openLevelModal", function () {
        if (actionPossible) {
            loadingBar(true); 
            $('#levelModal').fadeIn(200)
            loadingBar(false); 
        }
    }); 
    //

    // crypto modal
    $(document).on("click", ".closeCryptoModal", function () {
        if (actionPossible) {
            $('#cryptoModal').fadeOut(200); selectedPerson = 0;
        }
    });

    $(document).on("click", "#openCryptoModal", function () {
        if (actionPossible) {
            loadingBar(true); 
            $('#cryptoModal').fadeIn(200)
            loadingBar(false); 
        }
    }); 
    //

    // crypto modal
    $(document).on("click", ".closeTableModal", function () {
        if (actionPossible) {
            $('#tableModal').fadeOut(200); selectedPerson = 0;
        }
    });

    $(document).on("click", "#openTableModal", function () {
        if (actionPossible) {
            loadingBar(true); 
            $('#tableModal').fadeIn(200)
            loadingBar(false); 
        }
    }); 
    //

    // crypto modal
    $(document).on("click", ".closeMissionModal", function () {
        if (actionPossible) {
            $('#missionModal').fadeOut(200); selectedPerson = 0;
        }
    });

    $(document).on("click", "#openMissionModal", function () {
        if (actionPossible) {
            loadingBar(true); 
            $('#missionModal').fadeIn(200)
            loadingBar(false); 
        }
    });

    $(document).on("click", "#sendCryptoToFaction", function () {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-properties2/sendCryptoToFaction', JSON.stringify({count: $('#factionCryptoCount').val()}), function(cb) {
                if (cb) {
                    $('#cryptoCount').text(`${cb}`)
                }

                loadingBar(false);
            })  
        }
    });

    function setCurrentWarehouseLevel(level) {
        $('#currentLevel').text(level); // Set the current level in the HTML
        
        $('#levelBubbles span').each(function(index) {
            if (index < level) {
                $(this).removeClass('bg-zinc-700').addClass('bg-green-500');
            } else {
                $(this).removeClass('bg-green-500').addClass('bg-zinc-700');
            }
        });
    }

    $(document).on("click", "#levelUpBtn", function () {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-properties2/levelUp', JSON.stringify({}), function(cb) {
                if (cb) {
                    setCurrentWarehouseLevel(cb)
                }

                loadingBar(false);
            })  
        }
    });

    $(document).on("click", "#factionCryptoInsert", function () {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-properties2/factionCryptoInsert', JSON.stringify({count: $('#insertCryptoCount').val()}), function(cb) {
                if (cb) {
                    $('#cryptoCount').text(`${cb}`)
                }

                loadingBar(false);
            })  
        }
    });

$(document).on("click", ".buyShopItem", function () {
    if (!actionPossible) return;

    loadingBar(true);
    let elm = $(this);
    let propertyId = currentPropertyId; // Use the stored property ID
    let itemIndex = elm.data('id');     // 0-based index from the sorted shop list

    if (!propertyId || itemIndex === undefined || itemIndex === null) {
        console.error('Invalid purchase data:', { propertyId, itemIndex });
        loadingBar(false);
        alert('Invalid item or property selection');
        return;
    }

    console.log('Sending purchase request:', { propertyId, itemIndex });

    $.post('https://kk-properties2/buyShopItem', JSON.stringify({
        propertyId: propertyId,
        itemIndex: itemIndex
    }), function(cb) {
        loadingBar(false);

        if (cb && cb.success) {
            console.log('Purchase successful');
            elm.parent().remove();
        } else {
            console.error('Purchase failed:', cb ? cb.error : 'No response');
            alert('Purchase failed: ' + (cb ? cb.error : 'Server error'));
        }
    }).fail(function(xhr, status, error) {
        loadingBar(false);
        console.error('Server request failed:', { status, error, response: xhr.responseText });
        alert('Server error occurred');
    });
});

    $(document).on("click", "#startMissionButton", function () {
        if (actionPossible) {
            loadingBar(true);
            let mission = +$('#chooseMissionItem').val() + +1;

            $.post('https://kk-properties2/startMission', JSON.stringify({id: mission}), function(cb) {
                loadingBar(false);
            })  
        }
    });
    //

    function loadingBar(val) {
        if (val) {
            $('#loader').show(); actionPossible = false
        } else {
            $('#loader').hide(); actionPossible = true
        }
    }
});