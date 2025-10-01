let selectedCharacter = 0;
let offences = [];
const selectedOffences = [];

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
      $.post("https://kk-emscad/disableFocus", JSON.stringify({}));
    }
  });

  window.addEventListener("message", function (event) {
    var event = event.data;

    if (event.action === "loadResults") {
      updateData('update-search-results-persons', event.data.persons);
      updateData('update-search-results-vehicles', event.data.vehicles);
      updateData('update-search-results-weapons', event.data.weapons); 
    } else if (event.action === "showTablet") {
      $("#tabletBody").show();
    } else if (event.action === "showNotification") {
      showNotification(event.data.title, event.data.text, event.data.type);
    } else if (event.action === "loadFines") {
      updateData('update-injuries-list', event.data);
      if (event.first) offences = event.data
    } else if (event.action === "loadRecords") {
      updateData('update-search-criminal-records', event.data); 
    } else if (event.action === "loadCharacter") {
      $("#profileName").text(event.data.fullname); 
      $("#profileDob").text(event.data.dob);
      $("#profilePhone").text(event.data.phone);
      $("#profileJob").text(event.data.job); 
	    $("#profileHealth").text(event.data.health);
      
      if (event.data.health === 'Tervisetõend: Kehtib') {
        $('#removeLicense').show(); $('#giveLicense').hide()
      } else {
        $('#giveLicense').show(); $('#removeLicense').hide()
      }

      document.getElementById("profileNotes").value = event.data.notes;
      $('#profilePicture').attr("src", event.data.profilepic);

      if (event.data.is_wanted) {
        $("#wanted").removeClass("bg-green-600");
        $("#wanted").addClass("bg-red-600");
      } else {
        $("#wanted").removeClass("bg-red-600");
        $("#wanted").addClass("bg-green-600");
      }

      $("#wantedReason").text(event.data.wanted_reason);
      updateData('update-licenses', event.data.licenses); 
    } else if (event.action === "backToResults") {
      $("#loadingPage").show();

      setTimeout(() => { 
        $("#profilePage").hide()
        $("#mainElement").addClass("overflow-y-auto");
        $("#loadingPage").hide();
        $("#resultSearching").show();
      }, "810")
    } else if (event.action === "reloadCharacter") {
      loadCharacter(selectedCharacter);
    } else if (event.action === "loadCharacterProperties") { 
      updateData('update-search-owned-vehicles', event.data.vehicles);
      updateData('update-search-owned-weapons', event.data.weapons); 
    } else if (event.action === "loadWanted") { 
      updateData('update-wanted-persons', event.data);
    } else if (event.action === "loadOffenceDetails") { 
      $("#offenceOfficerName").text(event.data.medic); 
      $("#offenceFineAmount").text(event.data.bill);
      $("#offenceDescription").text(event.data.description);
      $("#offensesList").text(event.data.injuries);
    }
  });  

  $(document).on("click", "#showOffenceDetails", function () {
    let currentOffence = $(this).attr("Offence-id")

    Swal.fire({
      title: 'Detailvaade #' + currentOffence,
      allowEscapeKey: false,
      allowOutsideClick: true,
      html: "<div><h4 style='margin-left:34px;text-align:left'>Täitev meedik: <span id='offenceOfficerName'>---</span></h4><h4 style='margin-left:34px;text-align:left'>Arve summa: <span id='offenceFineAmount'>$0</span></h4></div><div class='mt-2'><h4 style='margin-left:34px;text-align:left'>Olukorra kirjeldus:</h4><textarea disabled maxlength='535' type='text' style='resize: none;' class='m-1 w-96 bg-gray-200 rounded text-sm text-gray-900 sm:mt-0 sm:col-span-2 px-3 pb-3 focus:outline-none border-gray-300 transition' aria-label='Olukorra kirjeldus' placeholder='Olukorra kirjeldus' id='offenceDescription' style='display: absolute;'></textarea> </div><h4 style='margin-left:34px;text-align:left'>Vigastused:</h4><textarea maxlength='535' type='text' class='m-1 w-96 bg-gray-200 rounded text-sm text-gray-900 sm:mt-0 sm:col-span-2 px-3 pb-3 focus:outline-none border-gray-300 transition' style='resize: none;' disabled aria-label='Rikkumised' placeholder='Rikkumised' id='offensesList' style='display: absolute;'></textarea> </div>",
      showCancelButton: false,
      showConfirmButton: false,
      didOpen: () => {
        $.post("https://kk-emscad/loadOffenceDetails", JSON.stringify({ id: currentOffence }));
      },
    });
  }); 

  $("#offensesButton").click(function () {
    $.post("https://kk-emscad/searchOffenses", JSON.stringify({context: $("#searchOffenses").val()}));
  }) 

  $("#loadCharacterProperties").click(function () {
    $.post("https://kk-emscad/loadCharacterProperties", JSON.stringify({ id: selectedCharacter }));
  }) 

  $("#previousRecords").click(function () {
    $.post("https://kk-emscad/loadRecords", JSON.stringify({ id: selectedCharacter }));
  }) 

  $("#search").click(function () {
    $("#loadingPage").show();
    $.post("https://kk-emscad/search", JSON.stringify({ context: $("#searchContext").val() }));

    setTimeout(() => { 
      $("#profilePage").hide()
      $("#mainElement").addClass("overflow-y-auto");
      $("#loadingPage").hide();
      $("#resultSearching").show();
    }, "300")
  }) 

  $("#profileSaveNotes").click(function () {
    $.post("https://kk-emscad/saveNotes", JSON.stringify({ notes: $("#profileNotes").val(), id: selectedCharacter }));
  }) 

  $("#backToResults").click(function () {
    $("#loadingPage").show();

    setTimeout(() => { 
      $("#profilePage").hide()
      $("#mainElement").addClass("overflow-y-auto");
      $("#loadingPage").hide();
      $("#resultSearching").show();
    }, "300")
  })
  
  let maxFine = 0; let minFine = 0;

  $(document).on("click", "#removePunishment", function () {
    selectedOffense = +$(this).attr("selected-offense") - +1

    if (selectedOffences.includes(offences[selectedOffense].label)) {
      const index = selectedOffences.indexOf(offences[selectedOffense].label)

      if (index > -1) { 
        selectedOffences.splice(index, 1)
        $('#selecedOffences').text(selectedOffences) 
      }

      maxFine = +maxFine - +offences[selectedOffense].punishments.max_fine;
      minFine = +minFine - +offences[selectedOffense].punishments.min_fine;

      $("#fineSelected").attr({ "max" : maxFine, "min" : minFine });
      $("#fineSelected").val(minFine)

      $("#maxFine").text(maxFine);
      $("#minFine").text(maxFine);
    } else {
      showNotification('Sissekande loomine', 'Antud vigastus ei ole veel valitud!', 'error');
    }
  });

  $(document).on("click", "#addPunishment", function () {
    selectedOffense = +$(this).attr("selected-offense") - +1

    if (selectedOffences.includes(offences[selectedOffense].label) === false) {
      selectedOffences.push(offences[selectedOffense].label)
      $('#selecedOffences').text(selectedOffences)

      maxFine = +maxFine + +offences[selectedOffense].punishments.max_fine
      minFine = +minFine + +offences[selectedOffense].punishments.min_fine

      $("#fineSelected").attr({ "max" : maxFine, "min" : minFine });

      $("#fineSelected").val(minFine)

      $("#maxFine").text(maxFine);
      $("#minFine").text(maxFine);
    } else {
      showNotification('Sissekande loomine', 'Antud vigastus on juba valitud!', 'error');
    }
  });

  $("#fineSelected").change(function () {
    var newValue = $(this).val();

    if (newValue > maxFine) {
      $("#fineSelected").val(minFine);
    } else if (newValue < minFine) {
      $("#fineSelected").val(minFine);
    }
  });
  

  $(document).on('click', '#confirmCase', function () {
    if (selectedOffences.length > 0) {
      $.post('https://kk-emscad/createCase', JSON.stringify({
        pid: selectedCharacter,
        offences: selectedOffences,
        notes: $('#caseNotes').val(),
        fine: $('#fineSelected').val(),
    }));

    maxFine = 0
    minFine = 0

    $('#selecedOffences').text('')

    $("#fineSelected").attr({ "max" : 0, "min" : 0 });

    $("#fineSelected").val(0); $("#timeSelected").val(0) 
    $("#caseNotes").val('');


    $("#maxFine").text(0)
    $("#minFine").text(0)

    selectedOffences.length = 0
    console.log(selectedOffences)

    $("#loadingPage").show();

    setTimeout(() => { 
      $("#loadingPage").hide();
      loadCharacter(selectedCharacter);
    }, "800")
    } else {
      showNotification('Sissekande loomine', 'Enne kinnitamist valige Vigastused!', 'error');
    }
  });

  $(document).on("click", "#openProfile", function () {
    selectedCharacter = $(this).attr("player-id")
    loadCharacter(selectedCharacter);

    $("#loadingPage").show();
    $("#resultSearching").hide();

    setTimeout(() => { 
      $("#loadingPage").hide();
      $("#mainElement").removeClass("overflow-y-auto");
      $("#profilePage").show();
    }, "800")
  });
  
   $(document).on("click", "#giveLicense", function () {
    $.post("https://kk-emscad/giveLicense", JSON.stringify({ id: selectedCharacter }));

    loadCharacter(selectedCharacter);
  });

  $(document).on("click", "#removeLicense", function () {
    $.post("https://kk-emscad/removeLicense", JSON.stringify({ id: selectedCharacter }));

    loadCharacter(selectedCharacter);
  });



  function loadCharacter(id) {
    $.post("https://kk-emscad/loadCharacter", JSON.stringify({ id: id }));
    $.post("https://kk-emscad/loadRecords", JSON.stringify({ id: id }));
  }
  
});

function showNotification(title, text, type) {
  Swal.fire({
    icon: type,
    title: title,
    text: text,
  });
}