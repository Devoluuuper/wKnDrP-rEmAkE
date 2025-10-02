$(document).ready(function () {
    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27') {
            $.post('https://kk-guide/close', JSON.stringify({}));
        }
    });

    window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'open') {
            $('#container').fadeIn(500);
        } else if (event.action === 'close') {
            $('#container').fadeOut(500);
        }
    });

    $(document).on("click", "#close", function () {
        $.post('https://kk-guide/close', JSON.stringify({}));
    });
});