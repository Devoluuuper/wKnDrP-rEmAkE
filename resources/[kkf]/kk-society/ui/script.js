let selectedCharacterId = undefined;
let selectedVehicleId = undefined;
let selectedGradeId = undefined;
let selectedEditingGradeId = undefined;
let bankTabData = [];
let job = "unemployed";
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
      $.post("https://kk-society/disableFocus", JSON.stringify({}));

      $.post("https://kk-society/declineInvitation", JSON.stringify({}));
      $("#invitation").hide();
    }
  });

  function updatePermissions(permissions) {
    $("*[permission-required]").each(function () {
      let permissionRequired = $(this).attr("permission-required");
      let hasPermission = permissions[permissionRequired];
      if (hasPermission) {
        $(this).show();
      } else {
        $(this).hide();
      }
    });
  }

  window.addEventListener("message", function (event) {
    var event = event.data;

    if (event.action === "loadLogs") {
      updateData("update-log-list", event.data);
    } else if (event.action === "loadBills") {
      updateData("update-bill-list", event.data);
    } else if (event.action === "openMdw") {
      $("#tabletBody").show();
      $.post("https://kk-society/refreshHome", JSON.stringify({}));
      updatePermissions(event.data);
    } else if (event.action === "loadMembers") {
      updateData("update-members", event.data);
    } else if (event.action === "loadVehicles") {
      updateData("update-buyable-vehicles", event.data);
    } else if (event.action === "updateBankTabData") {
      $("#bankBalance").html(event.data);
    } else if (event.action === "updateRankEditSection") {
      updateRankEditSection(event.data);
    } else if (event.action === "loadRanks") {
      updateData("update-promotable-ranks", event.data);
    } else if (event.action === "loadAllRanks") {
      updateData("update-all-ranks", event.data);
    } else if (event.action === "showNotification") {
      showNotification(event.data.title, event.data.text, event.data.type);
    } else if (event.action === "invitationOpen") {
      $("#invitation").show();
      $("#companyOffer").text(`Kas soovite liituda ${event.name} fraktsiooniga?`);
    } else if (event.action === "updateHome") { 
      updateData("update-societies", event.data.societies);

      $("#memberCount").text(
        `Fraktsiooni kuulub ${event.data.members}/${event.data.max} inimest.`
      );
      
      $("#societyName").text(
	      `${event.data.name}`
	    );

      if (event.data.properties.stash) {
        $("#buySafe").hide()
      } else if (event.data.properties.stash === false) {
        if (event.data.hasBanking) {
          $("#buySafe").show()
        } else {
          $("#buySafe").hide()
        }
      }
	 $("#PlayerName").text(
	  `Tere tulemast, ${event.data.playername}!`
	  );
	 $("#Grade").text(
	  `Kuulud fraktsiooni ${event.data.name}, auastmel ${event.data.grade} ja sinu palk on $${event.data.salary} TUND.`
	  );
    }
  });

  function updateRankEditSection(data) {
    $("#rankSalaryInput").val(data.salary);

    $.each(data.permissions, function (rankKey, rankValue) {
      $("button[rank-property-name='" + rankKey + "']")
        .parent()
        .closest("div")
        .attr("x-data", "{ on: " + rankValue + " }");
    });
  }

  function hideRankEditSection() {
    $("#editRankSection").fadeOut(300, function () {
      $("#rankListSection").fadeIn(100);
      $("#rankCreation").fadeIn(100);
    });
  }

  function getRankPermissions() {
    var values = {};

    $("button[rank-property-name]").each(function () {
      var booleanValue = $(this).attr("value") === "true";
      values[$(this).attr("rank-property-name")] = booleanValue;
    });

    return values;
  }

  // Safe
  $("#buySafe").click(function () {
    $.post("https://kk-society/buySafe", JSON.stringify({}));
  });

  // Refresh system
  $("#refreshMembersButton").click(function () {
    $.post("https://kk-society/refreshMembersButton", JSON.stringify({}));
  });

  $("#refreshRanksButton").click(function () {
    $.post("https://kk-society/refreshRanksButton", JSON.stringify({}));
  });

  $("#refreshHome").click(function () {
    $.post("https://kk-society/refreshHome", JSON.stringify({}));
  });

  $("#refreshBillsButton").click(function () {
    $.post("https://kk-society/refreshBillsButton", JSON.stringify({}));
  });

  $("#refreshVehiclesButton").click(function () {
    $.post("https://kk-society/refreshVehiclesButton", JSON.stringify({}));
  });

  $("#refreshBankButton").click(function () {
    $.post("https://kk-society/refreshBankButton", JSON.stringify({}));
  });
  //

  $("#logSearch").click(function () {
    $.post("https://kk-society/requestLogs", JSON.stringify({ pid: $("#logPid").val(), context: $("#logContext").val() }));
  }); 

  $("#leaveSociety").click(function () {
    $.post("https://kk-society/leaveSociety", JSON.stringify({}));

    toggleMenuDisplay(false);
    $.post("https://kk-society/disableFocus", JSON.stringify({}));
  });
  
  $("#acceptInvitation").click(function () {
    $.post("https://kk-society/acceptInvitation", JSON.stringify({}));
    $("#invitation").hide();
  });

  $("#declineInvitation").click(function () {
    $.post("https://kk-society/declineInvitation", JSON.stringify({}));
    $("#invitation").hide();
  });

  $("#createNewRank").click(function () {
    $.post(
      "https://kk-society/createNewRank",
      JSON.stringify({ rankName: $("#newRankName").val() })
    );
    reloadData();
  });

  $("#sendJobInviteButton").click(function () {
    $.post(
      "https://kk-society/inviteToCompany",
      JSON.stringify({ invitedCharacterId: $("#companyInviteInput").val() })
    );
    reloadData();
  });

  $("#backToRankListButton").click(function () {
    hideRankEditSection();
    reloadData();
  });

  $("#rankListBackFunction").click(function () {
    reloadData();
  });

  $("#deleteCurrentRank").click(function () {
    hideRankEditSection();
    $.post(
      "https://kk-society/deleteRank",
      JSON.stringify({ rankId: selectedEditingGradeId })
    );
    reloadData();
  });

  $("#saveRankButton").click(function () {
    hideRankEditSection();
    let salary = $("#rankSalaryInput").val();
    $.post(
      "https://kk-society/saveRank",
      JSON.stringify({
        rankId: selectedEditingGradeId,
        rankSalary: salary,
        permissions: getRankPermissions(),
      })
    );
    reloadData();
  });

  $(document).on("click", "#editRankButton", function () {
    selectedEditingGradeId = $(this).attr("rank-id");
    $("#rankCreation").fadeOut(300);
    $("#rankListSection").fadeOut(300, function () {
      $("#editRankSection").fadeIn(100);
    });
    $.post(
      "https://kk-society/loadEditRank",
      JSON.stringify({ rankId: selectedEditingGradeId })
    );
    reloadData();
  }); 

  $(document).on("click", "#chooseSociety", function () {
    $.post("https://kk-society/chooseSociety", JSON.stringify({ name: $(this).attr("job"), grade: $(this).attr("grade"), label: $(this).attr("label") }), function() {
      reloadData();

      toggleMenuDisplay(false);
      $.post("https://kk-society/disableFocus", JSON.stringify({}));
    });
  });

  $(document).on("click", "#changeUserRank", function () {
    reloadData();
    selectedCharacterId = $(this).attr("character-id");
    openPromoteMenu(selectedCharacterId);
  });

  $(document).on("click", "#rankListBackFunction", function () {
    $("#rankChanger").fadeOut(300, function () {
      $("#rankList").fadeIn(100);
    });
  });

  $(document).on("click", "#changeUserSerial", function () {
    toggleMenuDisplay(false);
    $.post("https://kk-society/disableFocus", JSON.stringify({}));

    $.post(
      "https://kk-society/openBadge",
      JSON.stringify({ pid: $(this).attr("character-id") })
    );
  });
  
    $(document).on("click", "#changeUserCallsign", function () {
    toggleMenuDisplay(false);
    $.post("https://kk-society/disableFocus", JSON.stringify({}));

    $.post(
      "https://kk-society/openSign",
      JSON.stringify({ pid: $(this).attr("character-id") })
    );
  });

  $(document).on("click", "#rankChangeFull", function () {
    selectedGradeId = $(this).attr("rank-id");
    changeUserRank(selectedCharacterId, selectedGradeId);
  });

  $(document).on("click", "#removeFromCompany", function () {
    selectedCharacterId = $(this).attr("character-id");
    removeFromCompany(selectedCharacterId);
  });

  $(document).on("click", "#buyCompanyVehicle", function () {
    selectedVehicleId = $(this).attr("car-id");
    buyCompanyVehicle(selectedVehicleId);
  });
});

function openPromoteMenu(playerId) {
  $("#rankList").fadeOut(300, function () {
    $("#rankChanger").fadeIn(100);
  });
}

function changeUserRank(playerId, gradeNr) {
  $.post(
    "https://kk-society/changeRank",
    JSON.stringify({ invitedCharacterId: playerId, gradeId: gradeNr })
  );
  $("#rankChanger").fadeOut(300, function () {
    $("#rankList").fadeIn(100);
    reloadData();
  });
}

function removeFromCompany(playerId) {
  $.post(
    "https://kk-society/removeFromCompany",
    JSON.stringify({ invitedCharacterId: playerId })
  );
  reloadData();
  $("#rankChanger").fadeOut(300, function () {
    $("#rankList").fadeIn(100);
  });
  toggleMenuDisplay(false);
  $.post("https://kk-society/disableFocus", JSON.stringify({}));
}

function buyCompanyVehicle(vehId) {
  $.post(
    "https://kk-society/buyVehicle",
    JSON.stringify({ selectedId: vehId })
  );
  reloadData();
}

function executeReload() {
  $.post("https://kk-society/reloadAllData", JSON.stringify({}));
}

function reloadData() {
  setTimeout(executeReload, 300);
}

function showNotification(title, text, type) {
  Swal.fire({
    icon: type,
    title: title,
    text: text,
  });
}
