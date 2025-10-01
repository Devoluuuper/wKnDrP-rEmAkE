let selectedCharacter = 0;
let offences = [];
const selectedOffences = [];

let zone = ''

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
      $.post("https://kk-tuner/disableFocus", JSON.stringify({}));
    }
  });
  window.addEventListener("message", function (event) {
    var event = event.data;
    
    if (event.action === "loadResults") {
      updateData('update-vehicles', event.data.vehicles);
      updateData('update-vehiclesimp', event.data.vehiclesimp);
    } else {
      if (event.action === 'showTablet') {
        $('#tabletBody').show()
        zone = event.data
      } else {
        if (event.action === 'showNotification') {
          showNotification(
            event.data.title,
            event.data.text,
            event.data.type
          )
        } else {
          if (event.action === 'loadImpound') {
            updateData('update-impound', event.data)
          } else {
            event.action === 'vehOut' && search()
          }
        }
      }
    }
  })
  $("#search").click(function () {
    $("#loading").show();
    $.post("https://kk-tuner/search", JSON.stringify({ context: $("#searchContext").val() }));

    setTimeout(() => { 
      $("#profilePage").hide()
      $("#mainElement").addClass("overflow-y-auto");
      $("#loading").hide();
      $("#resultSearching").show();
    }, "300")
  })
  $("#searchimp").click(function () {
    $("#loading2").show();
    $.post("https://kk-tuner/searchimp", JSON.stringify({ context: $("#searchContextImp").val() }));

    setTimeout(() => { 
      $("#loading2").hide();
      $("#resultSearching").show();
    }, "300")
  })  

  $(document).on('click', '#spawnveh', function () {
    let model = $(this).attr('model');
    const options = {
        title: 'Auto näitamine',
        icon: 'question',
        html: '<div><h4>Oled sa kindel, et soovid seda sõidukit näidata?</h4></div>',
        showCancelButton: true,
        confirmButtonColor: 'RoyalBlue',
        cancelButtonColor: 'IndianRed',
        allowEscapeKey: false,
        allowOutsideClick: false,
        cancelButtonText: 'Loobu',
        confirmButtonText: 'Kinnita',
        keydownListenerCapture: true,
    };

    Swal.fire(options).then((result) => {
        if (result.isConfirmed) {
            const data = { model: model };
            $.post('https://kk-tuner/showVehicle', JSON.stringify(data));
        }
    });
});

$(document).on('click', '#vehinfo', function () {
  const brand = $(this).data('brand');
  const name = $(this).data('name');
  const vehicleClass = $(this).data('class');
  const price = $(this).data('price');
  const ownerName = $(this).data('ownername');

  Swal.fire({
      title: `${brand} ${name}`,
      html: `
          <h2>Sõiduki klass:</h2>
          <input type="text" class="swal2-input bg-gray-800 text-white" value="${vehicleClass}" disabled>

          <h2 class="mt-2">Sõiduki hind:</h2>
          <input type="text" class="swal2-input bg-gray-800 text-white" value="$${price}" disabled>

          <h2 class="mt-2">Omanik:</h2>
          <input type="text" class="swal2-input bg-gray-800 text-white" value="${ownerName}" disabled>
      `,
      confirmButtonText: 'Confirm Changes',
      confirmButtonColor: 'RoyalBlue',
      cancelButtonColor: 'RoyalBlue',
      showConfirmButton: false,
      showCancelButton: true,
      cancelButtonText: 'Sulge',
      focusConfirm: false,
  })
});

$(document).on('click', '#spawnvehimp', function () {
  let model = $(this).attr('model');
  const options = {
      title: 'Auto näitamine',
      icon: 'question',
      html: '<div><h4>Oled sa kindel, et soovid seda sõidukit näidata?</h4></div>',
      showCancelButton: true,
      confirmButtonColor: 'RoyalBlue',
      cancelButtonColor: 'IndianRed',
      allowEscapeKey: false,
      allowOutsideClick: false,
      cancelButtonText: 'Loobu',
      confirmButtonText: 'Kinnita',
      keydownListenerCapture: true,
  };

  Swal.fire(options).then((result) => {
      if (result.isConfirmed) {
          const data = { model: model };
          $.post('https://kk-tuner/showVehicleImp', JSON.stringify(data));
      }
  });
});

$(document).on('click', '#sellveh', function () {
  let model = $(this).attr('model');
  Swal.fire({
    title: 'Sõiduki müümine',
    icon: 'question',
    html: '<div><h4>Sisestage isiku isikukood:</h4></div>\n      <input type="text" id="pid" class="swal2-input" placeholder="Isikukood (ID-Kaart)">',
    showCancelButton: true,
    confirmButtonColor: 'RoyalBlue',
    cancelButtonColor: 'IndianRed',
    allowEscapeKey: false,
    allowOutsideClick: false,
    cancelButtonText: 'Loobu',
    confirmButtonText: 'Kinnita',
    keydownListenerCapture: true,
    preConfirm: () => {
      const pid = Swal.getPopup().querySelector('#pid').value;
      if (!pid) {
        Swal.showValidationMessage('Palun sisesta isiku isikukood kellel soovite seda müüa!');
      } else {
        const data = {
          model: model,
          pid: pid
        };
        $.post('https://kk-tuner/sellVehicle', JSON.stringify(data));
      }
    },
  });
});

$(document).on('click', '#sellvehimp', function () {
  let model = $(this).attr('model');
  Swal.fire({
    title: 'Sõiduki müümine',
    icon: 'question',
    html: '<div><h4>Sisestage isiku isikukood:</h4></div>\n      <input type="text" id="pid" class="swal2-input" placeholder="Isikukood (ID-Kaart)">',
    showCancelButton: true,
    confirmButtonColor: 'RoyalBlue',
    cancelButtonColor: 'IndianRed',
    allowEscapeKey: false,
    allowOutsideClick: false,
    cancelButtonText: 'Loobu',
    confirmButtonText: 'Kinnita',
    keydownListenerCapture: true,
    preConfirm: () => {
      const pid = Swal.getPopup().querySelector('#pid').value;
      if (!pid) {
        Swal.showValidationMessage('Palun sisesta isiku isikukood kellel soovite seda müüa!');
      } else {
        const data = {
          model: model,
          pid: pid
        };
        $.post('https://kk-tuner/sellVehicleImp', JSON.stringify(data));
      }
    },
  });
});

$(document).on('click', '#despawnvehimp', function () {
  let model = $(this).attr('model');
  const data = { model: model };
  $.post('https://kk-tuner/despawnvehimp', JSON.stringify(data));
})

  $(document).on('click', '#despawnveh', function () {
    let model = $(this).attr('model');
    const data = { model: model };
    $.post('https://kk-tuner/despawnveh', JSON.stringify(data));
  })
})
function showNotification(title, text, type) {
  Swal.fire({
    icon: type,
    title: title,
    text: text,
  });
}
function search() {
  $('#loading').show()
  if (zone === 'tunershop') {
    $.post(
      'https://kk-tuner/search',
      JSON.stringify({ context: $('#searchContext').val() })
    )
  }
  setTimeout(() => {
    $('#mainElement').addClass('overflow-y-auto')
    $('#loading').hide()
  }, '300')
}

function searchimp() {
  $('#loading2').show()
  if (zone === 'tunershop') {
    $.post(
      'https://kk-tuner/searchimp',
      JSON.stringify({ context: $('#searchContextImp').val() })
    )
  }
  setTimeout(() => {
    $('#loading2').hide()
  }, '300')
}