$("body,html").css("overflow", "hidden");

function updateData(eventName, items) {
  let event = new CustomEvent(eventName, {
    detail: {
      items: items,
    },
  });
  window.dispatchEvent(event);
}

function toggleMenuDisplay(state) {
  $("#tabletBody").css({ display: state === true ? "block" : "none" });
}

$(document).ready(function () {
  // ESC keypress to close the menu
  $(document).keydown(function (event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    if (keycode == "27") {
      toggleMenuDisplay(false);
      $.post("https://kk-properties/disableFocus", JSON.stringify({}));
    }
  });

  window.addEventListener("message", function (event) {
    var event = event.data;

    if (event.action === "loadResults") {
      updateData("update-properties-list", event.data);
    } else if (event.action === "showTablet") {
      $("#tabletBody").show();
    } else if (event.action === "showNotification") {
      showNotification(event.data.title, event.data.text, event.data.type);
    } else if (event.action === "loadhouseResults") {
      updateData("update-houses-list", event.data);
    } else if (event.action === "loadLabs") {
      updateData("update-labs-list", event.data);
    }
  });  

  $("#search").click(function () {
    $.post("https://kk-properties/search", JSON.stringify({ context: $("#searchContext").val() }));
  })

  $("#searchhouses").click(function () {
    $.post("https://kk-properties/searchhouses", JSON.stringify({ context: $("#searchhouseContext").val() }));
  })

  $(document).on("click", "#markLocation", function () {
    $.post("https://kk-properties/markLocation", JSON.stringify({ id: $(this).attr("warehouse-id") }));
  });

  $(document).on("click", "#forceOpen", function () {
    $.post("https://kk-properties/forceOpen", JSON.stringify({ id: $(this).attr("warehouse-id") }));
  });

  $(document).on("click", "#removeWarehouse", function () {
    $.post("https://kk-properties/removeWarehouse", JSON.stringify({ id: $(this).attr("warehouse-id") }));
  });

  $(document).on("click", "#markLocationlab", function () {
    $.post("https://kk-properties/markLocationlab", JSON.stringify({ id: $(this).attr("lab-id") }));
  });


  $(document).on("click", "#searchlabs", function () {
    $.post("https://kk-properties/searchlabs", JSON.stringify({ context: $("#searchlabsContext").val() }));
  });

  $("#upgrade").click(function () {
    Swal.fire({
      title: 'Korteri uuendamine',
      html: "<div><h4>Kas soovite uuendada mängija korterit?</h4></div><div class='mt-2'> <div class='mt-2'><input class='m-1 w-96 bg-gray-200 rounded text-sm text-gray-900 sm:mt-0 sm:col-span-2 px-3 pb-3 focus:outline-none border-gray-300 transition' type='number' aria-label='Isikukood' placeholder='Isikukood' id='pid' style='display: absolute;'></div>",
      icon: 'question',
      showCancelButton: true,
      confirmButtonColor: 'green',
      cancelButtonColor: 'red',
      cancelButtonText: 'Loobu',
      confirmButtonText: 'Kinnita'
    }).then((result) => {
      if (result.isConfirmed) {
          var pid = $('#pid').val()
          
          $.post("https://kk-properties/upgradeApartment", JSON.stringify({ pid: pid }));
      }
  })
  });

  $("#new").click(function () {
    Swal.fire({
      title: 'Lao lisamine',
      html: "<div><h4>Kas soovite lisada uue lao lähimale mängijale?</h4></div><div class='mt-2'> <div class='mt-2'><input type='number' class='m-1 w-96 bg-gray-200 rounded text-sm text-gray-900 sm:mt-0 sm:col-span-2 px-3 pb-3 focus:outline-none border-gray-300 transition' aria-label='Hind ($)' placeholder='Hind ($)' id='price' style='display: absolute;'></div>",
      icon: 'question',
      showCancelButton: true,
      confirmButtonColor: 'green',
      cancelButtonColor: 'red',
      cancelButtonText: 'Loobu',
      confirmButtonText: 'Kinnita'
    }).then((result) => {
      if (result.isConfirmed) {
          var price = $('#price').val()
          
          $.post("https://kk-properties/sellWarehouse", JSON.stringify({ price: price }));
      }
  })
  });

  $("#newhouse").click(function () {
    Swal.fire({
			title: 'Loo uus kinnisvara',
			html: `
      <input type="text" id="nimi" class="swal2-input" placeholder="Kinnisvara nimi">
      <input type="number" id="hind" class="swal2-input" placeholder="Hind">
      <select class="swal2-input" id="sisustus">
        <option value="modern" selected>Moderne</option>
        <option value="mody">Moekas</option>
        <option value="vibrant">Elujõuline</option>
        <option value="sharp">Terav</option>
        <option value="monochrome">Monokroomne</option>
        <option value="seductive">Kaasahaarav</option>
        <option value="regal">Kuninglik</option>
        <option value="aqua">Vesine</option>
      </select>
        `,
			confirmButtonText: 'Loo kinnisvara',
			showCancelButton: true,
			cancelButtonText: 'Katkesta',
			focusConfirm: false,
			preConfirm: () => {
				const nimi = Swal.getPopup().querySelector('#nimi').value
				const sisustus = Swal.getPopup().querySelector('#sisustus').value
				const hind = Swal.getPopup().querySelector('#hind').value
				if (!nimi|| !sisustus || !hind) {
				Swal.showValidationMessage(`Palun sisesta kõik andmed!`)
				}
				$.post('https://kk-properties/sellHouse', JSON.stringify({nimi: nimi, sisustus: sisustus, hind: hind}));	
			}
		})
    
  });
  $("#newlab").click(function () {
    Swal.fire({
      title: 'Labori lisamine',
      html: "<div><h4>Kas soovite müüa labori lähimale mängijale?</h4></div><div class='mt-2'> <div class='mt-2'><input type='number' class='m-1 w-96 bg-gray-200 rounded text-sm text-gray-900 sm:mt-0 sm:col-span-2 px-3 pb-3 focus:outline-none border-gray-300 transition' aria-label='Hind ($)' placeholder='Hind ($)' id='price' style='display: absolute;'></div>",
      icon: 'question',
      showCancelButton: true,
      confirmButtonColor: 'green',
      cancelButtonColor: 'red',
      cancelButtonText: 'Loobu',
      confirmButtonText: 'Kinnita'
    }).then((result) => {
      if (result.isConfirmed) {
          var price = $('#price').val()
          
          $.post("https://kk-properties/sellLab", JSON.stringify({price: price }));
      }
  })
  });
});


function showNotification(title, text, type) {
  Swal.fire({
    icon: type,
    title: title,
    text: text,
  });
}
