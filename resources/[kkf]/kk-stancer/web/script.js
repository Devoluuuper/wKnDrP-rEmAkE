$(document).ready(function () {
    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27') {
            $.post('https://kk-stancer/close', JSON.stringify({}));
        }
    });

    window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'open') {
            $.each(event.data, function(k, v) {
                let value = (v);

                $('#' + k + '_amount').html(Math.round(value));
                $('#' + k + '_value').val(value);
            });

            $('#container').fadeIn();
        } else if (event.action === 'close') {
            $('#container').fadeOut();
        }
    });

    $('input').change(function() {
        let element = $(this);
        let id = element.attr('id');
        id = id.replace('_value', '');

        $('#' + id + '_amount').html(Math.round(element.val()));
        $.post('https://kk-stancer/onChange', JSON.stringify({ item: id, value: element.val() }));
    });

    $(document).on('click', '#saveVehicle', function () {
        $.post('https://kk-stancer/saveVehicle', JSON.stringify({}));
    });
});