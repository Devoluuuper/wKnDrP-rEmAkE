$(document).ready(function () {
    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27') {
            $.post('https://kk-factions/closeTablet', JSON.stringify({}));
        }
    });

    $("#hovering").hover(
        function () {
            $("#body").css("opacity", "0.5");
        },

        function () {
            $("#body").css("opacity", "1");
        }
    );

    functions = {};

    let actionPossible = true;
    let selectedPerson = 0;
    let selectedCar = '';
    let currentRank = 0;
    let currentFaction = {};
    let vatProcent = 0;

    var $mq;

    window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'open') {
            $('#body').show(); functions.loadAll(false)

            vatProcent = event.data.vat;
        } else if (event.action === 'close') {
            $('#body').hide(); currentFaction.permissions = {}
        } else if (event.action === 'reloadAnnouncments') {
            functions.loadAnnouncments()
        } else if (event.action === 'factionAlert') {
            functions.displayEAS(event.data.faction, event.data.message, event.data.duration)
        } else if (event.action === 'openMap') {
            $('#app-map').show();
        } else if (event.action === 'closeMap') {
            $('#app-map').hide();
        } else if (event.action === 'sendNotification') {
            let $notification

            if (event.data.type === 'success') {
                $notification = $(`
                    <div class="bg-zinc-800 rounded border border-zinc-700 p-2 shadow mb-1 text-zinc-200">
                        <div class="flex">
                            <div class="mt-auto mb-auto px-2">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-8 h-8 text-green-700">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>  
                            </div>
                            <div class="ml-2 mr-6">
                                <span class="font-semibold">${event.data.title}</span>
                                <span class="block text-zinc-400">${event.data.message}</span>
                            </div>
                        </div>
                    </div>
                `).hide().fadeIn(700) 
            } else if (event.data.type === 'info') {
                $notification = $(`
                    <div class="bg-zinc-800 rounded border border-zinc-700 p-2 shadow mb-1 text-zinc-200">
                        <div class="flex">
                            <div class="mt-auto mb-auto px-2">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-8 h-8 text-sky-700">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M11.25 11.25l.041-.02a.75.75 0 011.063.852l-.708 2.836a.75.75 0 001.063.853l.041-.021M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9-3.75h.008v.008H12V8.25z" />
                                </svg>
                            </div>
                            <div class="ml-2 mr-6">
                                <span class="font-semibold">${event.data.title}</span>
                                <span class="block text-zinc-400">${event.data.message}</span>
                            </div>
                        </div>
                    </div>
                `).hide().fadeIn(700) 
            } else if (event.data.type === 'error') {
                $notification = $(`
                    <div class="bg-zinc-800 rounded border border-zinc-700 p-2 shadow mb-1 text-zinc-200">
                        <div class="flex">
                            <div class="mt-auto mb-auto px-2">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-8 h-8 text-red-700">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m9-.75a9 9 0 11-18 0 9 9 0 0118 0zm-9 3.75h.008v.008H12v-.008z" />
                                </svg>  
                            </div>
                            <div class="ml-2 mr-6">
                                <span class="font-semibold">${event.data.title}</span>
                                <span class="block text-zinc-400">${event.data.message}</span>
                            </div>
                        </div>
                    </div>
                `).hide().fadeIn(700) 
            }

            $('#notifications').append($notification);

            setTimeout(function () {
                $notification.fadeOut(300)
            }, 3500)
        } else if (event.action === 'updateCrypto') {
            if (event.data.crypto) {
                $('#total_crypto').text(event.data.crypto)
            }
        }
    });

    functions.loadAll = function(toFactions) {
        if (actionPossible) {
            loadingBar(true); $('#factionName').html(`Puudub - Puudub`)
            
            if (toFactions) $.post('https://kk-factions/setPage', JSON.stringify({ page: 'my_factions' }));

            $.post('https://kk-factions/loadTablet', JSON.stringify({}), function(data) {
                currentFaction = data.faction;

                loadingBar(false); 
                $('#myFactions').html('');

                $.each(data.factions, function(k, v){
                    let buttons = `<button class="chooseFaction px-2.5 py-1.5 text-xs font-medium rounded shadow text-white bg-green-600 hover:bg-green-700">Vali</button>`

                    if (v.selected) {
                        $('#factionName').html(`${v.label} - ${v.grade.label}`)

                        if (currentFaction && currentFaction.data && currentFaction.data.callsign) {
                            $('#memberListCallsign').show();
                        } else {
                            $('#memberListCallsign').hide();
                        }

                    }

                    if (v.type != 'gang' && (k != 'police' && k != 'ambulance')) {
                        buttons = buttons + '<button class="leaveFaction px-2.5 py-1.5 text-xs font-medium rounded shadow text-white bg-red-600 hover:bg-red-700">Lahku</button>'
                    }
        
                    $('#myFactions').append(`
                        <div data-value='{"job":"${k}","grade":"${v.grade.id}"}' class="w-full p-2 bg-zinc-900 border border-zinc-700 rounded shadow flex justify-between">
                            <div class="mt-auto mb-auto">
                                <p class="text-gray-400 font-semibold text-xl">${v.label}</p>
                                <p class="text-sm font-semibold text-zinc-300">${v.grade.label}</p>
                            </div>
                            <div class="flex gap-1 mt-auto mb-auto">${buttons}</div>
                        </div>
                    `);
                });

                if (currentFaction.name == 'taxi') {
                    $('#taxi_info').removeClass('hidden');
                } else {
                    $('#taxi_info').addClass('hidden');
                }

                if (data.taxiData) {
                    if (data.taxiData.done) {
                        $('#total_done_taxi').text(data.taxiData.done)
                    }

                    $('#taxiRatings').html('');

                    $.each(data.taxiData.stats, function(k, v){
                        $('#taxiRatings').append(`
                            <tr class="hover:bg-zinc-700">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    ${v.name}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    ${v.done}
                                </td>
                            </tr>
                        `);
                    });
                }

                if (currentFaction.type == 'illegal') {
                    $('#gang_info').removeClass('hidden');
                } else {
                    $('#gang_info').addClass('hidden');
                }

                if (currentFaction.type == 'racers') {
                    $('#racers_info').removeClass('hidden');
                } else {
                    $('#racers_info').addClass('hidden');
                }

                if (data.racerData) {
                    if (data.racerData.own_elo) {
                        $('#total_own_elo').text(data.racerData.own_elo)
                    }

                    $('#racersRatings_own').html('');

                    $.each(data.racerData.own, function(k, v){
                        $('#racersRatings_own').append(`
                            <tr class="hover:bg-zinc-700">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    ${v.name}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    ${v.elo}
                                </td>
                            </tr>
                        `);
                    });

                    $('#racersRatings_global').html('');

                    $.each(data.racerData.total, function(k, v){
                        $('#racersRatings_global').append(`
                            <tr class="hover:bg-zinc-700">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    ${v.label}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    ${v.elo}
                                </td>
                            </tr>
                        `);
                    });
                }

                if (data.reputation) {
                    $('#total_reputation').text(data.reputation)
                }

                if (data.crypto) {
                    $('#total_crypto').text(data.crypto)
                }

                if (data.zones) {
                    $('#gangTerritories').html('');

                    $.each(data.zones, function(k, v){
                        $('#gangTerritories').append(`
                            <tr class="hover:bg-zinc-700">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    ${v.zone}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    ${v.reputation}
                                </td>
                            </tr>
                        `);
                    });
                }
        
                if (currentFaction.permissions) {
                    // NAVBAR
                    if (currentFaction.permissions.addMember || currentFaction.permissions.removeMember || currentFaction.permissions.changeMemberGrade || currentFaction.permissions.function3) {
                        $('#members').removeClass('hidden');
                    } else {
                        $('#members').addClass('hidden');
                    }
        
                    if (currentFaction.permissions.addGrade || currentFaction.permissions.editGrade || currentFaction.permissions.deleteGrade) {
                        $('#grades').removeClass('hidden');
                    } else {
                        $('#grades').addClass('hidden');
                    }
                    
                    if (currentFaction.permissions.function2) {
                        $('#buyable_vehicles').removeClass('hidden');
                    } else {
                        $('#buyable_vehicles').addClass('hidden');
                    } 
        
                    if (currentFaction.permissions.function9) {
                        $('#logs').removeClass('hidden');
                    } else {
                        $('#logs').addClass('hidden');
                    } 

                    if (currentFaction.permissions.intranet) {
                        $('#intranet').removeClass('hidden');

                        if (currentFaction.type === 'gang' || currentFaction.type === 'racers') {
                            $('#intranet').addClass('hidden');
                        } else {
                            $('#intranet').removeClass('hidden');
                        }
                    } else {
                        $('#intranet').addClass('hidden');
                    }

                    if (currentFaction.permissions.intranet_admin) {
                        $('#intranetAnnounce').removeClass('hidden');
                    } else {
                        $('#intranetAnnounce').addClass('hidden');
                    }

                    if (currentFaction.permissions.function1) {
                        $('#owned_vehicles').removeClass('hidden');
                    } else {
                        $('#owned_vehicles').addClass('hidden');
                    }
        
                    // BUTTONS
        
                    if (currentFaction.permissions.function11) {
                        $('#startRivalry').removeClass('hidden');
                    } else {
                        $('#startRivalry').addClass('hidden');
                    } 

                    if (currentFaction.permissions.addMember) {
                        $('#addMemberButton').removeClass('hidden');
                    } else {
                        $('#addMemberButton').addClass('hidden');
                    }
                }
            })
        }
    }

    $(document).on("click", ".firePerson", function () {
        if (actionPossible) {
            let id = $(this).parent().parent().data('id'); loadingBar(true); 

            $.post('https://kk-factions/firePerson', JSON.stringify({ id: id }), function(cb) {
                loadingBar(false); 

                if (cb) {
                    functions.loadMembers()
                }
            });
        }
    });

    $(document).on("click", ".closeRankModal", function () {
        if (actionPossible) {
            $('#changeRankModal').fadeOut(200); selectedPerson = 0;
        }
    });

    $(document).on("click", ".changePlayerRank", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-factions/setRank', JSON.stringify({id: selectedPerson, rank: $('#chooseRank').val()}), function(cb) {
                loadingBar(false); 

                $('#changeRankModal').fadeOut(200); selectedPerson = 0; functions.loadMembers()
            });
        }
    }); 

    $(document).on("click", ".closeBuyVehicleModal", function () {
        if (actionPossible) {
            $('#buyVehicleModal').fadeOut(200); selectedCar = '';
        }
    });

    $(document).on("click", ".closeMemberModal", function () {
        if (actionPossible) {
            $('#addMemberModal').fadeOut(200);
        }
    });

    $(document).on("click", "#addMemberButton", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-factions/getNearbyPlayers', JSON.stringify({}), function(cb) {
                loadingBar(false);

                if (cb) {
                    $('#addMemberModal').fadeIn(200);

                    $('#recruitPerson').html('');

                    $.each(cb.players, function(k, v){
                        $('#recruitPerson').append(`
                            <option value="${v.serverId}">${v.serverId}</option>
                        `);
                    });

                    $('#recruitRank').html('');

                    $.each(cb.ranks, function(k, v){
                        $('#recruitRank').append(`
                            <option value="${v.grade}">${v.label}</option>
                        `);
                    });
                }
            });
        }
    }); 

    $(document).on("click", "#chooseRecruitMember", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-factions/recruitPlayer', JSON.stringify({ id: $('#recruitPerson').val(), rank: $('#recruitRank').val() }), function(cb) {
                loadingBar(false); $('#addMemberModal').fadeOut(200);

                if (cb) functions.loadMembers()
            });
        }
    });

    $(document).on("click", "#startRivalry", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-factions/startTurf', JSON.stringify({}), function(cb) {
                loadingBar(false)
            });
        }
    });

functions.searchLogs = function(page) {
    if (actionPossible) {
        loadingBar(true); 

        $.post(
            'https://kk-factions/searchLogs',
            JSON.stringify({ 
                id: $('#searchPid').val(), 
                search: $('#search').val(), 
                page: page 
            }),
            function(cb) {
                loadingBar(false);

                if (cb) {
                    if (cb.logs) {
                        $('#logs_list').html('');
                        $.each(cb.logs, function(k, v) {
                            let date = new Date(v.time);
                            let time = ('0' + date.getHours()).slice(-2) + ":" + ('0' + date.getMinutes()).slice(-2) + " " +
                                       ('0' + date.getDate()).slice(-2) + "." + ('0' + (date.getUTCMonth() + 1)).slice(-2) + "." + date.getFullYear();

                            $('#logs_list').append(`
                                <tr class="hover:bg-zinc-700">
                                    <td class="px-6 py-4 whitespace-nowrap">${v.action}</td>
                                    <td class="px-6 py-4 whitespace-nowrap">${v.citizenid}</td>
                                    <td class="px-6 py-4 break-words w-96">${v.text}</td>
                                    <td class="px-6 py-4 whitespace-nowrap">${time}</td>
                                </tr>
                            `);
                        });
                    }
    
                    if (cb.count) {	
                        var pagination = '<ul class="flex gap-0.5">';
            
                        for (var i = 1; i < cb.count + 1; i++) {
                            if (i == 1 && page > 10) {
                                pagination += `<li><a class="px-3 py-2 rounded shadow text-zinc-200 bg-zinc-900 border border-zinc-700 hover:bg-zinc-700" href="#" onclick="functions.searchLogs(${i});">${i}</a></li>`;
                            }
            
                            if (i == cb.count && page < cb.count - 10) {
                                pagination += `<li><a class="px-3 py-2 rounded shadow text-zinc-200 bg-zinc-900 border border-zinc-700 hover:bg-zinc-700" href="#" onclick="functions.searchLogs(${i});">${i}</a></li>`;
                            }
            
                            if (i == page) {
                                pagination += `<li><a class="px-3 py-2 rounded shadow text-zinc-200 bg-zinc-700 border border-zinc-700 hover:bg-zinc-900" href="#" onclick="functions.searchLogs(${i});">${i}</a></li>`;
                            } else {
                                if (i > page - 10 && i < page + 10 ) {
                                    pagination += `<li><a class="px-3 py-2 rounded shadow text-zinc-200 bg-zinc-900 border border-zinc-700 hover:bg-zinc-700" href="#" onclick="functions.searchLogs(${i});">${i}</a></li>`;
                                }
                            }
                        }
            
                        pagination += '</ul>';
                        $('#pagination').html(pagination);	
                    }
                }
            }
        );
    }
}


    functions.loadVehicles = function() {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-factions/loadVehicles', JSON.stringify({}), function(cb) {
                loadingBar(false);

                $('#ownedVehicles').html('');
    
                $.each(cb, function(k, v){
                    $('#ownedVehicles').append(`
                        <tr class="hover:bg-zinc-700">
                            <td class="px-6 py-4 whitespace-nowrap">
                                ${v.plate}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                ${v.model}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                ${v.location}
                            </td>
                        </tr>
                    `);
                });
            });
        }
    }

    functions.loadBuyableVehicles = function() {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-factions/loadBuyableVehicles', JSON.stringify({}), function(cb) {
                loadingBar(false);

                $('#buyable_vehicles_table').html('');
    
                $.each(cb, function(k, v){
                    $('#buyable_vehicles_table').append(`
                        <tr data-car="${k}" class="hover:bg-zinc-700">
                            <td class="px-6 py-4 whitespace-nowrap">
                                ${v.label}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                $${v.price} + VAT ${vatProcent}%
                            </td>
                            <td class="flex gap-1 px-6 py-4 whitespace-nowrap">
                                <button class="buyVehicle px-2.5 py-1.5 text-xs font-medium rounded shadow text-white bg-sky-600 hover:bg-sky-700">Soeta</button>
                            </td>
                        </tr>
                    `);
                });
            });
        }
    }

    $(document).on("click", ".buyVehicle", function () {
        if (actionPossible) {
            selectedCar = $(this).parent().parent().data('car');
            loadingBar(true); 

            $.post('https://kk-factions/loadGarages', JSON.stringify({car: selectedCar}), function(cb) {
                loadingBar(false);
                
                if (cb) {
                    $('#buyVehicleModal').fadeIn(200);
                    $('#chooseGarage').html('');
    
                    $.each(cb, function(k, v){
                        $('#chooseGarage').append(`
                            <option value="${k}">${v.label}</option>
                        `);
                    });
                }
            });
        }
    });

    $(document).on("click", "#buyVehicleWithGarage", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-factions/buyVehicle', JSON.stringify({car: selectedCar, garage: $('#chooseGarage').val()}), function(cb) {
                loadingBar(false); 

                $('#buyVehicleModal').fadeOut(200); selectedCar = '';
            });
        }
    }); 

    functions.loadRanks = function() {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-factions/requestRanks', JSON.stringify({}), function(cb) {
                loadingBar(false);

                $('#factionGrades').html('');
    
                $.each(cb, function(k, v){
                    let buttons = ``

                    if (currentFaction.permissions.editGrade) {
                        buttons = buttons + '<button class="editRank px-2.5 py-1.5 text-xs font-medium rounded shadow text-white bg-sky-600 hover:bg-sky-700">Redigeeri</button>'
                    }

                    if (currentFaction.permissions.deleteGrade) {
                        buttons = buttons + '<button class="deleteRank px-2.5 py-1.5 text-xs font-medium rounded shadow text-white bg-red-600 hover:bg-red-700">Kustuta</button>'
                    }

                    $('#factionGrades').append(`
                        <tr data-id="${v.grade}" class="hover:bg-zinc-700">
                            <td class="px-6 py-4 whitespace-nowrap">
                                ${v.grade}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                ${v.label}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                ${v.short}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                $${v.salary}
                            </td>
                            <td class="flex gap-1 px-6 py-4 whitespace-nowrap">
                                ${buttons}
                            </td>
                        </tr>
                    `);
                });
            });
        }
    }

    $(document).on("click", ".editRank", function () {
        if (actionPossible) {
            let id = $(this).parent().parent().data('id');
            loadingBar(true); 

            $.post('https://kk-factions/editRank', JSON.stringify({id: id}), function(cb) {
                loadingBar(false); 

                currentRank = cb.grade;
                $('#rankName2').val(cb.label);
                $('#rankShort2').val(cb.short);
                $('#rankSalary2').val(cb.salary);
                setPermissions(cb.permissions);

                $('#rankEdit').fadeIn(200)
            });
        }
    });

    $(document).on("click", ".changeRank", function () {
        if (actionPossible) {
            selectedPerson = $(this).parent().parent().data('id'); loadingBar(true); 

            $.post('https://kk-factions/requestRanks', JSON.stringify({}), function(cb) {
                loadingBar(false); 

                $('#changeRankModal').fadeIn(200)
                $('#chooseRank').html('');

                $.each(cb, function(k, v){
                    $('#chooseRank').append(`
                        <option value="${v.grade}">${v.label}</option>
                    `);
                });
            });
        }
    });

    $(document).on("click", ".callsign", function () {
        if (actionPossible) {
            selectedPerson = $(this).parent().parent().data('id'); loadingBar(true); 

            $.post('https://kk-factions/requestCallsign', JSON.stringify({target: selectedPerson}), function(callsign) {
                loadingBar(false); 

                $('#callsignId').val(callsign)
                $('#updateCallsign').fadeIn(200)
            });
        }
    });

    $(document).on("click", ".closeCallsign", function () {
        if (actionPossible) {
            $('#updateCallsign').fadeOut(200); selectedPerson = 0;
        }
    }); 

    $(document).on("click", "#changeCallsign", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-factions/changeCallsign', JSON.stringify({id: selectedPerson, callsign: $('#callsignId').val()}), function(cb) {
                loadingBar(false); 

                $('#updateCallsign').fadeOut(200); selectedPerson = 0; functions.loadMembers()
            });
        }
    }); 

    $(document).on("click", ".deleteRank", function () {
        if (actionPossible) {
            let id = $(this).parent().parent().data('id');
            loadingBar(true); 

            $.post('https://kk-factions/deleteRank', JSON.stringify({id: id}), function(cb) {
                loadingBar(false); 

                if (cb) functions.loadRanks()
            });
        }
    });

    $(document).on("click", ".closeRankCreation", function () {
        if (actionPossible) {
            $('#rankCreation').fadeOut(200);
        }
    });
    
    $(document).on("click", ".closeRankEdit", function () {
        if (actionPossible) {
            $('#rankEdit').fadeOut(200); currentRank = 0;

            $('#rankName2').val(''); $('#rankShort2').val(''); $('#rankSalary2').val('');
            clearPermissions();
        }
    });

    $(document).on("click", "#openRankCreation", function () {
        if (actionPossible) {
            $('#rankId').val(''); $('#rankName').val(''); $('#rankShort').val(''); $('#rankSalary').val('');

            $('#rankCreation').fadeIn(200);
        }
    });

    $(document).on("click", "#saveRank", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-factions/saveRank', JSON.stringify({id: currentRank, label: $('#rankName2').val(), short: $('#rankShort2').val(), salary: $('#rankSalary2').val(), permissions: getPermissions()}), function(cb) {
                loadingBar(false);

                if (cb) {
                    $('#rankEdit').fadeOut(200); functions.loadRanks()
                    
                    $('#rankName2').val(''); $('#rankShort2').val(''); $('#rankSalary2').val('');
                    clearPermissions();
                }
            });
        }
    });

    $(document).on("click", "#createRank", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-factions/createRank', JSON.stringify({id: $('#rankId').val(), label: $('#rankName').val(), short: $('#rankShort').val(), salary: $('#rankSalary').val(), permissions: getPermissions()}), function(cb) {
                loadingBar(false);

                if (cb) {
                    $('#rankCreation').fadeOut(200); functions.loadRanks(); 
                    
                    $('#rankId').val(''); $('#rankName').val(''); $('#rankShort').val(''); $('#rankSalary').val('');
                }
            });
        }
    });

    $(document).on("click", ".closeTimesModal", function () {
        if (actionPossible) {
            $('#viewTimesModal').fadeOut(200); selectedPerson = 0;
        }
    }); 

    $(document).on("click", ".leaveFaction", function () {
        if (actionPossible) {
            let job = $(this).parent().parent().data('value'); loadingBar(true);

            $.post('https://kk-factions/leaveFaction', JSON.stringify({job: job}), function(cb) {
                loadingBar(false); functions.loadAll(true)
            });
        }
    });

    $(document).on("click", ".chooseFaction", function () {
        if (actionPossible) {
            let job = $(this).parent().parent().data('value'); loadingBar(true);

            $.post('https://kk-factions/changeFaction', JSON.stringify({job: job}), function(cb) {
                loadingBar(false); functions.loadAll(true)
            });
        }
    });

    function toHoursAndMinutes(totalMinutes) {
        const hours = Math.floor(totalMinutes / 60);
        const minutes = totalMinutes % 60;
      
        return `${hours} tundi ja ${minutes} minutit`
    }

    $(document).on("click", ".loadWorkTimes", function () {
        if (actionPossible) {
            selectedPerson = $(this).parent().parent().data('id'); loadingBar(true); 

            $.post('https://kk-factions/loadWorkTimes', JSON.stringify({id: selectedPerson}), function(cb) {
                loadingBar(false); 

                if (cb) {
                    $('#monthWorkTime').html(toHoursAndMinutes(cb.month))
                    $('#weekWorkTime').html(toHoursAndMinutes(cb.week))

                    $('#viewTimesModal').fadeIn(200)
                    $('#workTimesList').html('');
    
                    $.each(cb.times, function(k, v){
                        let date = new Date(v.date);
                        let time = ('0'+date.getHours()).slice(-2)+":"+('0'+date.getMinutes()).slice(-2)+" "+('0'+date.getDate()).slice(-2)+"."+('0'+(date.getUTCMonth()+1)).slice(-2)+"."+date.getFullYear()

                        $('#workTimesList').append(`
                            <tr class="hover:bg-zinc-700">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    ${time}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    ${toHoursAndMinutes(v.minutes)}
                                </td>
                            </tr>
                        `);
                    });
                }
            });
        }
    });

    functions.loadMembers = function() {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-factions/loadMembers', JSON.stringify({}), function(cb) {
                loadingBar(false);

                $('#membersList').html('');

                let sortedEmployees = cb.data.sort(function(a, b) {
                    return a.job.grade - b.job.grade;
                });

                if (cb.faction === 'police' || cb.faction === 'ambulance') {
                    sortedEmployees = cb.data.sort(function(a, b) {
                        if (a.callsign === "PUUDUB") {
                            return 1;
                        } else if (b.callsign === "PUUDUB") {
                            return -1;
                        } else {
                            return parseInt(a.callsign) - parseInt(b.callsign);
                        }
                    });
                }

                $.each(sortedEmployees, function(k, v) {
                    let buttons = ``; 
                    let callsign = ``;
                    let name = '<span class="text-red-700">&#9679;</span> ' + v.name
                    let activity = `
                        <div class="px-4 py-0.5 w-min text-xs rounded-full shadow bg-green-200 text-green-700">
                            Kõrge
                        </div>
                    ` // +5h päevas keskmine

                    if (v.average_hours < 5 && v.average_hours > 2.5) {
                        activity = `
                            <div class="px-4 py-0.5 w-min text-xs rounded-full shadow bg-yellow-200 text-yellow-700">
                                Keskmine
                            </div>
                        ` // Rohkem kui 2.5h, aga vähem kui 5h
                    } else if (v.average_hours < 2.5) {
                        activity = `
                            <div class="px-4 py-0.5 w-min text-xs rounded-full shadow bg-red-200 text-red-700">
                                Madal
                            </div>
                        ` // Vähem kui 2h päevas
                    }

                    if (v.online) name = '<span class="text-green-700">&#9679;</span> ' + v.name
                    if (currentFaction.permissions.function3) buttons = buttons + '<button class="loadWorkTimes px-2.5 py-1.5 text-xs font-medium rounded shadow text-white bg-sky-600 hover:bg-sky-700">Tööajad</button>'
                    if (currentFaction.permissions.changeMemberGrade && currentFaction.data.callsign) buttons = buttons + '<button class="callsign px-2.5 py-1.5 text-xs font-medium rounded shadow text-white bg-sky-600 hover:bg-sky-700">Kutsung</button>'
                    if (currentFaction.permissions.changeMemberGrade) buttons = buttons + '<button class="changeRank px-2.5 py-1.5 text-xs font-medium rounded shadow text-white bg-sky-600 hover:bg-sky-700">Auaste</button>'
                    if (currentFaction.permissions.removeMember) buttons = buttons + '<button class="firePerson px-2.5 py-1.5 text-xs font-medium rounded shadow text-white bg-red-600 hover:bg-red-700">Vallanda</button>'

                     if (currentFaction.data.callsign) {
                         callsign = `
                             <td class="px-6 py-4 whitespace-nowrap">
                                 ${v.callsign}
                             </td>
                         `;
                     }

                    $('#membersList').prepend(`
                        <tr data-id="${v.pid}" class="hover:bg-zinc-700">
                            ${callsign}
                            
                            <td class="px-6 py-4 whitespace-nowrap">
                                ${v.pid}
                            </td>

                            <td class="px-6 py-4 whitespace-nowrap">
                                ${name}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                ${v.job.grade_label}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                ${activity}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                ${v.lastWork}
                            </td>
                            <td class="flex flex-wrap gap-1 px-6 py-4 whitespace-nowrap">
                                ${buttons}
                            </td>
                        </tr>
                    `);
                });
            });
        }
    } 


    $(document).on("click", "#createAnnouncement", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-factions/createAnnouncement', JSON.stringify({title: $('#announcementTitle').val(), description: $('#announcementDesc').val()}), function(cb) {
                loadingBar(false);

                if (cb) {
                    $('#announcementTitle').val(''); $('#announcementDesc').val('');

                    $('#createIntranetAnnouncement').fadeOut(200); functions.loadAnnouncments()
                }
            });
        }
    });

    let currentEditing = 0;

    $(document).on("click", ".editAnnouncement", function () {
        if (actionPossible) {
            loadingBar(true);
            let id = $(this).data('id'); 

            $.post('https://kk-factions/editAnnouncement', JSON.stringify({id: id}), function(cb) {
                loadingBar(false);

                if (cb) {
                    currentEditing = id;
                    $('#announcementEditTitle').val(cb.title); $('#announcementEditDesc').val(cb.context);

                    $('#editIntranetAnnouncement').fadeIn(200);
                }
            });
        }
    });

    $(document).on("click", "#finishAnnouncementEditing", function () {
        if (actionPossible && currentEditing != 0) {
            loadingBar(true); 

            $.post('https://kk-factions/finishAnnouncementEditing', JSON.stringify({id: currentEditing, title: $('#announcementEditTitle').val(), description: $('#announcementEditDesc').val()}), function(cb) {
                loadingBar(false);

                if (cb) {
                    $('#announcementEditTitle').val(''); $('#announcementEditDesc').val('');

                    $('#editIntranetAnnouncement').fadeOut(200); functions.loadAnnouncments()
                }
            });
        }
    });

    
    $(document).on("click", ".closeAnnounceEdit", function () {
        if (actionPossible) {
            $('#editIntranetAnnouncement').fadeOut(200);
        }
    });

    $(document).on("click", "#intranetAnnounce", function () {
        if (actionPossible) {
            $('#announcementTitle').val(''); $('#announcementDesc').val('');

            $('#createIntranetAnnouncement').fadeIn(200);
        }
    });

    $(document).on("click", ".closeAnnounceCreate", function () {
        if (actionPossible) {
            $('#createIntranetAnnouncement').fadeOut(200);
        }
    });

    $(document).on("click", ".deleteAnnouncement", function () {
        if (actionPossible) {
            loadingBar(true); let id = $(this).parent().parent().parent().data('id')

            $.post('https://kk-factions/deleteAnnouncement', JSON.stringify({id: id}), function(cb) {
                loadingBar(false); functions.loadAnnouncments()
            })  
        }
    });

    $(document).on("click", "#intranet", function () {
        if (actionPossible) {
            functions.loadAnnouncments()
        }
    });

    function formatText(text) {
        // Escape HTML characters
        text = text
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
        
        // Convert newlines to <br> tags
        text = text.replace(/\n/g, "<br>");
    
        return text;
    }

    functions.loadAnnouncments = function() {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-factions/loadAnnouncments', JSON.stringify({}), function(cb) {
                loadingBar(false);

                if (cb) {
                    $('#announcementList').html('');

                    $.each(cb, function(k, v){
                        let date = new Date(v.time);
                        let time = ('0'+date.getHours()).slice(-2)+":"+('0'+date.getMinutes()).slice(-2)+" "+('0'+date.getDate()).slice(-2)+"."+('0'+(date.getUTCMonth()+1)).slice(-2)+"."+date.getFullYear()
                        let buttons = '';

                        if (currentFaction.permissions.intranet_admin) {
                            buttons = buttons + '<button class="deleteAnnouncement px-2 py-0.5 shadow rounded bg-red-700 hover:bg-red-800 text-white text-sm">Kustuta</button>'
                            buttons = buttons + `<button data-id="${v.id}" class="editAnnouncement px-2 py-0.5 shadow rounded bg-sky-600 hover:bg-sky-700 text-white text-sm">Redigeeri</button>`
                        }

                        $('#announcementList').prepend(`
                            <div data-id="${v.id}" class="text-zinc-300 bg-zinc-900 border border-zinc-700 shadow rounded block p-2 w-full mb-1">
                                <h1 class="text-lg font-bold border-b border-zinc-700 pb-1 mb-1">${v.title}</h1>
                                <p class="text-sm mb-1">${formatText(v.context)}</p>
                        
                                <div class="flex justify-between">
                                    <div class="flex gap-1">${buttons}</div>
                                    <p class="text-right text-sm mt-auto mb-auto">${v.sender} - ${time}</p>
                                </div>
                            </div>
                        `);                        
                    });
                }
            })   
        }
    }

    ScrollChars = 1

    functions.scrollMarquee = function(faction, text, duration) {
        $("#eas-content").remove();

        $("#eas-header").html(faction)
        $("#eas-header").after(`<div id="eas-content">${text}</div>`);

        $mq = $('#eas-content').marquee({
            width: "100%",
            duration: duration / 5,
            gap: 50,
            delayBeforeStart: 0,
            direction: 'left',
            duplicated: true
        });

        setTimeout(function () {
            $("#app-eas").css("opacity", 0.0)
        }, duration)
    }

    functions.displayEAS = function(faction, message, scrollDuration) {
        $("#app-eas").css("opacity", 1.0)
        functions.scrollMarquee(faction, message, scrollDuration)
    }

    function diffHours(dt2, dt1) {
        var diff =(dt2.getTime() - dt1.getTime()) / 1000;
        diff /= (60 * 60);
        return Math.abs(Math.round(diff));
    }

    function getPermissions() {
        var permissions = {};
    
        $("input[permission-name]").each(function () {
            permissions[$(this).attr("permission-name")] = $(this).is(':checked');
        });
    
        return permissions;
    }

    function setPermissions(data) {
        $.each(data, function (k, v) {
            $("input[permission-name='" + k + "']").prop('checked', v)
        });
    }

    function clearPermissions() {
        $("input[permission-name]").each(function () {
            $(this).prop('checked', false)
        });
    }

    $(document).on("click", "#closeMap", function () {
        $.post('https://kk-factions/closeMap', JSON.stringify({}))
        $('#app-map').hide();
    });

    function loadingBar(val) {
        if (val) {
            $('#indeterminate').show(); actionPossible = false
        } else {
            $('#indeterminate').hide(); actionPossible = true
        }
    }
});