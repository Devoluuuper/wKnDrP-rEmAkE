
$(function () {
	var currentPlayer = 0;

    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27' && currentPlayer === 0) {
            $.post('https://kk-police/closeApplication', JSON.stringify({}));
        } else if (keycode == '27' && currentPlayer != 0) {
			$.post('https://kk-police/close_image', JSON.stringify({}));
		}
    });

	updateClock();

	function updateClock() {
		var today = new Date();
		var date = ("0" + today.getDate()).slice(-2) + "." + ("0"+(today.getMonth()+1)).slice(-2) + "." + today.getFullYear() + " " + ("0" + today.getHours()).slice(-2) + ":" + ("0" + today.getMinutes()).slice(-2) + ":" + ("0" + today.getSeconds()).slice(-2);

		$("#time").text(date);
		setTimeout(updateClock, 1000);
	}

    function cropImage(base64Image, cropParams, gyazoApi) {
        return new Promise((resolve, reject) => {
            // Create a new Image object
            var img = new Image();
    
            // Set onload function to handle image processing
            img.onload = function() {
                // Create a canvas element for image manipulation
                var canvas = document.createElement('canvas');
                var ctx = canvas.getContext('2d');
    
                // Set canvas size to the cropped region
                canvas.width = cropParams.width;
                canvas.height = cropParams.height;
    
                // Draw the cropped region onto the canvas
                ctx.drawImage(img, cropParams.offsetX, cropParams.offsetY, cropParams.width, cropParams.height, 0, 0, cropParams.width, cropParams.height);
    
                // Convert canvas content to data URL
                var croppedDataUrl = canvas.toDataURL('image/jpeg');
    
                // Convert data URL to Blob
                var byteString = atob(croppedDataUrl.split(',')[1]);
                var mimeString = croppedDataUrl.split(',')[0].split(':')[1].split(';')[0];
                var ab = new ArrayBuffer(byteString.length);
                var ia = new Uint8Array(ab);
                for (var i = 0; i < byteString.length; i++) {
                    ia[i] = byteString.charCodeAt(i);
                }
                var blob = new Blob([ab], { type: mimeString });
    
                // Upload the cropped image to Gyazo
                var formData = new FormData();
                formData.append('imagedata', blob);
    
                fetch('https://upload.gyazo.com/api/upload', {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'Authorization': `Bearer ${gyazoApi}`
                    }
                })
                .then(response => response.json())
                .then(data => {
                    // Handle Gyazo response (data.url contains the URL of the uploaded image)
                    // console.log('Uploaded to Gyazo:', data.url);
                    resolve(data.url); // Resolve with the Gyazo image link
                })
                .catch(error => {
                    // Handle error
                    // console.error('Error uploading to Gyazo:', error);
                    reject(error); // Reject with the error
                });
            };
    
            // Set the src attribute of the Image object to the base64 string
            img.src = base64Image;
        });
    }

	window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'show') {
            $('#container').fadeIn(400);

			$('#department').text(event.data.department);
			$('#rank').text(event.data.rank);
			$('#name').text(event.data.name);
        } else if (event.action === 'hide') {
            $('#container').fadeOut(400);
		} else if (event.action === 'show_candidation') {
			$('#myName').val(event.data.name);
            $('#candidation_document').show();
		} else if (event.action === 'show_statement') {
			$('#myName2').val(event.data.name);
            $('#statement_document').show();
		} else if (event.action === 'hide_forms') {
            $('#statement_document').hide(); $('#candidation_document').hide();
        } else if (event.action === 'open_image') {
			$('#image_container').show(); currentPlayer = event.id
        } else if (event.action === 'close_image') {
			$('#image_container').hide(); currentPlayer = 0
        } else if (event.action === 'open_radar') {
			$('#radar_container').show();
        } else if (event.action === 'close_radar') {
			$('#radar_container').hide();
        } else if (event.action === 'radar_update') {
            $('#radar_speed').text(event.data.speed + ' mph');
			$('#radar_distance').text(event.data.distance + ' ft');
            $('#radar_plate').text(event.data.plate);
        } else if (event.action === 'crop_image') {
            cropImage(event.data.image, event.data.params, event.data.image_api)
            .then(imageLink => {
                $.post('https://kk-police/updateDatabase', JSON.stringify({success: true, player: event.data.player, image: imageLink}));
            })
            .catch(error => {
                $.post('https://kk-police/updateDatabase', JSON.stringify({success: false}));
            });
		} else if (event.action === 'hideAll') {
            $('body').hide()
        } else if (event.action === 'showAll') {
            $('body').show()
        }
    });

    $(document).on("click", "#submit", function () {
		$.post('https://kk-police/sendApplication', JSON.stringify({ email: $('#myEmail').val(), text: $('#myCandidationText').val() }), function(cb) {
			if (cb) {
				$('#myEmail').val(''); $('#myCandidationText').val(''); 
				$.post('https://kk-police/closeApplication', JSON.stringify({}));
			}
		});
    });

	$(document).on("click", "#submitStatement", function () {
		$.post('https://kk-police/sendStatement', JSON.stringify({ email: $('#myEmail2').val(), text: $('#myStatementText').val() }), function(cb) {
			if (cb) {
				$('#myEmail2').val(''); $('#myStatementText').val(''); 
				$.post('https://kk-police/closeApplication', JSON.stringify({}));
			}
		});
    });

	$("#doScreenshot").click(function(){
        var offset = $('#image').offset();

        $.post('https://kk-police/postImage', JSON.stringify({top: offset.top, left: offset.left, player: currentPlayer}));
    });
    
    dragElement(document.getElementById("image_box"));
    
    function dragElement(elmnt) {
        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
        if (document.getElementById(elmnt.id + "header")) {
            // if present, the header is where you move the DIV from:
            document.getElementById(elmnt.id + "header").onmousedown = dragMouseDown;
        } else {
            // otherwise, move the DIV from anywhere inside the DIV:
            elmnt.onmousedown = dragMouseDown;
        }
    
        function dragMouseDown(e) {
            e = e || window.event;
            e.preventDefault();
            // get the mouse cursor position at startup:
            pos3 = e.clientX;
            pos4 = e.clientY;
            document.onmouseup = closeDragElement;
            // call a function whenever the cursor moves:
            document.onmousemove = elementDrag;
        }
    
        function elementDrag(e) {
            e = e || window.event;
            e.preventDefault();
            // calculate the new cursor position:
            pos1 = pos3 - e.clientX;
            pos2 = pos4 - e.clientY;
            pos3 = e.clientX;
            pos4 = e.clientY;1
            // set the element's new position:
            elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
            elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
        }
    
        function closeDragElement() {
            // stop moving when mouse button is released:
            document.onmouseup = null;
            document.onmousemove = null;
        }
    }
})