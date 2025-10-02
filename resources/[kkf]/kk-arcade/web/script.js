$(document).ready(function () {
    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27') {
            $.post('http://kk-arcade/close', JSON.stringify({}));
        }
    });

    window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'open') {
            $('body').show();
            $('#gameScreen').attr('src', event.data.url);
        } else if (event.action === 'close') {
            $('body').hide();
            $('#gameScreen').attr('src', '');
        }
    });

    $(document).on("click", "#closeGame", function () {
        $.post('http://kk-arcade/close', JSON.stringify({}));
    });
});