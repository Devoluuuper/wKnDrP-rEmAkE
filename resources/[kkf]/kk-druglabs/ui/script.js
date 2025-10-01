$(function () {
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('https://kk-druglabs/close', JSON.stringify({}));
        }
    }

    window.addEventListener('message', function (event) {
        if (event.data.type === "open") {
            $('body').show();

            if (event.data.interface === "shop") {
                loadShop(event.data.shop);
            }
        } else if (event.data.type === "close") {
            $('body').hide();
        }
    });

    $(document).on('click', '#changePin', function(e) {
        e.preventDefault(); 

        $.post('https://kk-druglabs/changePin', JSON.stringify({pin: $('#pinInput').val()}));
    });

    $(document).on('click', '#buyItem', function (e) {
        e.preventDefault();

        const itemId = $(this).closest('li').data('id');
    
        if (!itemId) {
            // console.error("Error: No item ID found.");
            return;
        }

        $.post('https://kk-druglabs/buyItem', JSON.stringify({ item: itemId }));
    });

    function loadShop(items) {
        var ShopObject = $("#shop");
    
        $(ShopObject).html("");
    
        if (items !== null) {
            $.each(items, function(k, v) {
                $(ShopObject).append(`
                    <li data-id="${k}" class="col-span-1 flex flex-col divide-y divide-gray-800 rounded-lg bg-gray-900 text-center shadow">
                        <div class="flex flex-1 flex-col p-8">
                            <img src="./${v.picture}" alt="" class="mx-auto size-32 shrink-0 rounded-md w-full h-2/3">
                            <h3 class="mt-6 text-sm font-medium text-gray-200">${v.label}</h3>
                            <dl class="mt-1 flex grow flex-col justify-between">
                                <dd class="text-sm text-gray-400">Hind: $${v.price}</dd>
                            </dl>
                        </div>
                        <div>
                            <div class="-mt-px flex divide-x divide-gray-200">
                                <div class="flex w-0 flex-1">
                                    <button id="buyItem" class="relative -mr-px inline-flex w-0 flex-1 items-center justify-center gap-x-3 rounded-bl-lg border border-transparent py-4 text-sm font-semibold text-gray-300">
                                        <svg class="w-5 h-5 text-gray-300" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 0 0-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 0 0-16.536-1.84M7.5 14.25 5.106 5.272M6 20.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Zm12.75 0a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Z" />
                                        </svg>
                                        Soeta
                                    </button>
                                </div>    
                            </div>
                        </div>
                    </li>
                `);
    
                $("[data-id='" + v.id + "']").data('tweerData', v);
            });
        }
    };
});