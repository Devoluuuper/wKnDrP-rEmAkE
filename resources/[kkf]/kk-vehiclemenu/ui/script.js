$('body,html').css('overflow','hidden');

$(document).ready(function () {
    $(document).keydown(function (event) {
        var keycode = event.keyCode ? event.keyCode : event.which;

        if (keycode == '27') {
            closeMenu()
        }
    });

    window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'openMenu') {
            $('body').fadeIn()
        } else if (event.action === 'closeMenu') {
            $('body').fadeOut()
        } else if (event.action == 'show') {
            $('html').fadeIn()
        } else if (event.action == 'hide') {
            $('html').fadeOut()
        }
    });
    
    $('button').click(function() {
        $.post('https://kk-vehiclemenu/menuAction', JSON.stringify({action: $(this).data('id')}));
    });

    function closeMenu() {
        $('body').fadeOut(); $.post('https://kk-vehiclemenu/disableFocus', JSON.stringify({}));
    }
});