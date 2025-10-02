$(function(){
    let currentVehicle = 'none';

    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27') {
            $.post('https://kk-mechanic/closeTablet', JSON.stringify({}));
        }
    });

    window.addEventListener('message', function(event) {
        let response = event.data

        if (response.action == 'open') {
            $('body').show()

            $('#vehicleModel').text(response.data.model);
            $('#vehicleBrand').text(response.data.brand);
            $('#vehiclePrice').text(response.data.price); 
            $('#vehicleClass').text(response.data["class"]);
            $('#vehiclePlate').text(response.data.plate); currentVehicle = response.data.plate
            $('#vehicleMileage').text(response.data.mileage + ' miili');
            $('#vehicleParts').html(''); $('#vehicleHistory').html(''); $('#vehicleMaintainance').html('')

            $.each(response.data.mods, function(k,v){
                for (let i = 0; i < v[0]; i++) {
                    let price = Math.floor(response.data.prices[k][i] * response.data.carPrice / 100)
                    let item = `
                            <div data-part="${k}" data-mod="${i + +1}" data-price="${price}" class="flex border border-gray-700 bg-gray-800 shadow rounded p-1 items-center text-center mb-2">
                                <div class="mr-4 flex-shrink-0">
                                    <img width="64px" src="./img/mods/${k}_${i + +1}.png">
                                </div>
                                <div class="grow text-left">
                                    <h4 class="text-lg font-bold">Hind: $${price}</h4>
                                </div>
                                <div class="flex mr-2">
                                    <button class="px-2 py-1.5 mt-1 bg-sky-700 rounded hover:bg-sky-800 uppercase font-medium text-xs buyItem">Soeta</button>
                                </div>
                            </div>
                    `

                    if (k != 'turbo' && response.data.mods[k][1] + +1 == i + +1 || k == 'turbo' && response.data.mods[k][1]) {
                        item = `

                            <div data-part="${k}" data-mod="${i + +1}" data-price="${price}" class="flex border border-gray-700 bg-gray-800 shadow rounded p-1 items-center text-center mb-2">
                                <div class="mr-4 flex-shrink-0">
                                    <img width="64px" src="./img/mods/${k}_${i + +1}.png">
                                </div>
                                <div class="grow text-left">
                                    <h4 class="text-lg font-bold">Hind: $${price}</h4>
                                </div>
                                <div class="flex mr-2">
                                    <button class="px-2 py-1.5 mt-1 bg-sky-700 rounded hover:bg-sky-800 uppercase font-medium text-xs buyItem">Soeta</button>
                                    <span class="px-2 py-1.5 mt-1 ml-1 text-xs rounded bg-green-700 uppercase font-medium">✓</span>
                                </div>
                            </div>
                        `
                    }

                    $('#vehicleParts').append(item);
                }
            });

            if (response.data.logBook) {
                $.each(response.data.logBook, function(k,v){
                    $('#vehicleHistory').prepend(`

                        <div class="flex border border-gray-700 bg-gray-800 shadow rounded p-1 items-center text-center mb-2">
                            <div class="mr-4 flex-shrink-0">
                                <svg class="size-10" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M11.42 15.17 17.25 21A2.652 2.652 0 0 0 21 17.25l-5.877-5.877M11.42 15.17l2.496-3.03c.317-.384.74-.626 1.208-.766M11.42 15.17l-4.655 5.653a2.548 2.548 0 1 1-3.586-3.586l6.837-5.63m5.108-.233c.55-.164 1.163-.188 1.743-.14a4.5 4.5 0 0 0 4.486-6.336l-3.276 3.277a3.004 3.004 0 0 1-2.25-2.25l3.276-3.276a4.5 4.5 0 0 0-6.336 4.486c.091 1.076-.071 2.264-.904 2.95l-.102.085m-1.745 1.437L5.909 7.5H4.5L2.25 3.75l1.5-1.5L7.5 4.5v1.409l4.26 4.26m-1.745 1.437 1.745-1.437m6.615 8.206L15.75 15.75M4.867 19.125h.008v.008h-.008v-.008Z" />
                                </svg>
                            </div>
                            <div class="grow text-left">
                                <h4 class="text-lg font-bold"><span>${v.company}</span> - <span>${v.worker}</span></h4>
                                <p class="text-sm text-gray-400">${v.msg}</p>
                                <p class="text-sm text-gray-400">${v.time}</p>
                            </div>
                        </div>
                    `);
                });
            }

            if (response.data.degration) {
                $.each(response.data.degration, function(k,v){
                    let header = v[1] + ' (' + v[0] + '%)';
                    let color = ['bg-green-700', 'bg-green-800', 'bg-green-600'];

                    if (v[0] < 60 && v[0] > 30) {
                        color[0] = 'bg-yellow-700'; color[1] = 'bg-yellow-800'; color[2] = 'bg-yellow-600';
                    } else if (v[0] < 30) {
                        color[0] = 'bg-red-700'; color[1] = 'bg-red-800'; color[2] = 'bg-red-600';
                    }

                    $('#vehicleMaintainance').append(`
                                                
                        <!-- <div class="${color[0]} shadow p-2 rounded flex mb-1">
                            <img src="./img/service/${k}.png" width="51.2px" height="51.2px">

                            <div class="ml-3">
                                <span>${header}</span>

                                <div class="flex"> 
                                    <div class="w-60 ${color[1]} rounded h-1">
                                        <div class="${color[2]} h-1 rounded" style="width: ${v[0]}%"></div>
                                    </div>
                                </div>
                            </div>
                        </div>-->

                        <div class="grid grid-cols-1 bg-gray-800 mt-2 rounded p-4 w-full  content-between">
                            <div class="flex items-center p-1 w-full">
                                <div>
                                    <img src="./img/service/${k}.png" width="51.2px" height="51.2px">
                                </div>
                                <div class="flex-grow">
                                    <p class="text-sm text-gray-200 ml-4 mb-2">${header}</p>
                                    <div class="ml-4" aria-hidden="true">
                                        <div class="overflow-hidden rounded-full bg-gray-900">
                                            <div class="h-2 rounded-full ${color[2]}" style="width: ${v[0]}%"></div>
                                        </div>
                                        <div class="mt-2 flex justify-between text-sm font-medium text-gray-400 ">
                                            <div>0%</div>
                                            <div>25%</div>
                                            <div>50%</div>
                                            <div>75%</div>
                                            <div>100%</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `);
                });
            }

            if (document.getElementById('vehicleHistory').getElementsByTagName('div').length < 1) {
                $('#vehicleHistory').append(`<h5 class="text-center text-xl">Sõidukil puudub igasugune ajalugu!</h5>`);
            }
        } else if (response.action == 'close') {
            $('body').hide()
        }
    });

    $(document).on('click', '.buyItem', function(e) {
        e.preventDefault(); $('#loadBar').show()

        if ($(this).parent().parent().parent().data('part')) {
            $.post('https://kk-mechanic/buyPart', JSON.stringify({plate: currentVehicle, part: $(this).parent().parent().parent().data('part'), mod: $(this).parent().parent().parent().data('mod'), price: $(this).parent().parent().parent().data('price')}), function(response) {
                $('#loadBar').hide()
            });
        } else {
            $.post('https://kk-mechanic/buyPart', JSON.stringify({plate: currentVehicle, part: $(this).parent().parent().data('part'), mod: $(this).parent().parent().data('mod'), price: $(this).parent().parent().data('price')}), function(response) {
                $('#loadBar').hide()
            });
        }
    })  
});