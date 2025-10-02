$(function() {
    window.addEventListener('message', function(event) {
        switch (event.data.action) {
            case 'showBadge':
                if (event.data.department === 'LSPD') {
                    $('#id-card').css('background', 'url("../ui/images/lspd.png")');
                } else if (event.data.department === 'BCSO') {
                    $('#id-card').css('background', 'url("../ui/images/bcso.png")');
                } else if (event.data.department === 'doj') {
                    $('#id-card').css('background', 'url("../ui/images/doj.png")');
				} else if (event.data.department === 'ambulance') {
                    $('#id-card').css('background', 'url("../ui/images/ambulance.png")');
                }

                $('#id-card').show();
                $('#name').text(event.data.name);
                $('#rank').text(event.data.rank);
                $('#serial').text(event.data.serial);

                $('.img-container').css('background-image', 'url(' + event.data.picture + ')');

                setTimeout(() => $('#id-card').hide(), 4000)
            break;
        }
    });
});