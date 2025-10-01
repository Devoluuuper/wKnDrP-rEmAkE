$(document).ready(function () {
    functions = {}

    let currentCase = 0;
    let currentCandidation = 0;
    let currentStatement = 0;
    let officer = {"name": "", "department": "", "departmentImg": ""};
    let currentProfile = {"citizenid": 0, "plate": "", "firstname": "", "lastname": ""}
    const licenseLabels = {"dmv": "Juhiluba", "health": "Tervisetõend", "weapon": "Relvaluba", "heli":"Kopter"};

    let actionPossible = true;
    let punishmentList = {};
    let dg_translations = {};
    let punishmentsChosen = [];
    let myPermissions = {};
    let chosenDepartment = 0;
    let chosenWorker = 0;
    let myJob = 'ambulance';
    let materialPunishment = {
        "totalFine": 0,
        "totalJail": 0,
        "reduction": 0
    }

    window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'open') {
            $('#mdt').show()

            var punishments = $("#punishmentList");
            $(punishments).html("");

            punishmentList = event.data.punishments;
            myPermissions = event.data.permissions;
            dg_translations = event.data.translate
            officer.name = event.data.name
            officer.department = event.data.department.label
            officer.departmentImg = event.data.department.logo

            $('#officerHomeName').html(officer.name)
            $('#officerDepartmentName').html(officer.department)
            $('#departmentLogo').attr('src', officer.departmentImg)


            $('#caseOfficerDipla').val(officer.name);
            $('#caseOfficerNice').val(officer.name);

            $.each(event.data.punishments, function(k, v){
                $(punishments).append(`
                    <div data-punishment="${k}" data-tooltip="${v.tooltipContent}" class="bg-${v.color} rounded shadow text-sm p-0.5 h-min cursor-pointer choosePunishment">
                        <div class="text-xs font-medium text-center">${v.label}</div>
            
                        <div class="border-b border-zinc-300"></div>
            
                        <div class="text-xs flex justify-center"> 
                            <p class="mx-6">${v.jail} kuud</p>
                            <p class="mx-6">$${v.fine}</p>
                            <p class="mx-6">${v.points} punkti</p>
                        </div>
                    </div>
                `);
            });            
            
            if (officer.department === 'Los Santos Police Department' || officer.department === 'Deputy Commissioner' || officer.department === 'Commissioner') {
                $('#docDiplaDoc').show()
                $('#doc_prisoners1').removeClass('hidden'); $('#doc_prisoners2').removeClass('hidden')
            } else {
                $('#docDiplaDoc').hide()
                $('#doc_prisoners1').addClass('hidden'); $('#doc_prisoners2').addClass('hidden')
            }



            myJob = event.data.job;

            if (myJob === 'ambulance') {
                $('#createCaseButton').removeClass('hidden')
                $('#documentsPage3').removeClass('hidden'); $('#documentsPage4').removeClass('hidden')

                $('#staffPage1').addClass('hidden'); $('#staffPage2').addClass('hidden')
                $('#vehiclePage1').addClass('hidden'); $('#vehiclePage2').addClass('hidden')
                $('#documentsPage1').addClass('hidden'); $('#documentsPage2').addClass('hidden')
                $('#statements1').addClass('hidden'); $('#statements2').addClass('hidden')
                $('#det_folder1').addClass('hidden'); $('#det_folder2').addClass('hidden')
                $('#casesPolice').addClass('hidden')

                $('#wanted').addClass('hidden');
                $('#licenses').addClass('hidden');
            } else if (myJob === 'police') {
                $('#createCaseButton').addClass('hidden')
                $('#documentsPage3').addClass('hidden'); $('#documentsPage4').addClass('hidden')
                $('#vehiclePage1').removeClass('hidden'); $('#vehiclePage2').removeClass('hidden')
                $('#documentsPage1').removeClass('hidden'); $('#documentsPage2').removeClass('hidden')
                $('#statements1').removeClass('hidden'); $('#statements2').removeClass('hidden')
                $('#det_folder1').removeClass('hidden'); $('#det_folder2').removeClass('hidden')
                $('#casesPolice').removeClass('hidden')

                $('#wanted').removeClass('hidden');
                $('#licenses').removeClass('hidden');
            }
        } else if (event.action === 'close') {
            $('#mdt').hide()
        } else if (event.action === 'showBadge') {
            $('#badgeCallsign').text('#' + event.data.callsign);
            $('#badgeRank').text(event.data.rank);
            $('#badgeName').text(event.data.name); 
            $('#badgeMark').attr('src', event.data.badge);
            $('#badgeDepartment').text(event.data.department);
            $('#badgeImage').attr('src', event.data.profile);
            $('#badge').fadeIn(400);
            setTimeout(() => {
                $('#badge').fadeOut(400); 
            }, 7500);
        }
    });

    $("#hovering").hover(
        function () {
            $("#mdt").css("opacity", "0.5");
        },

        function () {
            $("#mdt").css("opacity", "1");
        }
    );

    functions.loadStaffPage = function(callback) {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-mdt/loadStaffPage', JSON.stringify({}), function(cb) {
                loadingBar(false);

                if (cb) {
                    $('#departmentList').html('');

                    $.each(cb, function(k, v){
                        if (v.id != 0) {
                            $('#departmentList').append(`
                                <div class="flex gap-1 justify-between bg-zinc-800 border border-zinc-700 shadow rounded block p-2 w-full mb-1">
                                    <div class="flex">
                                        <img class="h-12" src="${v.logo}">

                                        <div class="ml-1 mt-auto mb-auto">
                                            <h1 class="text-md">${v.label}</h1>
                                            <h1 class="text-sm">Liikmeid: ${v.members}</h1>
                                        </div>
                                    </div>

                                    <svg data-department="${v.id}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="chooseDepartment cursor-pointer mt-auto mb-auto w-8 h-8">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10" />
                                    </svg>
                                </div>
                            `);
                        }
                    });

                    if (callback) callback()
                }
            })   
        }
    } 

    $(document).on("click", "#saveDepartment", function () {
        if (actionPossible && chosenDepartment != 0) {
            loadingBar(true);

            $.post('https://kk-mdt/saveDepartment', JSON.stringify({ id: chosenDepartment, label: $('#departmentName').val(), blip_color: $('#departmentColor').val(), logo: $('#departmentImage').val() }), function(cb) {
                loadingBar(false); functions.loadStaffPage()
            })  
        }
    });

    $(document).on("click", "#deleteDepartment", function () {
        if (actionPossible && chosenDepartment != 0) {
            loadingBar(true);

            $.post('https://kk-mdt/deleteDepartment', JSON.stringify({ id: chosenDepartment }), function(cb) {
                loadingBar(false); functions.loadStaffPage()
            })  
        }
    });

    $(document).on("click", ".chooseDepartment", function () {
        if (actionPossible) {
            chosenDepartment = $(this).data('department')
            loadingBar(true);

            $.post('https://kk-mdt/loadDepartment', JSON.stringify({department: chosenDepartment }), function(cb) {
                loadingBar(false);

                $('#departmentName').val(cb.label);
                $('#departmentColor').val(cb.blip_color);
                $('#departmentImage').val(cb.logo);
            })  
        }
    }); 

    $(document).on("click", ".toggleCertificate", function () {
        if (actionPossible && chosenWorker != 0) {
            let item = $(this);
            let cert = item.data('id');
            loadingBar(true);

            $.post('https://kk-mdt/toggleCertificate', JSON.stringify({ worker: chosenWorker, cert: cert }), function(cb) {
                loadingBar(false);


                if (cb === true) {
                    item.addClass('bg-green-50').addClass('text-green-700').addClass('ring-green-600/20');
                    item.removeClass('bg-red-50').removeClass('text-red-700').removeClass('ring-red-600/20');
                } else if (cb === false) {
                    item.addClass('bg-red-50').addClass('text-red-700').addClass('ring-red-600/20');
                    item.removeClass('bg-green-50').removeClass('text-green-700').removeClass('ring-green-600/20');
                } else {
                }

                $.post('https://kk-mdt/loadWorkerProfile', JSON.stringify({ citizenid: chosenWorker }), function(data) {
                    if (data && data.certificates && Array.isArray(data.certificates)) {
                        $('#certificateList').html('');
                        $.each(data.certificates, function(k, v) {
                            const certClass = v.value 
                                ? "bg-green-50 text-green-700 ring-green-600/20"
                                : "bg-red-50 text-red-700 ring-red-600/20";
                            $('#certificateList').append(`
                                <div data-id="${v.id}" class="toggleCertificate inline-flex items-center rounded px-2 py-1 text-xs font-medium ring-1 ring-inset cursor-pointer ${certClass}">
                                    ${v.label}
                                </div>
                            `);
                        });
                    }
                })
            })
        }
    });

    $(document).on("click", ".loadWorkerProfile", function () {
        if (!actionPossible) return;

        chosenWorker = $(this).data('citizenid');
        loadingBar(true);

        $.post('https://kk-mdt/loadWorkerProfile', JSON.stringify({ worker: chosenWorker }), function(cb) {
            loadingBar(false);

            if (!cb) return;

            const officerName = cb.name || "Unknown Officer";
            $('#workerName').text(officerName);
            $('#officerHomeName').text(officerName);

            $('#workerDepartments').html('');
            if (cb.departments && Array.isArray(cb.departments)) {
                $.each(cb.departments, function(k, v){
                    let selected = (cb.department === v.id) ? 'selected' : '';
                    $('#workerDepartments').append(`
                        <option ${selected} value="${v.id}" class="text-white bg-zinc-800">${v.label}</option>
                    `);
                });
            }
            
            $('#certificateList').html('');
            if (cb.certificates && Array.isArray(cb.certificates)) {
                $.each(cb.certificates, function(k, v) {
                    const certClass = v.value 
                        ? "bg-green-50 text-green-700 ring-green-600/20"
                        : "bg-red-50 text-red-700 ring-red-600/20";
                    $('#certificateList').append(`
                        <div data-id="${v.id}" class="toggleCertificate inline-flex items-center rounded px-2 py-1 text-xs font-medium ring-1 ring-inset cursor-pointer ${certClass}">
                            ${v.label}
                        </div>
                    `);
                });
            }
            $('#casesPollar').hide();
            $('#copCases').html('');
            if (cb.cases) {
                $.each(cb.cases, function(k, v){
                    $('#casesPollar').show();
                    $("#copCases").append(`
                        <div data-id="${v.id}" data-page="yes" class="flex gap-1 justify-between bg-zinc-800 border border-zinc-700 shadow rounded block p-2 w-full mb-1 cursor-pointer openCase hover:border-sky-500 hover:text-sky-500">
                            <div class="flex">
                                <div class="ml-1 mt-auto mb-auto">
                                    <h1 class="text-md">${v.title}</h1>
                                    <h1 class="text-sm">Roll: ${v.role}</h1>
                                </div>
                            </div>
                        </div>
                    `);
                });
            }

            $('#workerCallsign').val(cb.police_profile?.callsign || cb.callsign || "");
        });
    });


    $(document).on("click", "#saveWorkerProfile", function () {
        if (actionPossible && chosenWorker != 0) {
            loadingBar(true);

            $.post('https://kk-mdt/saveWorkerProfile', JSON.stringify({ id: chosenWorker, department:  $('#workerDepartments').val(), callsign: $('#workerCallsign').val() }), function(cb) {
                loadingBar(false); functions.loadStaffPage(function() {
                    functions.departentProfileSearch()
                }); 
            })  
        }
    });

    $(document).on("click", "#buyBadge", function () {
        if (actionPossible && chosenWorker != 0) {
            loadingBar(true);

            $.post('https://kk-mdt/buyBadge', JSON.stringify({ worker: chosenWorker }), function(cb) {
                loadingBar(false);
            })  
        }
    });

    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27') {
            $.post('https://kk-mdt/closeTablet', JSON.stringify({}));
        }
    });

$('#vehicleSearch').keyup(function(e) {
    if (e.keyCode === 13) {
        if (actionPossible) {
            var vehicleList = $("#vehicleProfileList");

            $(vehicleList).html("");
            loadingBar(true);

            $.post('https://kk-mdt/searchVehicles', JSON.stringify({ value: $('#vehicleSearch').val() }), function(cb) {
                loadingBar(false);

                $.each(cb, function(k, v) {
                    let plate = v.plate || "PUUDUB";

                    // Kui vehicle on objekt, siis võta label eelistatult, kui pole, siis model
                    let vehicleName = "Unknown";
                    if (v.vehicle && typeof v.vehicle === "object") {
                        vehicleName = v.vehicle.label || v.vehicle.model || "Unknown";
                    } else if (typeof v.vehicle === "string") {
                        vehicleName = v.vehicle;
                    }

                    let owner = v.ownername || "PUUDUB";

                    $(vehicleList).append(`
                        <div class="flex justify-between bg-zinc-800 border border-zinc-700 shadow rounded block p-2 w-full mb-1">
                            <div class="block">
                                <h1 class="text-md">${vehicleName} - ${plate}</h1>
                                <p class="text-sm">Omanik: ${owner}</p>
                            </div>

                            <svg data-plate="${plate}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="loadVehicleProfile cursor-pointer mt-auto mb-auto w-8 h-8">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
                            </svg>
                        </div>
                    `);
                });
            });
        }
    }
});



    $(document).on('mouseenter', '.choosePunishment', function() {
        // Get the tooltip content from the data attribute
        var tooltipContent = $(this).data('tooltip');
    
        // Create a tooltip element
        var tooltip = $('<div class="tooltip absolute bg-zinc-800 border border-zinc-700 text-white px-2.5 py-1 rounded shadow z-50 pointer-events-none whitespace-nowrap text-xs"></div>').text(tooltipContent).appendTo('body');
    
        // Position the tooltip
        $(this).mousemove(function(e) {
            tooltip.css({
                top: e.pageY + 10 + 'px',
                left: e.pageX + 10 + 'px'
            });
        });
    
    }).on('mouseleave', '.choosePunishment', function() {
        // Remove the tooltip when mouse leaves the element
        $('.tooltip').remove();
    });

    function loadVehicleProfile(plate, refresh) {
    if (actionPossible && (currentProfile.plate != plate || refresh)) {
        loadingBar(true)

        $.post('https://kk-mdt/loadVehicleProfile', JSON.stringify({ plate: plate }), function(cb) {
            loadingBar(false);
            
            // Turvaline fallback
            let vehicleObj = {};
            if (cb.vehicle && typeof cb.vehicle === "object") {
                vehicleObj = cb.vehicle;
            } else if (cb.vehicle && typeof cb.vehicle === "string") {
                vehicleObj = { model: cb.vehicle };
            }

            const model = vehicleObj.model || "Unknown Model";
            const ownerName = cb.ownername || "PUUDUB";
            const citizenid = cb.citizenid || "";

            currentProfile.plate = cb.plate || "";
            
            $('#vehicleModel').html(model);
            $('#vehiclePlate').html(cb.plate || "");
            $('#vehicleOwner').html(ownerName);
            $('#vehicleOwner').data("opid", citizenid);

            // Tagaotsitav
            if (cb.wantedReason && cb.wantedReason != '') {
                $('#vehicleWanted').html('<span class="text-red-500">JAH</span>'); 
                $('#vehicleWantedReason').val(cb.wantedReason)
            } else {
                $('#vehicleWanted').html('<span class="text-green-500">EI</span>'); 
                $('#vehicleWantedReason').val('')
            }

            // Impound logid
            $('#impLogsContainer').hide()
            $('#impoundLogs').html('');
            $.each(cb.impoundLogs || [], function(k, v){
                $('#impLogsContainer').show()
                if (v.time === 'X') {
                    $('#impoundLogs').prepend(`
                        <div class="flex justify-between bg-zinc-800 border border-zinc-700 shadow rounded block p-2 w-full mb-1">
                            <div class="block">
                                <h1 class="text-md">${v.date} - ${v.text}</h1>
                                <p class="text-sm">${v.impounder} eemaldas teisaldusest.</p>
                            </div>
                        </div>
                    `);
                } else {
                    $('#impoundLogs').prepend(`
                        <div class="flex justify-between bg-zinc-800 border border-zinc-700 shadow rounded block p-2 w-full mb-1">
                            <div class="block">
                                <h1 class="text-md">${v.date} - ${v.text}</h1>
                                <p class="text-sm">${v.impounder} teisaldas ajaga ${v.time} päeva.</p>
                            </div>
                        </div>
                    `);
                }
            });

            // Punishments
            $('#vehiclePunishmentsContainer').hide()
            $('#vehiclePunishments').html('');
            $.each(cb.punishments || [], function(k, v){
                $('#vehiclePunishmentsContainer').show();
                $("#vehiclePunishments").append(`
                    <div data-id="${v.id}" data-page="yes" class="flex gap-1 justify-between bg-zinc-800 border border-zinc-700 shadow rounded block p-2 w-full mb-1 cursor-pointer openCase hover:border-sky-500 hover:text-sky-500">
                        <div class="flex">
                            <div class="ml-1 mt-auto mb-auto">
                                <h1 class="text-md">${v.title}</h1>
                                <h1 class="text-sm">Roll: ${v.role}</h1>
                            </div>
                        </div>
                    </div>
                `);
            });
        })   
    }
}



    let reloadCooldown = false;

    $(document).on("click", "#profileRefresh", function () {
        if (reloadCooldown) return

        if (actionPossible && currentProfile.citizenid != 0) {
            loadProfile(currentProfile.citizenid, true)

            reloadCooldown = true;

            setTimeout(() => {
                reloadCooldown = false;
            }, 2500);
        }
    }); 

    $(document).on("click", "#vehicleRefresh", function () {
        if (reloadCooldown) return

        if (actionPossible && currentProfile.plate != '') {
            loadVehicleProfile(currentProfile.plate, true);

            reloadCooldown = true;

            setTimeout(() => {
                reloadCooldown = false;
            }, 2500);
        }
    }); 

    $(document).on("click", "#profileImage", function () {
        if (actionPossible && currentProfile.citizenid != 0) {
            loadingBar(true);

            $.post('https://kk-mdt/profileImage', JSON.stringify({ identifier: currentProfile.citizenid }), function(cb) {
                loadingBar(false);

                if (cb) {
                    $.post('https://kk-mdt/closeTablet', JSON.stringify({}));
                }
            })   
        }
    }); 

$(document).on("click", "#saveWantedProfile", function () {
    if (actionPossible && currentProfile.citizenid != 0) {
        loadingBar(true);

        const reason = $('#profileWantedReason').val();

        $.post('https://kk-mdt/updateWantedProfile', JSON.stringify({ 
            citizenid: currentProfile.citizenid, // õige võtme nimi
            value: reason 
        }), function(cb) {
            loadingBar(false);

            if (cb) {
                if (reason && reason !== "") {
                    $('#profileWanted').html('<span class="text-red-500">JAH</span>');
                } else {
                    $('#profileWanted').html('<span class="text-green-500">EI</span>');
                    $('#profileWantedReason').val('');
                }
            }
        });
    }
});


    $(document).on("click", "#saveWantedVehicle", function () {
        if (actionPossible && currentProfile.plate != '') {
            loadingBar(true);

            $.post('https://kk-mdt/updateWantedVehicle', JSON.stringify({ plate: currentProfile.plate, value: $('#vehicleWantedReason').val() }), function(cb) {
                loadingBar(false);

                if (cb != '') {
                    $('#vehicleWanted').html('<span class="text-red-500">JAH</span>');
                } else {
                    $('#vehicleWanted').html('<span class="text-green-500">EI</span>');
                }
            })   
        }
    }); 

    $(document).on("click", ".loadVehicleProfile", function () {
        loadVehicleProfile($(this).data('plate'));
    });

    $('#profileSearch').keyup(function(e){
        if (e.keyCode === 13) {
            if (actionPossible) {
                var playerList = $("#playerList");

                $(playerList).html("");
                loadingBar(true);
    
                $.post('https://kk-mdt/search', JSON.stringify({ value: $('#profileSearch').val() }), function(cb) {
                    loadingBar(false);
    
                    $.each(cb, function(k, v){
                        $(playerList).append(`
                            <div class="flex justify-between bg-zinc-800 border border-zinc-700 shadow rounded block p-2 w-full mb-1">
                                <div class="block">
                                    <h1 class="text-md">${v.name}</h1>
                                    <p class="text-sm">State ID: ${v.citizenid}</p>
                                </div>
                    
                                <svg data-citizenid="${v.citizenid}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="loadProfile cursor-pointer mt-auto mb-auto w-8 h-8">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
                                </svg>
                            </div>
                        `);
                    });                    
                })   
            }
        }
    });

functions.departentProfileSearch = function() {
    if (!actionPossible) return;

    const departmentMemberList = $("#departmentMemberList");
    departmentMemberList.html(""); 
    loadingBar(true);

    $.post('https://kk-mdt/searchDepartmentMembers', JSON.stringify({ value: $('#departmentProfileSearch').val() }), function(cb) {
        loadingBar(false);

        if (!cb || cb.length === 0) return;

        $.each(cb, function(k, v){
            // Kasuta departmentLabel ja departmentLogo
            const departmentName = v.departmentLabel || "test";

            departmentMemberList.append(`
                <div class="flex justify-between bg-zinc-800 border border-zinc-700 shadow rounded block p-2 w-full mb-1">
                    <div class="flex items-center">
                        <div>
                            <h1 class="text-md">${v.firstname || "Unknown"} ${v.lastname || "Unknown"}</h1>
                            <p class="text-sm">Struktuurüksus: ${departmentName}</p>
                        </div>
                    </div>

                    <svg data-citizenid="${v.citizenid}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="loadWorkerProfile cursor-pointer mt-auto mb-auto w-8 h-8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
                    </svg>
                </div>
            `);
        });
    });
}



    $('#departmentProfileSearch').keyup(function(e){
        if (e.keyCode === 13) {
            functions.departentProfileSearch()
        }
    });

    $(document).on("click", "#saveNotes", function () {
        if (actionPossible && currentProfile.citizenid != 0) {
            const notes = $('#profileNotes').val() || ''; // Fallback to empty string
            if (!notes.trim()) {
                console.log('Error: Notes field is empty');
                alert('Please enter notes before saving.');
                return;
            }
            
            loadingBar(true);
            console.log('Sending saveNotes:', { citizenid: currentProfile.citizenid, value: notes });
            
            $.post('https://kk-mdt/saveNotes', JSON.stringify({ 
                citizenid: currentProfile.citizenid, 
                value: notes 
            }), function(cb) {
                loadingBar(false);
                if (cb.success) {
                    console.log('Notes saved successfully:', notes);
                    $('#profileNotes').val(notes); // Immediately update UI with saved notes
                } else {
                    console.log('Failed to save notes:', cb.message);
                    alert('Failed to save notes: ' + cb.message);
                }
            });
        } else {
            console.log('Error: Invalid citizenid or action not possible', { 
                citizenid: currentProfile?.citizenid, 
                actionPossible 
            });
            alert('Cannot save notes: No profile selected.');
        }
    });
    $(document).on("click", "#closeTablet", function () {
        $.post('https://kk-mdt/closeTablet', JSON.stringify({}));
    }); 

    function clearDiagnoseCreation() {
        $('#diagnoseDescription').val(''); $('#diagnoseDoneItems').val(''); $('#diagnoseDamages').val(''); clearPrescriptions()
    }

    function clearCaseCreation() {
        punishmentsChosen = []; $('#selectedPunishments').html(''); 
        $('#fineSelected').val(''); $('#jailSelected').val(''); $('#reductionSelected').val(''); 
        $('#caseDescription').val(''); $('#pleaQuilty').prop('checked', false);
        $('#reqAvocad').prop('checked', false); $('#chosenPunishments').val('')
        
        materialPunishment.totalFine = 0
        materialPunishment.totalJail = 0
        materialPunishment.reduction = 0
    }


function loadProfile(citizenid, refresh) {
    if (actionPossible && (currentProfile.citizenid != citizenid || refresh)) {
        loadingBar(true);
        if (!refresh) clearCaseCreation();

        $.post('https://kk-mdt/loadProfile', JSON.stringify({ value: citizenid }), function(cb) {
            loadingBar(false);
            if (!cb) return console.log("No profile data received");

            currentProfile = cb;

            // Peamine info
            $('#profilePermanentId').html(cb.citizenid || "Unknown");
            $('#profileName').html(cb.name || "Unknown Player");
            $('#profileBirthDate').html(cb.birthdate || "Unknown");
            $('#profilePoints').html(cb.strikePoints || 0);
            $('#diagnoseDamages').val('');
            $('#profileImage').attr('src', cb.profilepic || "https://i.imgur.com/placeholder.png");

            // Wanted info
            if (cb.wanted && cb.wanted !== "") {
                $('#profileWanted').html('<span class="text-red-500">JAH</span>');
                $('#profileWantedReason').val(cb.wanted_reason || "");
            } else {
                $('#profileWanted').html('<span class="text-green-500">EI</span>');
                $('#profileWantedReason').val('');
            }

            // Märkmed
            if (myJob === 'police') {
                $('#profileNotes').val(cb.notes || "");
            } else if (myJob === 'ambulance') {
                $('#profileNotes').val(cb.notes_ambulance || "");
            }

            // --- LITSENTSID ---
            $("#licensesList").html(""); // puhasta eelmine sisu
            if (cb.licenses && typeof cb.licenses === "object") {
                for (const key in cb.licenses) {
                    if (cb.licenses[key]) {
                        $("#licensesList").append(`
                            <div data-license="${key}" class="flex justify-between bg-zinc-800 border border-zinc-700 shadow px-1 py-0.5 rounded shadow">
                                <p>${licenseLabels[key]}</p>
                            </div>
                        `);
                    }
                }
            } else {
                $("#licensesList").append('<div class="text-gray-400 text-sm col-span-3">Litsentse ei leitud</div>');
            }

            // --- SÕIDUKID ---
            $("#vehicleList").html("");
            if (cb.vehicles && cb.vehicles.length > 0) {
                const vehicleModels = cb.vehicles.map(v => v.model || "unknown");

                $.post('https://kk-mdt/getVehicleLabels', JSON.stringify({ models: vehicleModels }), function(labels) {
                    $('#vehicles').show();
                    $("#vehicleList").empty();

                    $.each(cb.vehicles, function(_, v) {
                        const vehicleLabel = labels[v.model] || v.model || "Unknown Vehicle";
                        const plate = v.plate || "N/A";
                        const callsign = cb.callsign || "";

                        $("#vehicleList").append(`
                            <div data-vplate="${plate}" class="loadVehicleFromProfile cursor-pointer bg-zinc-800 border border-zinc-700 shadow rounded p-2 mb-1 text-sm">
                                ${vehicleLabel} - ${plate}
                            </div>
                        `);
                    });
                });
            }
        });
    }
}



    $(document).on("click", ".removeLicense", function () {
        let element = $(this)
        let license = element.parent().data('license');
        loadingBar(true);
    
        $.post('https://kk-mdt/removeLicense', JSON.stringify({ target: currentProfile.citizenid, license: license  }), function(cb) {
            loadingBar(false)

            if (cb) {
                element.parent().remove()
            }
        }) 
    }); 

    $(document).on("click", ".loadProfile", function () {
        loadProfile($(this).data('citizenid'));
    });

    function refreshList() {
        let punText = ''; 
        let fine = 0; 
        let jail = 0;
    
        // Initialize a variable to keep track of the maximum jail time
        let maxJail = 0;
    
        $.each(punishmentsChosen, function(k, v){
            punText = punText + punishmentList[v].label + '; ';
            fine += punishmentList[v].fine; // Accumulate the fines
            jail += punishmentList[v].jail; // Accumulate the jail times
    
            // Update the maximum jail time if the current punishment has a higher value
            if (punishmentList[v].jail > maxJail) {
                maxJail = punishmentList[v].jail;
            }
        });
    
        // Set the fine to the maximum jail time found
        jail = maxJail;
    
        if (!currentQuilt) {
            fine += 10000; 
        }

        materialPunishment.totalJail = jail;
        materialPunishment.totalFine = fine;
    
        $('#chosenPunishments').val(punText);
        $("#fineSelected").val(fine);
        $("#jailSelected").val(jail);
    
        setTimeout(() => {
            setPunishmentTotals();
        }, 50);
    }    

    let canEditProtocol = false;
    let punTimeout = false;

    $(document).on("click", ".choosePunishment", function () {
        let element = $(this);
        let id = element.data('punishment');

        if (!punTimeout) {
            if (canEditProtocol) {
                punTimeout = true

                setTimeout(() => {
                    punTimeout = false 
                }, 500);
    
                if (!punishmentsChosen.includes(id)) {
                    punishmentsChosen.push(id)
        
                    element.addClass('border-2 border-green-500')
        
                    refreshList()
                } else {
                    removeFromArray(punishmentsChosen, id)
        
                    element.removeClass('border-2 border-green-500')
        
                    refreshList()
                }
            }
        }
    });

    function calculateStrike() {
        let points = 0;
        const uniquePunishments = new Set();
    
        $.each(punishmentsChosen, function(k, v) {
            if (!uniquePunishments.has(v)) {
                uniquePunishments.add(v);
                points += punishmentList[v].points;
                console.log(punishmentList[v].label);
            }
        });
    
        return points;
    }
    

    $(document).on("click", "#punish", function () {
        if (actionPossible && currentProfile.citizenid != 0) {
            let cachePid = currentProfile.citizenid;

            if (myJob === 'police') {
                if (punishmentsChosen.length > 0) {
                    loadingBar(true);
    
                    $.post('https://kk-mdt/createCase', JSON.stringify({ target: currentProfile.citizenid, description: $('#caseDescription').val(), fine: $('#fineSelected').val(), jail: $('#jailSelected').val(), punishments: $('#chosenPunishments').val(), strikePoints: calculateStrike() }), function(cb) {
                        if (cb) {
                            $("#createCase").fadeOut(300, function () {
                                $("#profileData").fadeIn(100, function () {
                                    loadingBar(false); clearCaseCreation()
        
                                    currentProfile.citizenid = 0; loadProfile(cachePid)
                                });
                            });
                        } else {
                            loadingBar(false)
                        }
                    }) 
                }
            } else if (myJob === 'ambulance') {
                loadingBar(true);
    
                $.post('https://kk-mdt/createDiagnose', JSON.stringify({ target: currentProfile.citizenid, description: $('#diagnoseDescription').val(), done: $('#diagnoseDoneItems').val(), damages: $('#diagnoseDamages').val(), bill: $('#diagnoseBill').val(), intensive: $('#diagnoseIntensive').val(), prescriptions: getPrescriptions() }), function(cb) {
                    if (cb) {
                        $("#createDiagnose").fadeOut(300, function () {
                            $("#profileData").fadeIn(100, function () {
                                loadingBar(false); clearDiagnoseCreation()
    
                                currentProfile.citizenid = 0; loadProfile(cachePid)
                            });
                        });
                    } else {
                        loadingBar(false)
                    }
                }) 
            }
        }
    });

    function getPrescriptions() {
        var permissions = {};
    
        $("input[prescription]").each(function () {
            permissions[$(this).attr("prescription")] = $(this).is(':checked');
        });
    
        return permissions;
    }

    function clearPrescriptions() {
        $("input[prescription]").each(function () {
            $(this).prop('checked', false)
        });
    }

    $("#reductionSelected").change(function() {
        var newValue = $(this).val();

        if (newValue > 50) {
            newValue = 50;
        } else if (newValue < 0) {
            newValue = 0;
        }

        $(this).val(newValue);
        materialPunishment.reduction = newValue;
        setPunishmentTotals();
    });

    function setPunishmentTotals() {
        $('#jailSelected').val(Math.round(materialPunishment.totalJail * (1 - materialPunishment.reduction / 100)));
        $('#fineSelected').val(Math.round(materialPunishment.totalFine * (1 - materialPunishment.reduction / 100)));
    }

    function removeFromArray(array, id) {
        const index = array.indexOf(id);

        if (index > -1) {
            array.splice(index, 1);
        }
    }

    $(document).on("click", "#backToCase", function () {
        if (actionPossible && currentProfile.citizenid != 0) {
            actionPossible = false;

            $("#selectPunishments").fadeOut(300, function () {
                $("#createCase").fadeIn(100); actionPossible = true;
            });
        }
    });

    $(document).on("click", "#choosePunishments", function () {
        if (actionPossible && currentProfile.citizenid != 0) {
            actionPossible = false;

            $("#createCase").fadeOut(300, function () {
                $("#selectPunishments").fadeIn(100); actionPossible = true;
            });
        } 
    });

    $(document).on("click", "#backToProfile", function () {
        if (actionPossible && currentProfile.citizenid != 0) {
            if (myJob === 'police') {
                actionPossible = false;

                $("#createCase").fadeOut(300, function () {
                    $("#profileData").fadeIn(100); actionPossible = true;
                });
            } else if (myJob === 'ambulance') {
                actionPossible = false;

                $("#createDiagnose").fadeOut(300, function () {
                    $("#profileData").fadeIn(100); actionPossible = true;
                });
            }
        }
    });

    $(document).on("click", "#createCaseButton", function () {
        if (actionPossible && currentProfile.citizenid != 0) {
            if (myJob === 'ambulance') {
                // TODO AMBULANCE

                actionPossible = false;

                $('#diagnosePerson').val(currentProfile.firstname + ' ' + currentProfile.lastname);
                $('#diagnoseMedic').val(officer.name);
    
                $("#profileData").fadeOut(300, function () {
                    $("#createDiagnose").fadeIn(100); actionPossible = true;
                });
            }
        }
    });

    $(document).on("click", ".loadVehicleFromProfile", function () {
        let cachePlate = $(this).data('vplate');

        if (actionPossible) {
            $.post('https://kk-mdt/setPage', JSON.stringify({ page: 'vehicles' }), function(cb) {
                loadVehicleProfile(cachePlate);
            });
        }
    });

    $(document).on("click", "#vehicleOwner", function () {
        if (actionPossible) {
            if (currentProfile.plate != "") {
                if (($('#vehicleOwner').html()).search('faction_')) {
                    $.post('https://kk-mdt/setPage', JSON.stringify({ page: 'profiles' }), function(cb) {
                        loadProfile(($('#vehicleOwner').data('opid')));
                    });
                }
            }
        }
    });

    $(document).on("click", "#loadFixedDamages", function () {
        if (actionPossible && currentProfile.citizenid != 0) {
            loadingBar(true);

            $.post('https://kk-mdt/loadDamages', JSON.stringify({}), function(cb) {
                loadingBar(false);

                if (cb) {
                    let newValue = '';
                    $('#diagnoseDamages').val('');

                    //$.each(cb, function(k, v) {
                    //    newValue = newValue + '[' + (k + +1) + '] - Tüüp: ' + v.type + '; Asukoht: ' + dg_translations[v.name] + '; \n'
                    //});

                    $('#diagnoseDamages').val(newValue);
                } else {
                    $('#diagnoseDamages').val('PUUDUVAD');
                }
            })
        }
    });

    $('#candidationSearch').keyup(function(e){
        if (e.keyCode === 13) {
            if (actionPossible) {
                var candidationList = $("#candidationList");

                $(candidationList).html("");
                loadingBar(true);
        
                $.post('https://kk-mdt/searchCandidations', JSON.stringify({ value: $('#candidationSearch').val() }), function(cb) {
                    loadingBar(false);

                    if (cb && Array.isArray(cb)) {
                        $.each(cb, function(k, v){
                            let date = v.date ? new Date(v.date * 1000) : new Date();
                            let time = ('0'+date.getHours()).slice(-2)+":"+('0'+date.getMinutes()).slice(-2)+" "+('0'+date.getDate()).slice(-2)+"."+('0'+(date.getMonth()+1)).slice(-2)+"."+date.getFullYear();
                            
                            $(candidationList).append(`
                                <div class="flex justify-between bg-zinc-800 border border-zinc-700 shadow rounded block p-2 w-full mb-1">
                                    <div class="block">
                                        <h1 class="text-md">${v.name}</h1>
                                        <p class="text-sm">State ID: ${v.citizenid || 'Unknown'} - ${time}</p>
                                    </div>
                                    <svg data-id="${v.id}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="loadCandidation cursor-pointer mt-auto mb-auto w-8 h-8">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
                                    </svg>
                                </div>
                            `);
                        });
                    }
                })   
            }
        }
    });

    $(document).on("click", "#removeCandidation", function () {
        if (actionPossible && currentCandidation != 0) {
            loadingBar(true)

            $.post('https://kk-mdt/removeCandidation', JSON.stringify({ value: currentCandidation }), function(cb) {
                loadingBar(false);

                if (cb) {
                    currentCandidation = 0;
                    $('#candidationStateId').html('‎');
                    $('#candidationName').html('‎');
                    $('#candidationEmail').html('‎');
                    $('#candidationDate').html('‎');
                    $('#candidationInfo').val('');
                }
            })  
        }
    });

    function loadCandidation(id) {
        if (actionPossible && currentCandidation != id) {
            loadingBar(true)

            $.post('https://kk-mdt/loadCandidation', JSON.stringify({ value: id }), function(cb) {
                loadingBar(false);

                if (cb) {
                    let date = cb.date ? new Date(cb.date * 1000) : new Date();
                    let time = ('0'+date.getHours()).slice(-2)+":"+('0'+date.getMinutes()).slice(-2)+" "+('0'+date.getDate()).slice(-2)+"."+('0'+(date.getMonth()+1)).slice(-2)+"."+date.getFullYear();
                    
                    currentCandidation = cb.id;
                    $('#candidationStateId').html(cb.citizenid || 'Unknown');
                    $('#candidationName').html(cb.name);
                    $('#candidationEmail').html(cb.email);
                    $('#candidationInfo').val(cb.text);
                    $('#candidationDate').html(time);
                }
            })   
        }
    }

    $(document).on("click", ".loadCandidation", function () {
        loadCandidation($(this).data('id'));
    });
    $('#statementSearch').keyup(function(e){
        if (e.keyCode === 13) {
            if (actionPossible) {
                var statementList = $("#statementList");

                $(statementList).html("");
                loadingBar(true);

                $.post('https://kk-mdt/searchStatements', JSON.stringify({ value: $('#statementSearch').val() }), function(cb) {
                    loadingBar(false);

                    $.each(cb, function(k, v){
                        // Kui timestamp on sekundites, korruta 1000-ga
                        let timestamp = v.date ? parseInt(v.date) * 1000 : Date.now();
                        let date = new Date(timestamp);

                        let time = ('0'+date.getHours()).slice(-2)+":"+('0'+date.getMinutes()).slice(-2)+" "+
                                ('0'+date.getDate()).slice(-2)+"."+('0'+(date.getMonth()+1)).slice(-2)+"."+date.getFullYear();

                        $(statementList).append(`
                            <div class="flex justify-between bg-zinc-800 border border-zinc-700 shadow rounded block p-2 w-full mb-1">
                                <div class="block">
                                    <h1 class="text-md">${v.name || 'Unknown'}</h1>
                                    <p class="text-sm">State ID: ${v.citizenid || 'Unknown'} - ${time}</p>
                                </div>

                                <svg data-citizenid="${v.citizenid}" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="loadStatement cursor-pointer mt-auto mb-auto w-8 h-8">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
                                </svg>
                            </div>
                        `);
                    });
                })   
            }
        }
    });

    $(document).on("click", "#removeStatement", function () {
        if (actionPossible && currentStatement != 0) {
            loadingBar(true)

            $.post('https://kk-mdt/removeStatement', JSON.stringify({ value: currentStatement }), function(cb) {
                loadingBar(false);

                if (cb) {
                    currentStatement = 0;
                    $('#statementStateId').html('‎');
                    $('#statementName').html('‎');
                    $('#statementEmail').html('‎');
                    $('#statementDate').html('‎');
                    $('#statementInfo').val('');
                }
            })  
        }
    });

    function formatDate(timestamp){
    let ts = timestamp ? parseInt(timestamp)*1000 : Date.now();
    let d = new Date(ts);
        return ('0'+d.getHours()).slice(-2)+":"+
            ('0'+d.getMinutes()).slice(-2)+" "+
            ('0'+d.getDate()).slice(-2)+"."+
            ('0'+(d.getMonth()+1)).slice(-2)+"."+d.getFullYear();
    } 

    function loadStatement(citizenid) {
        if (actionPossible && currentStatement != citizenid) {
            loadingBar(true)

            $.post('https://kk-mdt/loadStatement', JSON.stringify({ value: citizenid }), function(cb) {
                loadingBar(false);

               if (cb) {
                
                let timestamp = cb.date ? parseInt(cb.date) * 1000 : Date.now();
                let date = new Date(timestamp);

                let time = ('0'+date.getHours()).slice(-2)+":"+('0'+date.getMinutes()).slice(-2)+" "+
                        ('0'+date.getDate()).slice(-2)+"."+('0'+(date.getMonth()+1)).slice(-2)+"."+date.getFullYear();

                currentStatement = cb.citizenid;
                $('#statementStateId').html(cb.citizenid || 'Unknown');
                $('#statementName').html(cb.name || 'Unknown');
                $('#statementEmail').html(cb.email || 'Unknown');
                $('#statementInfo').val(cb.text || '');
                $('#statementDate').html(time);
            }

            })   
        }
    }

    $(document).on("click", ".loadStatement", function () {
        loadStatement($(this).data('citizenid'));
    });

    function loadingBar(val) {
        if (val) {
            $('#loader').show(); actionPossible = false
        } else {
            $('#loader').hide(); actionPossible = true
        }
    }

    let selectedDoc = 0;
    let DocplayerName = '';

    $(document).on("click", ".closeNiceBehaviour", function () {
        if (actionPossible) {
            $('#niceBehavior').fadeOut(200, function() {
                $(this).addClass('hidden').removeClass('flex');
            });
            selectedDoc = 0;
        }
    });
    
    $(document).on("click", ".setNiceBehavior", function () {
        if (actionPossible) {
            selectedDoc = $(this).parent().parent().parent().data('identifier');
            DocplayerName = $(this).parent().parent().parent().data('name')

            $('#casePersonNice').val(DocplayerName)
            $('#niceBehavior').hide().removeClass('hidden').addClass('flex').fadeIn(200);
        }
    });
    
    $(document).on("click", "#niceBehaviorAccept", function () {
        if (actionPossible) {
            loadingBar(true)
            $('#niceBehavior').hide().removeClass('flex').addClass('hidden').fadeOut(200);

            if (selectedDoc != 0) {
                $.post('https://kk-mdt/niceBehaviorAccept', JSON.stringify({id: selectedDoc, desc: $('#caseDescriptionNice').val(), value: $('#niceValue').val(), name: DocplayerName}), function(cb) {
                    loadingBar(false)
                });
            } else {
                loadingBar(false)
            }

            selectedDoc = 0;
            DocplayerName = '';

            functions.reloadDoc()
        }
    });
    
    //
    
    $(document).on("click", ".closeDiplaModal", function () {
        if (actionPossible) {
            $('#diplaModal').fadeOut(200, function() {
                $(this).addClass('hidden').removeClass('flex');
            });
            selectedDoc = 0;
        }
    });
    
    $(document).on("click", ".setDipla", function () {
        if (actionPossible) {
            selectedDoc = $(this).parent().parent().parent().data('identifier');
            DocplayerName = $(this).parent().parent().parent().data('name')

            $('#casePersonDipla').val(DocplayerName)
            $('#diplaModal').hide().removeClass('hidden').addClass('flex').fadeIn(200);
        }
    });
    
    $(document).on("click", "#diplaAccept", function () {
        if (actionPossible) {
            loadingBar(true)
            $('#diplaModal').hide().removeClass('flex').addClass('hidden').fadeOut(200);

            if (selectedDoc != 0) {
                $.post('https://kk-mdt/diplaAccept', JSON.stringify({id: selectedDoc, desc: $('#caseDescriptionDipla').val(), value: $('#diplaValue').val(), name: DocplayerName}), function(cb) {
                    loadingBar(false);
                });
            } else {
                loadingBar(false)
            }

            selectedDoc = 0;
            DocplayerName = '';

            functions.reloadDoc()
        }
    });

    $(document).on("click", "#refreshDocPage", function () {
        if (actionPossible) {
            functions.reloadDoc();
        }
    });

    functions.reloadDoc = function() {
        loadingBar(true);

        $.post('https://kk-mdt/refreshDocPage', JSON.stringify({}), function(cb) {
            loadingBar(false); 
            $('#docList').html('');

            if (cb) {
                $.each(cb, function(k, v) {
                    // Määrame vaikimisi väärtuse, kui v.jail puudub
                    const jailTime = typeof v.jail !== "undefined" ? v.jail : 0;

                    $('#docList').prepend(`
                        <div data-identifier="${v.identifier}" data-name="${v.name}" class='border bg-zinc-800 shadow rounded border-1 border-zinc-700 p-2 mb-1 h-min'>
                            <div class='flex justify-between'>
                                <p class="ml-2 my-auto text-sm text-zinc-200">${v.name}</p>

                                <div>
                                    <button class="setDipla px-2 py-0.5 bg-red-700 hover:bg-red-700 rounded shadow text-white">
                                        Distsiplinaarmenetlus
                                    </button>

                                    <button class="setNiceBehavior px-2 py-0.5 bg-green-700 hover:bg-green-700 rounded shadow text-white">
                                        Eeskujulik käitumine
                                    </button>
                                </div>
                            </div>

                            <hr class="m-2 border-t-2 text-zinc-200">

                            <div class='flex justify-between'>
                                <p class="ml-2 text-lg font-medium text-zinc-200">Hetkene karistus: ${jailTime} kuud</p>
                            </div>
                        </div>
                    `);
                });
            } else {
                $('#docList').html('<p class="text-sm text-gray-400">Andmeid ei leitud</p>');
            }
        });  
    }


    //

    $(document).on("click", ".closeCasePersonSelect", function () {
        if (actionPossible) {
            $('#policeCasePersonSelect').fadeOut(200, function() {
                $(this).addClass('hidden').removeClass('flex');
            });
        }
    });
    
    $(document).on("click", "#policeCaseAddPersons", function () {
        if (actionPossible) {
            $('#policeCasePersonSelect').hide().removeClass('hidden').addClass('flex').fadeIn(200);
        }
    });
    
    $(document).on("click", "#a", function () {
        if (actionPossible) {
            loadingBar(true)
            $('#policeCasePersonSelect').hide().removeClass('flex').addClass('hidden').fadeOut(200);

        }
    });

    //

    $(document).on("click", ".closeCasesAddMember", function () {
        if (actionPossible) {
            $('#casesAddMember').fadeOut(200, function() {
                $(this).addClass('hidden').removeClass('flex');
            });
        }
    });
    
    $(document).on("click", "#addCaseMember", function () {
        if (actionPossible && currentCase != 0) {
            $('#casesAddMember').hide().removeClass('hidden').addClass('flex').fadeIn(200);
        }
    });

    $(document).on("click", ".openCase", function () {
        if (actionPossible) {
            let id = $(this).data('id');

            if ($(this).data('page') === 'yes') {
                $.post('https://kk-mdt/setPage', JSON.stringify({ page: 'cases_police' })) 
            }

            functions.loadCase(id, function(status) {
                if (status) {
                    $("#policeCaseListing").fadeOut(300, function () {
                        $("#policeCaseInformation").fadeIn(100);
                    })
                }
            });
        }
    });

    $(document).on("click", "#closeCaseFile", function () {
        if (actionPossible) {
            $("#policeCaseInformation").fadeOut(300, function () {
                $("#policeCaseListing").fadeIn(100);
            });
        }
    });

    $(document).on("click", "#createNewCase", function () {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-mdt/createNewCase', JSON.stringify({}), function(cb) {
                loadingBar(false);

                $("#policeCaseListing").fadeOut(300, function () {
                    functions.loadCase(cb, function() {
                        $("#policeCaseInformation").fadeIn(100);
                    })
                });
            }) 
        }
    });

    // editCaseNameModal

    $(document).on("click", "#policeCaseInfoEditorConfirm", function () {
        if (actionPossible && currentCase != 0) {
            loadingBar(true);

            $.post('https://kk-mdt/updateInfo', JSON.stringify({ case: currentCase, title: $('#policeCaseTitleModel').val(), description: $('#policeCaseDescriptionModel').val() }), function(cb) {
                loadingBar(false);

                if (cb) {
                    $('#policeCaseTitle').text($('#policeCaseTitleModel').val()); adjustFontSize($('#policeCaseTitleModel').val())
                    $('#policeCaseDescription').text($('#policeCaseDescriptionModel').val());

                    $('#policeCaseEditorName').text(`${cb.last_editor.firstname} ${cb.last_editor.lastname}`)

                    let lastEdit = formatDate(cb.last_edit);
                    $('#policeCaseLastEdit').text(lastEdit)

                    $('#policeCaseTitleModel').val('');
                    $('#policeCaseDescriptionModel').val('');

                    $('#editCaseNameModal').hide().removeClass('flex').addClass('hidden').fadeOut(200);
                }
            }) 
        }
    });

    $(document).on("click", "#policeCaseInfoEditor", function () {
        if (actionPossible && currentCase != 0) {
            loadingBar(true);

            $.post('https://kk-mdt/requestInfo', JSON.stringify({case: currentCase}), function(cb) {
                loadingBar(false);

                if (cb) {
                    $('#policeCaseTitleModel').val(cb.title);
                    $('#policeCaseDescriptionModel').val(cb.description);

                    $('#editCaseNameModal').hide().removeClass('hidden').addClass('flex').fadeIn(200);
                }
            }) 
        }
    });

    $(document).on("click", ".closeEditCaseNameModal", function () {
        if (actionPossible) {
            $('#editCaseNameModal').hide().removeClass('flex').addClass('hidden').fadeOut(200);

            $('#policeCaseTitleModel').val('');
            $('#policeCaseDescriptionModel').val('');
        }
    });

    $(document).on("click", "#caseFileRefresh", function () {
        if (actionPossible && currentCase != 0 && !reloadCooldown) {
            reloadCooldown = true
            functions.loadCase(currentCase)

            setTimeout(() => {
                reloadCooldown = false;
            }, 2500);
        }
    });

    //

    $('#caseSearch').keyup(function(e){
        if (e.keyCode === 13) {
            if (actionPossible) {
                var caseList = $("#casesList");

                $(caseList).html("");
                loadingBar(true);
    
                $.post('https://kk-mdt/searchCases', JSON.stringify({ value: $('#caseSearch').val() }), function(cb) {
                    loadingBar(false);
    
                    $.each(cb, function(k, v){
                        let lastEdit = formatDate(v.last_edit);

                        $(caseList).append(`
                            <div data-id="${v.id}" class="flex gap-1 justify-between bg-zinc-800 border border-zinc-700 shadow rounded block p-2 w-full mb-1 cursor-pointer openCase hover:border-sky-500 hover:text-sky-500">
                                <div class="flex">
                                    <div class="ml-1 mt-auto mb-auto">
                                        <h1 class="text-md">${v.title}</h1>
                                        <h1 class="text-sm">Viimati redigeeriti ${lastEdit}</h1>
                                    </div>
                                </div>
                            </div>
                        `);
                    });
                })   
            }
        }
    });

    function formatDate(unixTimestamp) {
        const date = new Date(unixTimestamp * 1000);
    
        const day = date.getDate();
        const month = date.toLocaleString('et-EE', { month: 'long' });
        const year = date.getFullYear();
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
    
        return `${day}. ${month} ${year} kell ${hours}:${minutes}`;
    }

    function tableCount(table) {
        let number = 0;

        $.each(table, function(k, v){
            number += 1
        });

        return number;
    }

    function adjustFontSize(title) {
    var titleElement = $('#policeCaseTitle');
    var baseFontSize = 1; // Base font size in rem
    var minFontSize = 0.625; // Minimum font size in rem

    // Fallback kui title on undefined või null
    title = title || "";

    // Calculate the number of characters
    var titleLength = title.length;

    // Start with the base font size
    var newFontSize = baseFontSize;

    // Reduce the font size based on title length
    if (titleLength > 5) {
        newFontSize -= Math.floor((titleLength - 5) / 5) * 0.125; // Decrease by 0.125 rem for every 5 letters over 5
    }

    // Ensure the font size does not go below the minimum size
    if (newFontSize < minFontSize) {
        newFontSize = minFontSize;
    }

    // Apply the new font size
    titleElement.css('font-size', newFontSize + 'rem');
}

    function formatTimestamp(timestamp) {
    if (!timestamp || isNaN(timestamp)) return 'PUUDUB';
    let date = new Date(timestamp * 1000); // eeldades UNIX timestamp sekundites
    let day = String(date.getDate()).padStart(2, '0');
    let month = String(date.getMonth() + 1).padStart(2, '0');
    let year = date.getFullYear();
    let hours = String(date.getHours()).padStart(2, '0');
    let minutes = String(date.getMinutes()).padStart(2, '0');
    return `${day}.${month}.${year} kell ${hours}:${minutes}`;
}

functions.loadCase = function(id, callback) {
    if (!actionPossible) return;

    loadingBar(true);

    $.post('https://kk-mdt/loadCase', JSON.stringify({ id: id }), function(cb) {
        loadingBar(false);

        if (!cb) {
            if (callback) callback(false);
            return;
        }

        currentCase = cb.id;

        // Pealkiri ja staatus
        $('#policeCaseId').text(cb.id);
        $('#policeCaseTitle').text(cb.title || "Puudub");
        adjustFontSize(cb.title || "Puudub");
        $('#policeCaseStatus').text(cb.status || "Puudub");
        $('#caseFileStatus').val(cb.status || "");

        let date = cb.date ? formatDate(cb.date) : "-";
        let lastEdit = cb.last_edit ? formatDate(cb.last_edit) : "-";
        $('#policeCaseDate').text(date);

        // Officers
        $('#policeCaseOfficersTable').html('');
        $.each(cb.officers || [], function(k, v) {
            let firstname = v.firstname || "Unknown";
            let lastname = v.lastname || "Unknown";
            let callsign = v.callsign || "Puudub";
            let grade = v.grade || "Unknown";
            let role = v.role || "Unknown";
            let identifier = v.identifier || "-";

            console.log(`Officer ${firstname} ${lastname} (identifier: ${identifier}): grade = ${grade}, callsign = ${callsign}, role = ${role}`);

            $('#policeCaseOfficersTable').append(`
                <div data-id="${identifier}" class="bg-zinc-900 hover:bg-zinc-800 px-4 py-5 grid grid-cols-5 gap-4 border-t border-zinc-700">
                    <dd class="text-sm text-white">${callsign}</dd>
                    <dd class="openCaseProfile underline cursor-pointer text-sm text-white">${firstname} ${lastname}</dd>
                    <dd class="text-sm text-white">${grade}</dd>
                    <dd class="text-sm text-white">${role}</dd>
                    <dd class="flex text-sm text-white justify-center items-center gap-4">
                        <svg class="editCaseOfficer h-5 w-5 cursor-pointer text-blue-500" ...></svg>
                        <svg class="removeCaseOfficer h-5 w-5 cursor-pointer text-red-500" ...></svg>
                    </dd>
                </div>
            `);
        });

        // Detectives
        $('#policeCaseDetective').text(cb.detective || 'Sellele juhtumile ei ole uurijat määratud!');

        // Members (kahtlustatavad, ohvrid jne)
        $('#policeCaseItemPersons').html('');
        $('#policeCasePersonsTable').html('');
        $.each(cb.members || [], function(k, v){
            let identifier = v.identifier || "-";
            let firstname = v.firstname || "Unknown";
            let lastname = v.lastname || "Unknown";
            let role = v.role || "Unknown";

            $('#policeCaseItemPersons').append(`<option value="${identifier}">${firstname} ${lastname}</option>`);

            $('#policeCasePersonsTable').append(`
                <div data-id="${identifier}" class="bg-zinc-900 hover:bg-zinc-800 px-4 py-5 grid grid-cols-4 gap-4 border-t border-zinc-700">
                    <dd class="text-sm text-white">${identifier}</dd>
                    <dd class="openCaseProfile underline cursor-pointer text-sm text-white">${firstname} ${lastname}</dd>
                    <dd class="text-sm text-white">${role}</dd>
                    <dd class="flex text-sm text-white justify-center items-center gap-4">
                        <svg class="editCaseMember h-5 w-5 cursor-pointer text-blue-500" ...></svg>
                        <svg class="removeCaseMember h-5 w-5 cursor-pointer text-red-500" ...></svg>
                    </dd>
                </div>
            `);
        });

        // Confiscated Vehicles
        $('#policeCaseConfiscatedVehiclesTable').html('');
        $.each(cb.vehicles || [], function(k, v){
            let vehicleName = (v.vehicle && v.vehicle.model) ? v.vehicle.model : (typeof v.vehicle === "string" ? v.vehicle : "Unknown");
            let plate = v.plate || "Unknown";
            let officer = v.officer || "-";

            $('#policeCaseConfiscatedVehiclesTable').append(`
                <div data-id="${plate}" data-uuid="${v.uuid || ''}" class="bg-zinc-900 hover:bg-zinc-800 px-4 py-5 grid grid-cols-4 gap-4 border-t border-zinc-700">
                    <dd class="text-sm text-white">${vehicleName}</dd>
                    <dd class="loadVehicleProfile underline cursor-pointer text-sm text-white" data-plate="${plate}">${plate}</dd>
                    <dd class="text-sm text-white">${officer}</dd>
                    <dd class="flex text-sm text-white justify-center items-center gap-4">
                        <svg class="removeVehicleItem h-5 w-5 cursor-pointer text-red-500" ...></svg>
                    </dd>
                </div>
            `);
        });

        // Confiscated Items
        $('#policeCaseConfiscatedItemsTable').html('');
        $.each(cb.confiscatedItems || [], function(k, v){
            let firstname = v.firstname || "Unknown";
            let lastname = v.lastname || "Unknown";
            let name = v.name || "Unknown";
            let amount = v.amount || 0;
            let officer = v.officer || "-";

            $('#policeCaseConfiscatedItemsTable').append(`
                <div data-id="${v.identifier}" data-uuid="${v.uuid}" class="bg-zinc-900 hover:bg-zinc-800 px-4 py-5 grid grid-cols-5 gap-4 border-t border-zinc-700">
                    <dd class="text-sm text-white">${name}</dd>
                    <dd class="text-sm text-white">${amount}x</dd>
                    <dd class="openCaseProfile underline cursor-pointer text-sm text-white">${firstname} ${lastname}</dd>
                    <dd class="text-sm text-white">${officer}</dd>
                    <dd class="flex text-sm text-white justify-center items-center gap-4">
                        <svg class="removeConfiscatedItem h-5 w-5 cursor-pointer text-red-500" ...></svg>
                    </dd>
                </div>
            `);
        });

        // Creator & Last Editor
        $('#policeCaseCreatorName').text(cb.creator?.name || "PUUDUB");
        $('#policeCaseEditorName').text(cb.last_editor?.name || "PUUDUB");
        $('#policeCaseLastEdit').text(lastEdit);

        if (callback) callback(true);
    });
};

$('#casePlayerName').keyup(function(e){
    if (e.keyCode === 13) {
        if (actionPossible && currentCase != 0) {
            var playerList = $("#casePlayerSearchResults");
            playerList.html("");
            loadingBar(true);

            $.post('https://kk-mdt/searchCasePlayer', JSON.stringify({ search: $('#casePlayerName').val() }), function(players) {
                loadingBar(false);

                if (players && players.length > 0) {
                    $.each(players, function(_, v){
                        playerList.append(`
                            <div data-id="${v.citizenid}" class="playerSearchObject flex flex-col items-center gap-4 bg-zinc-900 p-4 rounded border border-zinc-700 hover:border-sky-500 transition duration-200">
                                <img src="${v.profilepic}" alt="${v.firstname} ${v.lastname}" class="w-16 h-16 rounded-full object-cover border border-zinc-700">
                                <div class="text-white space-y-1">
                                    <p class="text-sm"><strong>Nimi:</strong> ${v.firstname} ${v.lastname}</p>
                                    <p class="text-sm"><strong>Sünnikuupäev:</strong> ${v.birthdate}</p>
                                    <p class="text-sm"><strong>State ID:</strong> ${v.citizenid}</p>
                                </div>
                            </div>
                        `);
                    });
                } else {
                    playerList.append(`
                        <div class="text-center text-sm text-zinc-500" id="no-results">Ei leitud ühtegi vastet!</div>
                    `);
                }
            });
        }
    }
});


   

    $(document).on("click", ".playerSearchObject", function () {
        if (actionPossible && currentCase != 0) {
            loadingBar(true);

            let id = $(this).data('id');

            let currentType = $("#casePlayerType").val();
            let currentRole = $('#casePlayerRole').val();

            $.post('https://kk-mdt/addPersonCase', JSON.stringify({ case: currentCase, identifier: id, type: currentType, role: currentRole }), function(cb) {
                loadingBar(false);

                if (cb) {
                    functions.loadCase(currentCase)

                    $('#casesAddMember').fadeOut(200, function() {
                        $('#casePlayerName').val('');
                        $('#mySelect').val('civil');
                        $('#casePlayerRole').val('')

                        $(this).addClass('hidden').removeClass('flex');
                    });
                }
            })
            
        }
    });

    $(document).on("click", "#addDispatchMembers", function () {
        if (actionPossible && currentCase != 0) {
            loadingBar(true);


            $.post('https://kk-mdt/addDispatchMembers', JSON.stringify({ case: currentCase }), function(cb) {
                loadingBar(false);

                if (cb) {
                    functions.loadCase(currentCase)
                }
            })
            
        }
    }); 

    $(document).on("click", "#joinCase", function () {
        if (actionPossible && currentCase != 0) {
            loadingBar(true);


            $.post('https://kk-mdt/joinCase', JSON.stringify({ case: currentCase }), function(cb) {
                loadingBar(false);

                if (cb) {
                    functions.loadCase(currentCase)
                }
            })
            
        }
    });

    $(document).on("click", ".removeCaseMember", function () {
        if (actionPossible && currentCase != 0) {
            let identifier = $(this).parent().parent().data('id');

            loadingBar(true);

            $.post('https://kk-mdt/removeCaseMember', JSON.stringify({ case: currentCase, identifier: identifier }), function(cb) {
                loadingBar(false);

                if (cb) {
                    functions.loadCase(currentCase)
                }
            })
            
        }
    });

    $(document).on("click", ".removeCaseOfficer", function () {
        if (actionPossible && currentCase != 0) {
            let identifier = $(this).parent().parent().data('id');

            loadingBar(true);

            $.post('https://kk-mdt/removeCaseOfficer', JSON.stringify({ case: currentCase, identifier: identifier }), function(cb) {
                loadingBar(false);

                if (cb) {
                    functions.loadCase(currentCase)
                }
            })
            
        }
    }); 

    $(document).on("click", ".openCaseProfile", function () {
        if (actionPossible && currentCase != 0) {
            let identifier = $(this).parent().data('id');

            $.post('https://kk-mdt/setPage', JSON.stringify({ page: 'profiles' }), function(cb) {
                loadProfile(identifier);
            });
        }
    });

    let currentCaseMember = 0;
    let currentQuilt = false;

    $("#guiltSelected").change(function() {
        var newValue = $(this).val();

        if (newValue === 'guilty') {
            currentQuilt = true;
        } else if (newValue === 'no_guilty') {
            currentQuilt = false;
        }

        refreshList()
    });

    $(document).on("click", ".closeEditCasePersonPuns", function () {
        if (actionPossible) {
            $('#editCasePersonPuns').fadeOut(200, function() {
                $('#protocolRole').val('');
                currentCaseMember = 0;
                clearCaseCreation()

                $(this).addClass('hidden').removeClass('flex');
            });
        }
    });
    
    $(document).on("click", ".editCaseMember", function () {
        if (actionPossible && currentCase != 0) {
            loadingBar(true);
            let identifier = $(this).parent().parent().data('id');

            $.post('https://kk-mdt/requestProtocolData', JSON.stringify({ case: currentCase, identifier: identifier }), function(cb) {
                loadingBar(false);

                if (cb) {
                    punishmentsChosen = cb.punishments;

                    currentCaseMember = identifier;
                    $('#protocolRole').val(cb.role);

                    $('#fineSelected').val(cb.fine); materialPunishment.totalFine = cb.fine;
                    $('#jailSelected').val(cb.jail); materialPunishment.totalJail = cb.jail;

                    canEditProtocol = !cb.isPunished;

                    $('#reductionSelected').prop('disabled', cb.isPunished);
                    $('#guiltSelected').prop('disabled', cb.isPunished);

                    $.each(punishmentList, function(k, v){
                        var element = $(`[data-punishment="${k}"]`);

                        if (punishmentsChosen.includes(k)) {
                            element.addClass('border-2 border-green-500')
                        } else {
                            element.removeClass('border-2 border-green-500')
                        }
                    });

                    currentQuilt = cb.guilt;
                    $('#guiltSelected').val(cb.guilt && 'guilty' || !cb.guilt && 'no_guilty');

                    refreshList()
                    $('#reductionSelected').val(cb.reduction); materialPunishment.reduction = cb.reduction;
                    setPunishmentTotals();
                    $('#editCasePersonPuns').hide().removeClass('hidden').addClass('flex').fadeIn(200);
                }
            });
        }
    });

    $(document).on("click", "#protocolSaveData", function () {
        if (actionPossible && currentCase != 0 && currentCaseMember != 0) {
            loadingBar(true);

            $.post('https://kk-mdt/updateProtocolData', JSON.stringify({ case: currentCase, identifier: currentCaseMember, role: $('#protocolRole').val(), jail: materialPunishment.totalJail, fine: materialPunishment.totalFine, reduction: materialPunishment.reduction, punishments: punishmentsChosen, guilt: $('#guiltSelected').val() }), function(cb) {
                loadingBar(false);

                if (cb) {
                    functions.loadCase(currentCase)

                    $('#editCasePersonPuns').fadeOut(200, function() {
                        $('#protocolRole').val('');
                        currentCaseMember = 0;
                        clearCaseCreation()
        
                        $(this).addClass('hidden').removeClass('flex');
                    });
                }
            });
        }
    });

    let currentOfficersMember = 0;

   // Sulge ametniku redigeerimise aken
$(document).on("click", ".closeEditCaseOfficer", function () {
    if (actionPossible) {
        $('#editCaseOfficer').fadeOut(200, function() {
            $('#officerProfileRole').val('');
            currentOfficersMember = 0;
            $(this).addClass('hidden').removeClass('flex');
        });
    }
});

// Ava ametniku redigeerimise aken
$(document).on("click", ".editCaseOfficer", function () {
    if (actionPossible && currentCase != 0) {
        loadingBar(true);
        let identifier = $(this).parent().parent().data('id');

        $.post('https://kk-mdt/requestOfficerData', JSON.stringify({ case: currentCase, identifier: identifier }), function(cb) {
            loadingBar(false);

            if (cb) {
                currentOfficersMember = identifier;
                $('#officerProfileRole').val(cb.role);
                $('#editCaseOfficer').hide().removeClass('hidden').addClass('flex').fadeIn(200);
            }
        });
    }
});

// Salvesta ametniku muudetud andmed
$(document).on("click", "#officerSaveData", function () {
    if (actionPossible && currentCase != 0 && currentOfficersMember != 0) {
        loadingBar(true);

        $.post('https://kk-mdt/updateOfficerData', JSON.stringify({ case: currentCase, identifier: currentOfficersMember, role: $('#officerProfileRole').val() }), function(cb) {
            loadingBar(false);

            if (cb) {
                functions.loadCase(currentCase);
                $('#editCaseOfficer').fadeOut(200, function() {
                    $('#officerProfileRole').val('');
                    currentOfficersMember = 0;
                    $(this).addClass('hidden').removeClass('flex');
                });
            }
        });
    }
});

    $(document).on("click", "#addConfiscatedItem", function () {
        if (actionPossible && currentCase != 0) {
            loadingBar(true);

            $.post('https://kk-mdt/addConfiscatedItem', JSON.stringify({ case: currentCase, identifier: $('#policeCaseItemPersons').val(), item: $('#confiscatedItemName').val(), amount: $('#confiscatedItemAmount').val() }), function(cb) {
                loadingBar(false);

                if (cb) {
                    functions.loadCase(currentCase)
                }
            });
        }
    });

    $(document).on("click", ".removeConfiscatedItem", function () {
        if (actionPossible && currentCase != 0) {
            loadingBar(true);

            let identifier = $(this).parent().parent().data('id');
            let uuid = $(this).parent().parent().data('uuid');

            $.post('https://kk-mdt/removeConfiscatedItem', JSON.stringify({ case: currentCase, identifier: identifier, uuid: uuid }), function(cb) {
                loadingBar(false);

                if (cb) {
                    functions.loadCase(currentCase)
                }
            });
        }
    });

    $('#caseFileStatus').change(function() {
        if (actionPossible && currentCase != 0) {
            loadingBar(true);

            $.post('https://kk-mdt/caseFileStatus', JSON.stringify({ case: currentCase, status: $('#caseFileStatus').val() }), function(cb) {
                loadingBar(false);

                if (cb) {
                    functions.loadCase(currentCase)
                }
            });
        }
    });

    $(document).on("click", "#confirmPunishment", function () {
        if (actionPossible && currentCase != 0 && canEditProtocol) {
            loadingBar(true);

            $.post('https://kk-mdt/confirmPunishment', JSON.stringify({ case: currentCase, identifier: currentCaseMember, role: $('#protocolRole').val(), jail: materialPunishment.totalJail, fine: materialPunishment.totalFine, reduction: materialPunishment.reduction, punishments: punishmentsChosen, faultPoints: calculateStrike(), guilt: $('#guiltSelected').val()  }), function(cb) {
                loadingBar(false);

                if (cb) {
                    functions.loadCase(currentCase)

                    $('#editCasePersonPuns').fadeOut(200, function() {
                        $('#protocolRole').val('');
                        currentCaseMember = 0;
                        clearCaseCreation()
        
                        $(this).addClass('hidden').removeClass('flex');
                    });
                }
            });
        }
    });

    $(document).on("click", "#addVehicleItem", function () {
        if (actionPossible && currentCase != 0) {
            loadingBar(true);

            $.post('https://kk-mdt/addVehicleItem', JSON.stringify({
                caseId: currentCase,
                vehicle: $('#confiscatedVehicleName').val(), // võib olla tühi
                plate: $('#confiscatedVehiclePlate').val()
            }), function(cb) {
                loadingBar(false);

                if (cb) {
                    functions.loadCase(currentCase)
                }
            });
        }
    });


    $(document).on("click", ".removeVehicleItem", function () {
        if (actionPossible && currentCase != 0) {
            loadingBar(true);

            let uuid = $(this).parent().parent().data('uuid');

            $.post('https://kk-mdt/removeVehicleItem', JSON.stringify({ case: currentCase, uuid: uuid }), function(cb) {
                loadingBar(false);

                if (cb) {
                    functions.loadCase(currentCase)
                }
            });
        }
    });

    $(document).on("click", ".openCaseVehicle", function () {
        if (!actionPossible || currentCase == 0) return;

        const plate = $(this).data('plate');
        console.log('Clicked plate:', plate);

        $.post('https://kk-mdt/doesVehicleExist', JSON.stringify({ plate: plate }), function(exists) {
            console.log('doesVehicleExist response:', exists);

            if (exists) {
                $.post('https://kk-mdt/setPage', JSON.stringify({ page: 'vehicles' }), function() {
                    loadVehicleProfile(plate);
                });
            } else {
                console.log('Vehicle not found for plate:', plate);
            }
        });
    });
    
    $(document).on("click", "#policeCaseDelete", function () {
        if (actionPossible && currentCase != 0) {
            loadingBar(true);

            $.post('https://kk-mdt/policeCaseDelete', JSON.stringify({ case: currentCase }), function(cb) {
                loadingBar(false);

                if (cb) {
                    $("#policeCaseInformation").fadeOut(300, function () {
                        $("#policeCaseListing").fadeIn(100);
                    });
                }
            }) 
        }
    });
});
