$(document).ready(function() {
    let vatPercent = 0;

    $(document).keydown(function (event) {
        var keycode = event.keyCode ? event.keyCode : event.which;

        if (keycode == "27") {
            $.post("https://kk-vehicleshop/closeMenu", JSON.stringify({}));
        }
    });
    
    window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'openMenu') {
            $('#shopmenu').show()

            vatPercent = event.vat
            loadVehicles(event.data)
        } else if (event.action == 'closeMenu') {
            $('#shopmenu').hide()
        }
    }); 

    $("#hovering").hover(
        function () {
            $("#shopmenu").css("opacity", "0.5");
        },

        function () {
            $("#shopmenu").css("opacity", "1");
        }
    );

    $(document).on('click', '#back', function(e) {
        e.preventDefault(); 
        
        $.post('https://kk-vehicleshop/back', JSON.stringify({}));
    })  

    $(document).on('click', '.buyVehicle', function(e) {
        e.preventDefault(); 
        
        $.post('https://kk-vehicleshop/buyVehicle', JSON.stringify({id: $(this).data('name')}));
    })  

    function loadVehicles(vehicles) {
        var VehicleObject = $("#wrapper");

        $(VehicleObject).html("");

        $.each(vehicles, function(k,v){ 
            var img = new Image();
            img.src = v.img;

            let stock = 'lõpmatu arv sõidukeid';

            if (v.currentStock != 'unlimited') {
                stock = `${v.currentStock} sõidukit`
            }

            var item = `
                <div class="bg-zinc-900 border border-zinc-700 rounded shadow overflow-hidden h-max">
                    <img class="w-full h-56 object-cover" src="${v.img}" alt="${v.label}">

                    <div class="p-6">
                        <h2 class="text-xl font-semibold mb-2">${v.label}</h2>
                        <p class="text-gray-400 mb-4">Saadaval on ${stock}</p>

                        <p class="text-green-600 font-semibold mb-2">Hind</p>
                        <p class="text-white text-2xl font-bold mb-4">$${v.price} + VAT ${vatPercent}%</p>

                        <button data-name="${k}" class="buyVehicle w-full bg-green-500 text-white py-2 rounded hover:bg-green-600 transition duration-200">Soeta</button>
                    </div>
                </div>
            `
    
            $(VehicleObject).append(item);
        });
    };
});