$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'show') {
            $('#crosshair').show()
        } else if (event.action === 'hide') {
            $('#crosshair').hide()
        }
    });
});