PrinterBox = {}

$(document).ready(function() {
    window.addEventListener('message', function(event) {
        var action = event.data.action;

        switch (action) {
            case "openDocument":
                PrinterBox.Open(event.data);
                break;
            case "close":
                PrinterBox.Close(event.data);
                break;
        }
    });
});

$(document).on('keydown', function() {
    switch (event.keyCode) {
        case 27: // ESC
            PrinterBox.Close();
            break;
        case 9: // ESC
            PrinterBox.Close();
            break;
    }
});

PrinterBox.Open = function(data) {
    if (data.url) {
        $(".paper-container").fadeIn(150);
        $(".document-image").attr('src', data.url);
    } else {
        console.log('No document is linked to it!!!!!')
    }
}

PrinterBox.Close = function(data) {
    $(".paper-container").fadeOut(150);
    $.post('https://kk-printer/closeDocument');
}