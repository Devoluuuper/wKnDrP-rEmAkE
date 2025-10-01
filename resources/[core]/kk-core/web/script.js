$(document).ready(function () {
	window.addEventListener('message', function (event) {
		var event = event.data;

		if (event.action === 'showInteraction') {
			$('#side_notify').html(event.data.text);

			if (event.data.type === 'success') {
				$('#side_notify').css('background-color', 'rgba(22, 163, 74, 0.397)')
			} else if (event.data.type === 'error') {
				$('#side_notify').css('background-color', 'rgba(220, 38, 28, 0.397)')
			} else {
				$('#side_notify').css('background-color', 'rgba(2, 132, 199, 0.397)')
			}

			$('#side_notify').css({'display':'block'}).animate({left: '10px',}, 400);
		} else if (event.action === 'hideInteraction') {
			$('#side_notify').css({'display':'block'}).animate({left: '-100%',}, 400, function() { $('#side_notify').css({'display':'none'}) });
		} else if (event.action === 'inventoryNotification') {
			let $notification = $(`<div>${event.data.text}</div>`);
			$('#inventory_notifications').append($notification);
	
            setTimeout(function () {
                $notification.fadeOut(300)
            }, 5000)
		}
	});
});