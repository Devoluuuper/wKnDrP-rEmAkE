$(function(){
    let cooldown = false

    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27') {
            $.post('https://kk-boosting/closeTablet', JSON.stringify({}));
        }
    });

    window.addEventListener('message', function(event) {
        if (event.data.action == 'open') {
            $('body').show()

            var contracts = $('#contracts');
            $(contracts).html('');
    
            if (Object.keys(event.data.data.contracts).length != 0) {
                $.each(event.data.data.contracts, function(k,v) {
                    var item = `
                        <div data-id="${k}" class="rounded break-words border bg-gray-900 border-1 border-gray-700 m-2 mt-0 flex justify-between">
                            <div class="p-2">
                                <div class="flex">
                                    <div class="px-4 py-2 inline-block border border-1 bg-gray-800 border-gray-700 rounded-full">${v.class}</div>
                                    <h5 class="m-2">${v.name}</h5>
                                </div>

                                <div class="mt-2">
                                    <h4 class="text-xs font-medium text-gray-400">Hind: <span class="text-gray-200">$${v.price}</span></h4>
                                    <h4 class="text-xs font-medium text-gray-400">Aegub: <span class="text-yellow-600">${toHoursAndMinutes(v.expires)}</span></h4>
                                </div>

                                <div class="mt-1">
                                    <input type='button' value='Alusta' id='acceptContract' class="w-24 uppercase font-medium text-sm align-middle text-center select-none font-normal whitespace-no-wrap rounded py-1.5 px-2 leading-normal no-underline text-gray-200 border-gray-900 hover:bg-gray-800 hover:text-white bg-green-700 hover:bg-green-800 mt-1">
                                    <input type='button' value='Keeldu' id='deleteContract' class="w-24 uppercase font-medium text-sm align-middle text-center select-none font-normal whitespace-no-wrap rounded py-1.5 px-2 leading-normal no-underline text-gray-200 border-gray-900 hover:bg-gray-800 hover:text-white bg-red-800 hover:bg-red-900 mt-1">
                                </div>
                            </div>

                            <div class="p-2">
                                <img src="${v.img}" class="h-32 rounded rounded border border-1 border-gray-700" alt="${v.label}">
                            </div>
                        </div>
                    `
    
                    $(contracts).append(item);
                });
            }

            if (Object.keys(event.data.current).length != 0) {
                var item = `
                    <div data-type="current" class="rounded break-words border bg-gray-900 border-2 border-green-800 border-dashed m-2 mt-0 flex justify-between">
                        <div class="p-2">
                            <div class="flex">
                                <div class="px-4 py-2 inline-block border border-1 bg-gray-800 border-gray-700 rounded-full">${event.data.current.class}</div>
                                <h5 class="m-2">${event.data.current.label}</h5>
                            </div>

                            <div class="mt-2">
                                <h4 class="text-xs font-medium text-gray-400">Tasu: <span class="text-gray-200">$${event.data.current.prize}</span></h4>
                                <h4 class="text-xs font-medium text-gray-400">Numbrimärk: <span class="text-gray-200">${event.data.current.plate}</span></h4>
                                <h4 class="text-xs font-medium text-gray-400">Aegub: <span class="text-yellow-600">${event.data.current.timeRemaining} minuti pärast</span></h4>
                            </div>

                            <div class="mt-1">
                                <input type='button' value='Katkesta' id='cancelContract' class="w-24 uppercase font-medium text-sm align-middle text-center select-none font-normal whitespace-no-wrap rounded py-1.5 px-2 leading-normal no-underline text-gray-200 border-gray-900 hover:bg-gray-800 hover:text-white bg-red-800 hover:bg-red-900 mt-1">
                                <input type='button' value='Pikenda' id='extendContract' class="w-24 uppercase font-medium text-sm align-middle text-center select-none font-normal whitespace-no-wrap rounded py-1.5 px-2 leading-normal no-underline text-gray-200 border-gray-900 hover:bg-gray-800 hover:text-white bg-blue-600 hover:bg-blue-700 mt-1">
                            </div>
                        </div>

                        <div class="p-2">
                            <img src="${event.data.current.img}" class="h-32 rounded rounded border border-1 border-gray-700" alt="${event.data.current.label}">
                        </div>
                    </div>
                `

                $('#contracts').prepend(item);
            } else {
                $("#contracts").find(`[data-type='current']`).remove()
            }

            if (document.getElementById('contracts').getElementsByTagName('div').length > 0) {
                $('#noContracts').hide()
            } else {
                $('#noContracts').show()
            }

            $('#classProgress').css('width', event.data.data.classProgress + '%')
            $('#currentClass').text(event.data.data.currentClass)
            $('#nextClass').text(event.data.data.nextClass)

            if (event.data.data.recieves) {
                $("#queueToggle").html('Lahku järjekorrast');

                $('#queueToggle').addClass('bg-red-800 hover:bg-red-900');
                $('#queueToggle').removeClass('bg-green-700 hover:bg-green-800');
            } else {
                $("#queueToggle").html('Liitu järjekorraga');

                $('#queueToggle').removeClass('bg-red-800 hover:bg-red-900');
                $('#queueToggle').addClass('bg-green-700 hover:bg-green-800');
            }

            $('#loadBar').hide()
        } else if (event.data.action == 'close') {
            $('body').hide()
        } else if (event.data.action == 'update') {
            var contracts = $('#contracts');
            $(contracts).html('');
    
            if (Object.keys(event.data.data.contracts).length != 0) {
                $.each(event.data.data.contracts, function(k,v) {
                    var item = `
                        <div data-id="${k}" class="rounded break-words border bg-gray-900 border-1 border-gray-700 m-2 mt-0 flex justify-between">
                            <div class="p-2">
                                <div class="flex">
                                    <div class="px-4 py-2 inline-block border border-1 bg-gray-800 border-gray-700 rounded-full">${v.class}</div>
                                    <h5 class="m-2">${v.name}</h5>
                                </div>

                                <div class="mt-2">
                                    <h4 class="text-xs font-medium text-gray-400">Hind: <span class="text-gray-200">$${v.price}</span></h4>
                                    <h4 class="text-xs font-medium text-gray-400">Aegub: <span class="text-yellow-600">${toHoursAndMinutes(v.expires)}</span></h4>
                                </div>

                                <div class="mt-1">
                                    <input type='button' value='Alusta' id='acceptContract' class="w-24 uppercase font-medium text-sm align-middle text-center select-none font-normal whitespace-no-wrap rounded py-1.5 px-2 leading-normal no-underline text-gray-200 border-gray-900 hover:bg-gray-800 hover:text-white bg-green-700 hover:bg-green-800 mt-1">
                                    <input type='button' value='Keeldu' id='deleteContract' class="w-24 uppercase font-medium text-sm align-middle text-center select-none font-normal whitespace-no-wrap rounded py-1.5 px-2 leading-normal no-underline text-gray-200 border-gray-900 hover:bg-gray-800 hover:text-white bg-red-800 hover:bg-red-900 mt-1">
                                </div>
                            </div>

                            <div class="p-2">
                                <img src="${v.img}" class="h-32 rounded rounded border border-1 border-gray-700" alt="${v.label}">
                            </div>
                        </div>
                    `
    
                    $(contracts).append(item);
                });
            }

            if (Object.keys(event.data.current).length != 0) {
                var item = `
                    <div data-type="current" class="rounded break-words border bg-gray-900 border-2 border-green-800 border-dashed m-2 mt-0 flex justify-between">
                        <div class="p-2">
                            <div class="flex">
                                <div class="px-4 py-2 inline-block border border-1 bg-gray-800 border-gray-700 rounded-full">${event.data.current.class}</div>
                                <h5 class="m-2">${event.data.current.label}</h5>
                            </div>

                            <div class="mt-2">
                                <h4 class="text-xs font-medium text-gray-400">Tasu: <span class="text-gray-200">$${event.data.current.prize}</span></h4>
                                <h4 class="text-xs font-medium text-gray-400">Numbrimärk: <span class="text-gray-200">${event.data.current.plate}</span></h4>
                                <h4 class="text-xs font-medium text-gray-400">Aegub: <span class="text-yellow-600">${event.data.current.timeRemaining} minuti pärast</span></h4>
                            </div>

                            <div class="mt-1">
                                <input type='button' value='Katkesta' id='cancelContract' class="w-24 uppercase font-medium text-sm align-middle text-center select-none font-normal whitespace-no-wrap rounded py-1.5 px-2 leading-normal no-underline text-gray-200 border-gray-900 hover:bg-gray-800 hover:text-white bg-red-800 hover:bg-red-900 mt-1">
                                <input type='button' value='Pikenda' id='extendContract' class="w-24 uppercase font-medium text-sm align-middle text-center select-none font-normal whitespace-no-wrap rounded py-1.5 px-2 leading-normal no-underline text-gray-200 border-gray-900 hover:bg-gray-800 hover:text-white bg-blue-600 hover:bg-blue-700 mt-1">
                            </div>
                        </div>

                        <div class="p-2">
                            <img src="${event.data.current.img}" class="h-32 rounded rounded border border-1 border-gray-700" alt="${event.data.current.label}">
                        </div>
                    </div>
                `

                $('#contracts').prepend(item);
            } else {
                $("#contracts").find(`[data-type='current']`).remove()
            }

            if (document.getElementById('contracts').getElementsByTagName('div').length > 0) {
                $('#noContracts').hide()
            } else {
                $('#noContracts').show()
            }

            $('#classProgress').css('width', event.data.data.classProgress + '%')
            $('#currentClass').text(event.data.data.currentClass)
            $('#nextClass').text(event.data.data.nextClass)

            if (event.data.data.recieves) {
                $("#queueToggle").html('Lahku järjekorrast');

                $('#queueToggle').addClass('bg-red-800 hover:bg-red-900');
                $('#queueToggle').removeClass('bg-green-700 hover:bg-green-800');
            } else {
                $("#queueToggle").html('Liitu järjekorraga');

                $('#queueToggle').removeClass('bg-red-800 hover:bg-red-900');
                $('#queueToggle').addClass('bg-green-700 hover:bg-green-800');
            }

            $('#loadBar').hide()
        }
    });

    function toHoursAndMinutes(totalMinutes) {
        const minutes = totalMinutes % 60;
        const hours = Math.floor(totalMinutes / 60);
      
        return `${hours} tunni ja ${minutes} minuti pärast`;
    } 

    $(document).on('click', '#cancelContract', function(e) {
        e.preventDefault();

        if (!cooldown) {
            cooldown = true; setTimeout(() => {
                cooldown = false
            }, 2000);

            $.post('https://kk-boosting/cancelContract', JSON.stringify({}));
            $('#loadBar').show()
        }
    })  

    $(document).on('click', '#extendContract', function(e) {
        e.preventDefault();

        if (!cooldown) {
            cooldown = true; setTimeout(() => {
                cooldown = false
            }, 2000);

            $.post('https://kk-boosting/extendContract', JSON.stringify({}));
            $('#loadBar').show()
        }
    })

    $(document).on('click', '#acceptContract', function(e) {
        e.preventDefault();

        if (!cooldown) {
            cooldown = true; setTimeout(() => {
                cooldown = false
            }, 5000);

            let id = $(this).parent().parent().parent().data('id') + +1
            $.post('https://kk-boosting/acceptContract', JSON.stringify({ id: id }));
            $('#loadBar').show()
        }
    })  

    $(document).on('click', '#deleteContract', function(e) {
        e.preventDefault();

        if (!cooldown) {
            cooldown = true; setTimeout(() => {
                cooldown = false
            }, 2000);

            let id = $(this).parent().parent().parent().data('id') + +1
            $.post('https://kk-boosting/deleteContract', JSON.stringify({ id: id }));
            $('#loadBar').show()
        }
    })

    $(document).on('click', '#queueToggle', function(e) {
        e.preventDefault();

        if (!cooldown) {
            cooldown = true; setTimeout(() => {
                cooldown = false
            }, 1000);

            $.post('https://kk-boosting/queueToggle', JSON.stringify({}));
            $('#loadBar').show()
        }
    })
});