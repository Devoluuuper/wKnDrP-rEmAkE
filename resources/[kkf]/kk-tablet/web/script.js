$(document).ready(function () {
    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27') {
            $.post('https://kk-tablet/closeTablet', JSON.stringify({}));
        }
    });

    functions = {}; 
    let actionPossible = true;

    let selectedJob = 0;
    let jobActive = false;

    let selectedBoostingContract = 0;
    let boostingContractActive = false;

    updateClock();
	function updateClock() {
		var today = new Date();

		$("#time").text(("0" + today.getHours()).slice(-2) + ":" + ("0" + today.getMinutes()).slice(-2));
        $("#date").text(("0" + today.getDate()).slice(-2) + "." + ("0"+(today.getMonth()+1)).slice(-2) + "." + today.getFullYear());

		setTimeout(updateClock, 5000);
	}

    window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'open') {
            $('body').show();

            if (event.apps.droppy) {
                $('#foodApp').show()
            } else {
                $('#foodApp').hide()
            }

            if (event.apps.boosting) { 
                $('#boostingApp').show()
            } else {
                $('#boostingApp').hide()
            }

            if (event.apps.selling) { 
                $('#sellingApp').show()
            } else {
                $('#sellingApp').hide()
            }

            if (event.apps.racing) { 
                $('#racingApp').show()
            } else {
                $('#racingApp').hide()
            }
        } else if (event.action === 'close') {
            $('body').hide()
        } else if (event.action === 'reloadFoods') {
            functions.loadFoodApp()
        } else if (event.action === 'reloadSelling') {
            functions.loadSellingApp()
        } else if (event.action === 'reloadBoosting') {
            functions.loadBoostApp() 
        } else if (event.action === 'removeContractInfo') {
            boostingContractActive = false; selectedBoostingContract = 0
            $('#boostInfo').hide(); $('#noBoostInfo').show(); $('#buyYourselfContract').show(); $('#sellBoostingContract').show(); $('#acceptBoostingContract').show(); $('#boostingTimeLeft').show();
        } else if (event.action === 'removeJobInfo') {
            jobActive = false; selectedJob = 0
            $('#foodJobAccept').show(); $('#foodJobWaypoint').hide(); $('#foodJobCancel').hide(); $('#foodInfo').hide(); $('#noFoodInfo').show()
        } else if (event.action === 'removeSellingJobInfo') {
            jobActive = false; selectedJob = 0
            $('#SellingContrJobAccept').show(); $('#SellingContrJobWaypoint').hide(); $('#SellingContrJobCancel').hide(); $('#SellingContrInfo').hide(); $('#noSellingContrInfo').show()
        } else if (event.action === 'sellingStop') {
            $("#sellItemsJobQueueToggle").html('Alusta tööotsade saamist');

            $('#sellItemsJobQueueToggle').removeClass('bg-red-800 hover:bg-red-900');
            $('#sellItemsJobQueueToggle').addClass('bg-green-700 hover:bg-green-800');
        }
    });

    $(document).on("click", "#closeTablet", function () {
        $.post('https://kk-tablet/closeTablet', JSON.stringify({}));
    });

let isReceiving = false;

$(document).on("click", "#foodJobWaypoint", function () {
    if (actionPossible && jobActive) {
        loadingBar(true);

        $.post('https://kk-tablet/setWaypoint', JSON.stringify({}), function(cb) {
            loadingBar(false);
        });
    }
}); 

$(document).on("click", "#foodJobCancel", function () {
    if (actionPossible && jobActive) {
        loadingBar(true);

        $.post('https://kk-tablet/cancelJob', JSON.stringify({id: selectedJob}), function(cb) {
            loadingBar(false);
            jobActive = false;
            selectedJob = 0;

            $('#foodJobAccept').show();
            $('#foodJobWaypoint').hide();
            $('#foodJobCancel').hide();
            $('#foodInfo').hide();
            $('#noFoodInfo').show();
        });
    }
}); 

$(document).on("click", "#foodJobAccept", function () {
    if (actionPossible && !jobActive) {
        loadingBar(true);

        $.post('https://kk-tablet/acceptJob', JSON.stringify({id: selectedJob}), function(cb) {
            loadingBar(false); 

            if (cb) {
                jobActive = true;
                $('#foodJobAccept').hide();
                $('#foodJobWaypoint').show();
                $('#foodJobCancel').show();
            } else {
                functions.loadFoodApp();
            }
        });
    }
});

$(document).on("click", "#foodJobQueueToggle", function () {
    if (actionPossible && !jobActive) {
        loadingBar(true);

        isReceiving = !isReceiving;
        $.post('https://kk-tablet/setRecieve', JSON.stringify({state: isReceiving}), function(cb) {
            loadingBar(false);

            if (cb) {
                $("#foodJobQueueToggle").html('Lõpeta tööotsade saamine');
                $('#foodJobQueueToggle').addClass('bg-red-800 hover:bg-red-900');
                $('#foodJobQueueToggle').removeClass('bg-green-700 hover:bg-green-800');
            } else {
                isReceiving = false;
                $("#foodJobQueueToggle").html('Alusta tööotsade saamist');
                $('#foodJobQueueToggle').removeClass('bg-red-800 hover:bg-red-900');
                $('#foodJobQueueToggle').addClass('bg-green-700 hover:bg-green-800');
            }
        });   
    }
});

$(document).on("click", ".selectFood", function () {
    if (actionPossible && !jobActive) {
        loadingBar(true);
        selectedJob = $(this).data('id') + 1;

        $.post('https://kk-tablet/loadJob', JSON.stringify({id: selectedJob}), function(cb) {
            loadingBar(false);
            $('#foodInfoItems').html('');

            $.each(cb.items, function(k, v) {
                $('#foodInfoItems').append(`
                    <div class="bg-zinc-800 border border-zinc-700 rounded shadow flex h-12">
                        <img src="nui://ox_inventory/web/images/${k}.png">
                        <p class="mt-auto mb-auto font-medium uppercase text-sm">${v.label} (${v.count}x)</p>
                    </div>
                `);
            });

            $('#foodInfo').show();
            $('#noFoodInfo').hide();
        });   
    }
});

functions.loadFoodApp = function() {
    if (actionPossible) {
        loadingBar(true);

        $.post('https://kk-tablet/loadFood', JSON.stringify({}), function(cb) {
            loadingBar(false);
            $('#contractList').html('');
            $('#foodJobTop').html('');

            $('#foodJobsCompleted').text(cb.done || 0);
            $('#foodJobsEarned').text(cb.earned || 0);

            $.each(cb.contracts, function(k, v) {
                if (v != 'chosen') {
                    $('#contractList').append(`
                        <div data-id="${k}" class="bg-sky-800 rounded shadow text-sm p-0.5 cursor-pointer selectFood mb-1">
                            <div class="font-medium text-center">Tellimus</div>
                            <div class="border-b border-zinc-300"></div>
                            <div class="flex justify-center"> 
                                <p class="mx-6">Teenite: $${v.price}</p>
                            </div>
                        </div>
                    `);
                }
            });

            $.each(cb.top || [], function(k, v) {
                $('#foodJobTop').append(`
                <div class="bg-zinc-800 border border-zinc-700 shadow rounded block px-2 py-1.5 mb-1">
                    ${v}
                </div>
            `);
        });

        });   
    }
};

    $(document).on("click", ".selectSelling", function () {
    if (actionPossible && !jobActive) {
        loadingBar(true);
        selectedJob = parseInt($(this).data('id')) || 0;
        console.log('Selected contract ID:', selectedJob);

        if (selectedJob === 0) {
            console.error('Error: Invalid contract ID selected');
            loadingBar(false);
            return;
        }

        $.post('https://kk-tablet/loadJobSelling', JSON.stringify({ id: selectedJob }), function(cb) {
            loadingBar(false);
            console.log('loadJobSelling response:', JSON.stringify(cb, null, 2));
            $('#SellingContrInfoItems').html('');
            if (!cb.items) {
                console.log('No items received for contract ID:', selectedJob);
                return;
            }

            $.each(cb.items, function(k, v) {
                console.log('Rendering item:', v.label, 'count:', v.count);
                $('#SellingContrInfoItems').append(`
                    <div class="bg-zinc-900 border border-zinc-700 rounded shadow flex h-12">
                        <img src="nui://ox_inventory/web/images/${v.image || k + '.png'}" 
                             onerror="this.src='nui://ox_inventory/web/images/default.png'" 
                             class="w-10 h-10 object-contain">
                        <p class="mt-auto mb-auto font-medium uppercase text-sm">${v.label || 'Unknown'} (${v.count || 0}x)</p>
                    </div>
                `);
            });

            $('#SellingContrInfo').show();
            $('#noSellingContrInfo').hide();
        });
    }
});

    functions.loadBoostApp = function() {
        if (actionPossible) {
            loadingBar(true);

            if (selectedBoostingContract != 0) {
                $.post('https://kk-tablet/loadBoostingContract', JSON.stringify({id: selectedBoostingContract}), function(cb) {
                    $('#boostingTimeRemaining').text(toHoursAndMinutes(cb.expires));
                })
            }

            $.post('https://kk-tablet/loadBoostingData', JSON.stringify({}), function(cb) {
                loadingBar(false);
                $('#boostingList').html('')
                $('#boostContractTop').html('')

                $('#boostingCurrentClass').text(cb.class);
                $('#boostingNextClass').text(cb.nextClass);

                $('#boostContractsCompleted').text(cb.done);
                $('#boostEarned').text(cb.earned);
    
                $.each(cb.contracts, function(k, v){
                    if (v != 'chosen') {
                        $('#boostingList').append(`
                            <div data-id="${k}" class="cursor-pointer selectBoostingContract bg-zinc-800 border border-zinc-700 shadow rounded block px-2 py-1.5 mb-1">
                                <div class="flex">
                                    <div class="bg-zinc-900 border border-zinc-700 rounded-full w-12 h-12 flex">
                                        <p class="m-auto">${v.class}</p>
                                    </div>

                                    <div class="ml-1">
                                        <p class="ml-0.5 mt-auto mb-auto">Sõiduki ${v.vehicleLabel} boostingu leping</p>

                                        <div class="flex">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M11.25 11.25l.041-.02a.75.75 0 011.063.852l-.708 2.836a.75.75 0 001.063.853l.041-.021M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9-3.75h.008v.008H12V8.25z" />
                                            </svg>
                                            
                                            <p class="text-xs ml-0.5 mt-auto mb-auto">${v.class} klassi sõiduk, numbrimärgiga ${v.plate}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        `);
                    }
                });

                $.each(cb.top, function(k, v){
                    $('#boostContractTop').append(`
                        <div class="bg-zinc-800 border border-zinc-700 shadow rounded block px-2 py-1.5 mb-1">
                            ${v}
                        </div>
                    `);
                });
            })   
        }
    }

        $(document).on("click", "#boostingQueueToggle", function () {
        if (actionPossible && !jobActive) {
            loadingBar(true);

            $.post('https://kk-tablet/setBoostingRecieve', JSON.stringify(), function(cb) {
                loadingBar(false);

                if (cb) {
                    $("#boostingQueueToggle").html('Lõpeta tööotsade saamine');

                    $('#boostingQueueToggle').addClass('bg-red-800 hover:bg-red-900');
                    $('#boostingQueueToggle').removeClass('bg-green-700 hover:bg-green-800');
                } else {
                    $("#boostingQueueToggle").html('Alusta tööotsade saamist');

                    $('#boostingQueueToggle').removeClass('bg-red-800 hover:bg-red-900');
                    $('#boostingQueueToggle').addClass('bg-green-700 hover:bg-green-800');
                }
            })   
        }
    });

    $(document).on("click", "#acceptBoostingContract", function () {
        if (actionPossible && selectedBoostingContract != 0) {
            loadingBar(true);

            $.post('https://kk-tablet/acceptBoostingContract', JSON.stringify({id: selectedBoostingContract, type: 'regular'}), function(cb) {
                loadingBar(false); 

                if (cb) {
                    boostingContractActive = true;

                    $('#boostingEarning').text('Tasu: $' + cb.prize); 
                    $('#buyYourselfContract').hide(); $('#sellBoostingContract').hide(); $('#acceptBoostingContract').hide(); $('#boostingTimeLeft').hide();
                } else {
                    functions.loadBoostApp()
                }
            })
        }
    }); 

    $(document).on("click", "#declineBoostingContract", function () {
        if (actionPossible && selectedBoostingContract != 0) {
            loadingBar(true);

            $.post('https://kk-tablet/cancelBoost', JSON.stringify({ id: selectedBoostingContract }), function(cb) {
                loadingBar(false); boostingContractActive = false; selectedBoostingContract = 0

                $('#boostInfo').hide(); $('#noBoostInfo').show(); $('#buyYourselfContract').show(); $('#sellBoostingContract').show(); $('#acceptBoostingContract').show(); $('#boostingTimeLeft').show();
            })
        }
    }); 

    // selling

    $(document).on("click", "#sellItemsJobQueueToggle", function () {
        if (actionPossible && !jobActive) {
            loadingBar(true);

            $.post('https://kk-tablet/setSellingRecieve', JSON.stringify(), function(cb) {
                loadingBar(false);

                if (cb) {
                    $("#sellItemsJobQueueToggle").html('Lõpeta tööotsade saamine');

                    $('#sellItemsJobQueueToggle').addClass('bg-red-800 hover:bg-red-900');
                    $('#sellItemsJobQueueToggle').removeClass('bg-green-700 hover:bg-green-800');
                } else {
                    $("#sellItemsJobQueueToggle").html('Alusta tööotsade saamist');

                    $('#sellItemsJobQueueToggle').removeClass('bg-red-800 hover:bg-red-900');
                    $('#sellItemsJobQueueToggle').addClass('bg-green-700 hover:bg-green-800');
                }
            })   
        }
    });

    // uuendus

$(document).on("click", "#SellingContrJobAccept", function () {
    if (actionPossible && !jobActive) {
        loadingBar(true);
        console.log('Accepting contract ID:', selectedJob);

        if (selectedJob === 0) {
            console.error('Error: Cannot accept contract with ID 0');
            loadingBar(false);
            return;
        }

        $.post('https://kk-tablet/acceptJobSelling', JSON.stringify({ id: selectedJob }), function(cb) {
            loadingBar(false);
            console.log('acceptJobSelling response:', JSON.stringify(cb, null, 2));

            if (cb.success) {
                jobActive = true;
                $('#SellingContrJobAccept').hide();
                $('#SellingContrJobWaypoint').show();
                $('#SellingContrJobCancel').show();
            } else {
                console.log('Failed to accept contract ID:', selectedJob);
                functions.loadSellingApp();
            }
        });
    }
});

$(document).on("click", "#SellingContrJobCancel", function () {
    if (actionPossible && jobActive) {
        loadingBar(true);
        console.log('Cancelling contract ID:', selectedJob);

        if (selectedJob === 0) {
            console.error('Error: Cannot cancel contract with ID 0');
            loadingBar(false);
            return;
        }

        $.post('https://kk-tablet/cancelJobSelling', JSON.stringify({ id: selectedJob }), function(cb) {
            loadingBar(false);
            console.log('cancelJobSelling response:', JSON.stringify(cb, null, 2));
            jobActive = false;
            selectedJob = 0;

            $('#SellingContrJobAccept').show();
            $('#SellingContrJobWaypoint').hide();
            $('#SellingContrJobCancel').hide();
            $('#SellingContrInfo').hide();
            $('#noSellingContrInfo').show();
        });
    }
});

    $("#hovering").hover(
        function () {
            $("body").css("opacity", "0.5");
        },

        function () {
            $("body").css("opacity", "1");
        }
    );

functions.loadSellingApp = function() {
    if (actionPossible) {
        loadingBar(true);

        $.post('https://kk-tablet/loadSellingData', JSON.stringify({}), function(cb) {
            loadingBar(false);
            console.log('Received selling data:', JSON.stringify(cb, null, 2));

            $('#sellItemsJobsCompleted').text(cb.done || 0);
            $('#sellItemsJobsEarned').text((cb.earned || 0)); // Lisa $ märk
            $('#contractListSelling').html('');

            $.each(cb.contracts, function(k, v) {
                console.log('Rendering contract ID:', v.id);
                $('#contractListSelling').append(`
                    <div data-id="${v.id}" class="bg-sky-800 rounded shadow text-sm p-0.5 cursor-pointer selectSelling mb-1">
                        <div class="font-medium text-center">Tööots</div>
                        <div class="border-b border-zinc-300"></div>
                        <div class="flex justify-center"> 
                            <p class="mx-6">Teenite: $${v.price}</p>
                        </div>
                    </div>
                `);
            });
        });
    }
};

    //
    $(document).on("click", "#sellBoostingContract", function () {
        if (actionPossible && selectedBoostingContract != 0) {
            loadingBar(true);

            $.post('https://kk-tablet/sellBoostingContract', JSON.stringify({ id: selectedBoostingContract }), function(cb) {
                loadingBar(false);

                if (cb) {
                    $.post('https://kk-tablet/closeTablet', JSON.stringify({}));

                    boostingContractActive = false; selectedBoostingContract = 0
            $('#boostInfo').hide(); $('#noBoostInfo').show(); $('#buyYourselfContract').show(); $('#sellBoostingContract').show(); $('#acceptBoostingContract').show();  $('#boostingTimeLeft').show();
                }
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