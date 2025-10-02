
$(function () {
    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27') {
            $.post('https://kk-ambulance/closeApplication', JSON.stringify({}));
        }
    });

	window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'hide') {
            $('#container').fadeOut(400);
		} else if (event.action === 'show_candidation') {
			$('#myName').val(event.data.name);
            $('#candidation_document').show();
		} else if (event.action === 'hide_forms') {
            $('#candidation_document').hide();
        } else if (event.action === 'showTimer') {
            $('#deathscreen').fadeIn()
        } else if (event.action === 'hideTimer') {
            $('#deathscreen').fadeOut()
        } else if (event.action === 'updateTimer') {
            $('#timerText').html(event.data.text)

            let time = event.data.time;

            if (time < 0) {
                time = 0;
            }

            const minutes = Math.floor(time / 60).toString().padStart(2, '0');
            const seconds = (time % 60).toString().padStart(2, '0');

            //if (event.data.time != 0) {
              //  $('#countdown').show()

                $("#minute_first").text(minutes.toString()[0]);
                $("#minute_second").text(minutes.toString()[1]);
                $("#second_first").text(seconds.toString()[0]);
                $("#second_second").text(seconds.toString()[1]);
            //} else {
              //  $('#countdown').hide()
            //}
        }
    });

    $(document).on("click", "#submit", function () {
		$.post('https://kk-ambulance/sendApplication', JSON.stringify({ email: $('#myEmail').val(), text: $('#myCandidationText').val() }), function(cb) {
			if (cb) {
				$('#myEmail').val(''); $('#myCandidationText').val(''); 
				$.post('https://kk-ambulance/closeApplication', JSON.stringify({}));
			}
		});
    });
})