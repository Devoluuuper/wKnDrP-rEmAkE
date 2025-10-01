$(document).ready(function () {
    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27') {
            $.post('https://kk-banking/close', JSON.stringify({}));
        }
    });

    let actionPossible = true;
    functions = {};

    window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'open') {
            $('#container').show();

            if (event.data.type === 'atm') {
                $('#depositButton').hide()
                $('#depositContainer').hide()
            } else {
                $('#depositButton').show()
                $('#depositContainer').show()
            }

            if (event.data.faction) {
                $('#factionButton').show()
                $('#factionMoney').text(`$${event.data.faction.money}`)

                if (event.data.faction.permissions.withdraw) {
                    $('#factionWithdraw').show()
                } else {
                    $('#factionWithdraw').hide()
                }

                if (event.data.faction.permissions.deposit) {
                    $('#factionDeposit').show()
                } else {
                    $('#factionDeposit').hide()
                }

                if (event.data.type === 'atm') {
                    $('#factionDepositContainer').hide()
                } else {
                    $('#factionDepositContainer').show()
                }
            } else {
                $('#factionButton').hide()
            }
        } else if (event.action === 'close') {
            $('#container').hide();
        } else if (event.action === 'update') {
            if (event.data.money) $('#moneyInHand').html(`Raha käes: $${event.data.money}`);
            if (event.data.bank) $('#moneyInBank').html(`$${event.data.bank}`);
            if (event.data.faction) $('#factionMoney').html(`$${event.data.faction}`);
        }
    });

    functions.loadLogs = function() {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-banking/loadLogs', JSON.stringify({}), function(data) {
                loadingBar(false);

                if (data) {
                    $('#bankLogs').html('');

                    $.each(data, function(k, v){
                        let date = new Date(v.time);
                        let time = ('0'+date.getHours()).slice(-2)+":"+('0'+date.getMinutes()).slice(-2)+" "+('0'+date.getDate()).slice(-2)+"."+('0'+(date.getUTCMonth()+1)).slice(-2)+"."+date.getFullYear()
    
                        let text = 'text-green-700';
    
                        if (v.amount < 0) text = 'text-yellow-700'
    
                        $('#bankLogs').append(`
                            <div class='border bg-zinc-900 shadow rounded border-1 border-zinc-700 p-2 flex justify-between'>
                                <p class="text-lg font-medium ${text}">${v.amount}$</p>
                                <p class="text-lg font-medium text-zinc-200">${time}</p>
                            </div>
                        `);
                    });
                }
            })
        }
    }

    functions.loadBills = function() {
        if (actionPossible) {
            loadingBar(true);

            $.post('https://kk-banking/loadBills', JSON.stringify({}), function(data) {
                loadingBar(false);

                if (data) {
                    $('#bills').html('');

                    $.each(data, function(k, v){
                        let date = new Date(v.time);
                        let now = new Date();
                        
                        let timeDiff = now.getTime() - date.getTime();
                        let dayDiff = Math.round(timeDiff / (1000 * 3600 * 24));
    
                        $('#bills').append(`
                            <tr class="hover:bg-zinc-700">
                                <td class="whitespace-nowrap px-12 py-2 text-sm text-zinc-500 text-center">
                                    <div class="text-zinc-300 py-1 text-sm">
                                        ${v.id}
                                    </div>
                                </td>

                                <td class="whitespace-nowrap px-12 py-2 text-sm text-zinc-500 text-center">
                                    <div class="text-zinc-300 py-1 text-sm">
                                        ${v.sender}
                                    </div>
                                </td>

                                <td class="whitespace-nowrap px-12 py-2 text-sm text-zinc-500 text-center">
                                    <div class="text-zinc-300 py-1 text-sm">
                                        ${v.label}
                                    </div>
                                </td>

                                <td class="whitespace-nowrap px-12 py-2 text-sm text-zinc-500 text-center">
                                    <div class="text-zinc-300 py-1 text-sm">
                                        $${v.amount}
                                    </div>
                                </td>

                                <td class="whitespace-nowrap px-12 py-2 text-sm text-zinc-500 text-center">
                                    <span class="inline-flex rounded-full bg-green-700 px-4 py-1 text-xs font-semibold leading-5 text-white">${dayDiff}p tagasi</span>
                                </td>

                                <td>
                                    <button data-id="${v.id}" type="button" class="payBill text-center px-4 py-1 rounded shadow text-sm font-medium text-white bg-sky-700 hover:bg-sky-800">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 8.25h19.5M2.25 9h19.5m-16.5 5.25h6m-6 2.25h3m-3.75 3h15a2.25 2.25 0 002.25-2.25V6.75A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25v10.5A2.25 2.25 0 004.5 19.5z" />
                                        </svg>
                                    </button>
                                </td>
                            </tr>
                        `);
                    });
                }
            })
        }
    }

    $(document).on("click", ".payBill", function () {
        if (actionPossible) {
            let id = $(this).data('id')
            loadingBar(true);

            $.post('https://kk-banking/payBill', JSON.stringify({ id: id }), function(cb) {
                loadingBar(false);

                if (cb) {
                    functions.loadBills()

                    $('#moneyInBank').text(`$${cb}`);
                }
            });
        }
    });

    $(document).on("click", "#transferMoney", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-banking/transferMoney', JSON.stringify({ pid: $('#transferTarget').val(), amount: $('#transferAmount').val() }), function(cb) {
                loadingBar(false);
            });
        }
    });

    // Withdraw

    $(document).on("click", "#withdrawMoney", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-banking/withdraw', JSON.stringify({ amount: $('#withdrawAmount').val() }), function(cb) {
                loadingBar(false);
            });
        }
    });

    $(document).on("click", "#withdraw500", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-banking/withdraw', JSON.stringify({ amount: 500 }), function(cb) {
                loadingBar(false);
            });
        }
    });

    $(document).on("click", "#withdraw1000", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-banking/withdraw', JSON.stringify({ amount: 1000 }), function(cb) {
                loadingBar(false);
            });
        }
    });

    $(document).on("click", "#withdraw1500", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-banking/withdraw', JSON.stringify({ amount: 1500 }), function(cb) {
                loadingBar(false);
            });
        }
    });

    $(document).on("click", "#factionWithdraw", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-banking/factionWithdraw', JSON.stringify({ amount: $('#factionWithdrawAmount').val() }), function(cb) {
                loadingBar(false);
            });
        }
    });

    // Deposit

    $(document).on("click", "#depositMoney", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-banking/deposit', JSON.stringify({ amount: $('#depositAmount').val() }), function(cb) {
                loadingBar(false);
            });
        }
    });

    $(document).on("click", "#deposit500", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-banking/deposit', JSON.stringify({ amount: 500 }), function(cb) {
                loadingBar(false);
            });
        }
    });

    $(document).on("click", "#deposit1000", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-banking/deposit', JSON.stringify({ amount: 1000 }), function(cb) {
                loadingBar(false);
            });
        }
    });

    $(document).on("click", "#deposit1500", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-banking/deposit', JSON.stringify({ amount: 1500 }), function(cb) {
                loadingBar(false);
            });
        }
    });

    $(document).on("click", "#factionDeposit", function () {
        if (actionPossible) {
            loadingBar(true); 

            $.post('https://kk-banking/factionDeposit', JSON.stringify({ amount: $('#factionDepositAmount').val() }), function(cb) {
                loadingBar(false);
            });
        }
    });

    function loadingBar(val) {
        if (val) {
            $('#indeterminate').show(); actionPossible = false
        } else {
            $('#indeterminate').hide(); actionPossible = true
        }
    }
});