$(function() {
    window.addEventListener('message', function(event) {
        switch (event.data.action) {
            case 'show':
                $("#id-card").css("background", "url(images/" + event.data.type + ".png)");
                $('#profilePicture').attr('src', event.data.data.profilepic);
                $('#firstname').text(event.data.data.firstname);
                $('#lastname').text(event.data.data.lastname);
                $('#sex').text(event.data.data.sex);
                $('#dob').text(event.data.data.dob);
                $('#dmv').text(event.data.data.dmv);
                $('#pid').text(event.data.data.pid);
				$('#signature').text(event.data.data.lastname);

                if (event.data.data.doe) {
                    $('#doe').show()
                    $('#doe').text(event.data.data.doe);
                    $('#dmv').text('‎');
                } else {
                    $('#doe').hide()
                }

                $('#id-card').fadeIn(400);

                setTimeout(() => {
                    $('#id-card').fadeOut(400); 
                }, 7500);
            break;
        }
    });
});
