$(document).ready(function () {
    let _0x200fa0 = {};
    let _0x5187c1 = false;
    let _0x31c464 = null;
    $(document).keydown(function (_0x28b2f7) {
      var _0x14b7b1 = _0x28b2f7.keyCode ? _0x28b2f7.keyCode : _0x28b2f7.which;
      if (_0x14b7b1 == '27') {
        $.post("https://kk-admin2/closeMenu", JSON.stringify({}));
      }
    });
    $(document).on("click", "#announceButton", function () {
      $.post("https://kk-admin2/announceButton", JSON.stringify({
        'text': $("#announceText").val()
      }));
    });
    $(document).on("click", "#giveItem", function () {
      $.post("https://kk-admin2/giveItem", JSON.stringify({
        'target': $("#giveItemTarget").val(),
        'name': $("#giveItemName").val(),
        'count': $("#giveItemCount").val()
      }));
    });
    $(document).on("click", "#requestScreenshot", function () {
      $.post("https://kk-admin2/requestScreenshot", JSON.stringify({
        'target': $("#requestScreenshotTarget").val()
      }));
    });
    $(document).on("click", "#spawnEntity", function () {
      $.post("https://kk-admin2/spawnEntity", JSON.stringify({
        'type': $("#spawnEntityType").val(),
        'argument': $("#spawnEntityArgument").val()
      }));
    });
    $(document).on("click", "#deleteEntity", function () {
      $.post("https://kk-admin2/deleteEntity", JSON.stringify({
        'type': $("#deleteEntityType").val(),
        'radius': $("#deleteEntityRadius").val()
      }));
    });
    $(document).on("click", "#jailPerson", function () {
      $.post("https://kk-admin2/jailPerson", JSON.stringify({
        'target': $("#jailTarget").val(),
        'time': $("#jailTime").val()
      }));
    });
    $(document).on("click", "#activateNoclip", function () {
      $.post("https://kk-admin2/activateNoclip", JSON.stringify({}));
    });
    $(document).on("click", "#onlineBanPlayer", function () {
      $.post("https://kk-admin2/onlineBanPlayer", JSON.stringify({
        'target': $("#onlineBanTarget").val(),
        'time': $("#onlineBanTime").val(),
        'reason': $("#onlineBanReason").val()
      }));
    });
    $(document).on("click", "#offlineBanPlayer", function () {
      $.post("https://kk-admin2/offlineBanPlayer", JSON.stringify({
        'target': $("#offlineBanTarget").val(),
        'time': $("#offlineBanTime").val(),
        'reason': $("#offlineBanReason").val()
      }));
    });
    $(document).on("click", "#unbanPlayer", function () {
      $.post("https://kk-admin2/unbanPlayer", JSON.stringify({
        'ban_id': $("#unbanTarget").val()
      }));
    });
    $(document).on("click", "#kickPlayer", function () {
      $.post("https://kk-admin2/kickPlayer", JSON.stringify({
        'target': $("#kickTarget").val(),
        'reason': $("#kickReason").val()
      }));
    });
    $(document).on("click", "#unjailPerson", function () {
      $.post("https://kk-admin2/unjailPerson", JSON.stringify({
        'target': $("#unjailTarget").val()
      }));
    });
    $(document).on("click", "#unjailRealPerson", function () {
      $.post("https://kk-admin2/unjailRealPerson", JSON.stringify({
        'target': $("#unjailRealTarget").val()
      }));
    });
    $(document).on("click", "#revivePerson", function () {
      $.post("https://kk-admin2/revivePerson", JSON.stringify({
        'target': $("#reviveTarget").val()
      }));
    });
    $(document).on("click", "#giveAccount", function () {
      $.post("https://kk-admin2/giveAccount", JSON.stringify({
        'target': $("#giveAccountTarget").val(),
        'type': $("#giveAccountType").val(),
        'count': $("#giveAccountCount").val()
      }));
    });
    $(document).on("click", "#removeAccount", function () {
      $.post("https://kk-admin2/removeAccount", JSON.stringify({
        'target': $("#removeAccountTarget").val(),
        'type': $("#removeAccountType").val(),
        'count': $("#removeAccountCount").val()
      }));
    });
    $(document).on("click", "#playerBlips", function () {
      $.post("https://kk-admin2/playerBlips", JSON.stringify({}));
    });
    $(document).on("click", "#adminKeys", function () {
      $.post("https://kk-admin2/adminKeys", JSON.stringify({}));
    });
    $(document).on("click", "#playerNames", function () {
      $.post("https://kk-admin2/playerNames", JSON.stringify({}));
    });
    $(document).on("click", "#adminVehicleFix", function () {
      $.post("https://kk-admin2/adminVehicleFix", JSON.stringify({}));
    });
    $(document).on("click", "#adminVehicleFuel", function () {
      $.post("https://kk-admin2/adminVehicleFuel", JSON.stringify({}));
    });
    $(document).on("click", "#teleportToSpectative", function () {
      $.post("https://kk-admin2/teleportToSpectative", JSON.stringify({}));
    });
    $(document).on("click", "#teleportTo", function () {
      $.post("https://kk-admin2/teleportTo", JSON.stringify({
        'target': $("#teleportToTarget").val()
      }));
    });
    $(document).on("click", "#teleportToMe", function () {
      $.post("https://kk-admin2/teleportToMe", JSON.stringify({
        'target': $("#teleportToMeTarget").val()
      }));
    });
    $(document).on("click", "#teleportToMarker", function () {
      $.post("https://kk-admin2/teleportToMarker", JSON.stringify({}));
    });
    $(document).on("click", "#requestSpectate", function () {
      $.post("https://kk-admin2/requestSpectate", JSON.stringify({
        'target': $("#requestSpectateTarget").val()
      }));
    });
    $(document).on("click", "#saveSpectaticeNotes", function () {
      $.post("https://kk-admin2/saveSpectaticeNotes", JSON.stringify({
        'notes': $("#spectaticeNotes").val()
      }));
    });
    $(document).on("click", "#checkInventory", function () {
      $.post("https://kk-admin2/checkInventory", JSON.stringify({
        'target': $("#checkInventoryTarget").val()
      }));
    });
    $(document).on("click", "#slayPlayer", function () {
      $.post("https://kk-admin2/slayPlayer", JSON.stringify({
        'target': $("#slayPlayerTarget").val()
      }));
    });
    $(document).on("click", "#addFaction", function () {
      $.post("https://kk-admin2/addFaction", JSON.stringify({
        'target': $("#addFactionTarget").val(),
        'faction': $("#addFactionName").val(),
        'grade': $("#addFactionGrade").val()
      }));
    });
    $(document).on("click", "#clearInventory", function () {
      $.post("https://kk-admin2/clearInventory", JSON.stringify({
        'target': $("#clearInventoryTarget").val()
      }));
    });
    $(document).on("click", "#clearOfflineInventory", function () {
      $.post("https://kk-admin2/clearOfflineInventory", JSON.stringify({
        'target': $("#clearOfflineInventoryTarget").val()
      }));
    });
    $(document).on("click", "#freezePlayer", function () {
      let _0x6879a1 = 'ON';
      if ($("#freezePlayerOn").is(":checked")) {
        _0x6879a1 = 'ON';
      } else if ($("#freezePlayerOff").is(":checked")) {
        _0x6879a1 = "OFF";
      }
      $.post("https://kk-admin2/freezePlayer", JSON.stringify({
        'target': $("#freezePlayerTarget").val(),
        'radio': _0x6879a1
      }));
    });
    $(document).on("click", "#selectPrevious", function () {
      if (!_0x5187c1) {
        _0x5187c1 = true;
        $.post("https://kk-admin2/selectPrevious", JSON.stringify({}));
        setTimeout(() => {
          _0x5187c1 = false;
        }, 800);
      }
    });
    $(document).on("click", "#leaveSpectate", function () {
      if (!_0x5187c1) {
        _0x5187c1 = true;
        $.post("https://kk-admin2/leaveSpectate", JSON.stringify({}));
        setTimeout(() => {
          _0x5187c1 = false;
        }, 800);
      }
    });
    $(document).on("click", "#selectNext", function () {
      if (!_0x5187c1) {
        _0x5187c1 = true;
        $.post("https://kk-admin2/selectNext", JSON.stringify({}));
        setTimeout(() => {
          _0x5187c1 = false;
        }, 800);
      }
    });
    $(document).on("click", "#skinMenu", function () {
      $.post("https://kk-admin2/skinMenu", JSON.stringify({
        'target': $("#skinMenuTarget").val()
      }));
    });
    function _0x48bb09(_0x219744) {
      _0x31c464 = _0x219744;
      $.post("https://kk-admin2/showNotification", JSON.stringify({
        'type': "success",
        'message': "Mängija " + _0x31c464 + " valitud!"
      }));
      $(".playersOption").empty();
      $.each(_0x200fa0, function (_0x18bb74, _0x4fe474) {
        let _0x1d4f27 = _0x31c464 === _0x4fe474.source && "selected" || '';
        $(".playersOption").append("\n                <option " + _0x1d4f27 + " value=\"" + _0x4fe474.source + "\">" + _0x4fe474.source + " | " + _0x4fe474.name + " - " + _0x4fe474.playerName + "</option>\n            ");
      });
    }
    $(document).on("click", ".selectPlayer", function () {
      let _0x4cc616 = $(this).parent().data('id');
      _0x48bb09(_0x4cc616);
    });
    window.addEventListener("message", function (_0x47f48d) {
      var _0x47f48d = _0x47f48d.data;
      if (_0x47f48d.action === "open") {
        $("#adminMenu").show();
        $("#players").html('');
        $(".playersOption").empty();
        _0x200fa0 = _0x47f48d.data.players;
        let _0x3e8e9d = _0x200fa0.sort(function (_0x22a223, _0x23f574) {
          return _0x22a223.source - _0x23f574.source;
        });
        _0x200fa0 = _0x3e8e9d;
        $.each(_0x3e8e9d, function (_0x3511d7, _0x2501d4) {
          $("#players").append("\n                    <div data-id=\"" + _0x2501d4.source + "\" class=\"bg-zinc-400 dark:bg-zinc-900 border border-black dark:border-zinc-700 dark:text-zinc-300 px-1 py-1 shadow mt-1 rounded flex justify-between\">\n                        <div id=\"userData\">\n                            <div id=\"userName\" class=\"flex\">\n                                <svg xmlns=\"http://www.w3.org/2000/svg\" fill=\"none\" viewBox=\"0 0 24 24\" stroke-width=\"1.5\" stroke=\"currentColor\" class=\"w-6 h-6\">\n                                    <path stroke-linecap=\"round\" stroke-linejoin=\"round\" d=\"M17.982 18.725A7.488 7.488 0 0012 15.75a7.488 7.488 0 00-5.982 2.975m11.963 0a9 9 0 10-11.963 0m11.963 0A8.966 8.966 0 0112 21a8.966 8.966 0 01-5.982-2.275M15 9.75a3 3 0 11-6 0 3 3 0 016 0z\" />\n                                </svg>\n        \n                                <span class=\"ml-1\">" + _0x2501d4.name + " - " + _0x2501d4.playerName + "</span>\n                            </div>\n        \n                            <div id=\"userCode\" class=\"flex ml-0.5\">\n                                <svg xmlns=\"http://www.w3.org/2000/svg\" fill=\"none\" viewBox=\"0 0 24 24\" stroke-width=\"1.5\" stroke=\"currentColor\" class=\"w-5 h-6\">\n                                    <path stroke-linecap=\"round\" stroke-linejoin=\"round\" d=\"M15 9h3.75M15 12h3.75M15 15h3.75M4.5 19.5h15a2.25 2.25 0 002.25-2.25V6.75A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25v10.5A2.25 2.25 0 004.5 19.5zm6-10.125a1.875 1.875 0 11-3.75 0 1.875 1.875 0 013.75 0zm1.294 6.336a6.721 6.721 0 01-3.17.789 6.721 6.721 0 01-3.168-.789 3.376 3.376 0 016.338 0z\" />\n                                </svg>\n    \n                                <div class=\"ml-1\">\n                                    ID:<span class=\"ml-1\">" + _0x2501d4.source + "</span>;\n                                </div>\n    \n                                <div class=\"ml-1\">\n                                    PID:<span class=\"ml-1\">" + _0x2501d4.identifier + "</span>\n                                </div>\n                            </div>\n                        </div>\n                        \n                        <button class=\"selectPlayer bg-zinc-200 hover:bg-zinc-300 dark:bg-sky-800 dark:hover:bg-sky-900 px-1.5 py-2 rounded uppercase font-medium\">Vali</button>\n                    </div>\n                ");
          let _0x545f31 = _0x31c464 === _0x2501d4.source && "selected" || '';
          $(".playersOption").append("\n                    <option " + _0x545f31 + " value=\"" + _0x2501d4.source + "\">" + _0x2501d4.source + " | " + _0x2501d4.name + " - " + _0x2501d4.playerName + "</option>\n                ");
        });
        if (_0x47f48d.data.selected) {
          _0x48bb09(_0x47f48d.data.selected);
        }
        if (_0x47f48d.data.adminLevel >= 2) {
          $("#adminKeysContainer").show();
          $("#noclip").show();
          $("#adminVehicleFixContainer").show();
          $("#adminVehicleFuelContainer").show();
          $("#teleportToMarkerContainer").show();
          $("#adminJail").show();
          $("#banPlayerContainer").show();
          $("#offlineBanPlayerContainer").show();
          $("#kickPlayerContainer").show();
          $("#revive").show();
          $("#teleportToContainer").show();
          $("#teleportToMeContainer").show();
          $("#requestSpectateContainer").show();
          $("#checkInventoryContainer").show();
          $("#slayPlayerContainer").show();
          $("#freezePlayerContainer").show();
          if (_0x47f48d.data.adminLevel >= 3) {
            $("#playerBlipsContainer").show();
            $("#playerNamesContainer").show();
            $("#entitySpawning").show();
            $("#deleteSpawning").show();
            $("#itemGiving").show();
            $("#unbanPlayerContainer").show();
            $("#adminUnjail").show();
            $("#unjail").show();
            $("#giveAccountContainer").show();
            $("#addFactionContainer").show();
            $("#skinMenuContainer").show();
            $("#clearInventoryContainer").show();
          }
        } else {
          $("#adminKeysContainer").hide();
          $("#noclip").hide();
          $("#adminVehicleFixContainer").hide();
          $("#adminVehicleFuelContainer").hide();
          $("#teleportToMarkerContainer").hide();
          $("#adminJail").hide();
          $("#banPlayerContainer").hide();
          $("#offlineBanPlayerContainer").hide();
          $("#kickPlayerContainer").hide();
          $("#revive").hide();
          $("#teleportToContainer").hide();
          $("#teleportToMeContainer").hide();
          $("#requestSpectateContainer").hide();
          $("#checkInventoryContainer").hide();
          $("#slayPlayerContainer").hide();
          $("#freezePlayerContainer").hide();
          $("#playerBlipsContainer").hide();
          $("#playerNamesContainer").hide();
          $("#entitySpawning").hide();
          $("#deleteSpawning").hide();
          $("#itemGiving").hide();
          $("#unbanPlayerContainer").hide();
          $("#adminUnjail").hide();
          $("#unjail").hide();
          $("#giveAccountContainer").hide();
          $("#addFactionContainer").hide();
          $("#skinMenuContainer").hide();
          $("#clearInventoryContainer").hide();
        }
      } else {
        if (_0x47f48d.action === "close") {
          $("#adminMenu").hide();
        } else {
          if (_0x47f48d.action === "selectPlayer") {
            _0x48bb09(_0x47f48d.data.id);
          } else {
            if (_0x47f48d.action === "startSpectating") {
              $("#spectating").show();
              if (_0x47f48d.data.notes) {
                $("#spectaticeNotes").val(_0x47f48d.data.notes);
              }
              if (_0x47f48d.data.punishments) {
                $("#spectativePunishments").html('');
                $.each(_0x47f48d.data.punishments, function (_0x20c811, _0x5b69b3) {
                  let _0x1493b3 = new Date(_0x5b69b3.date);
                  let _0x120db7 = ('0' + _0x1493b3.getHours()).slice(-2) + ':' + ('0' + _0x1493b3.getMinutes()).slice(-2) + " " + ('0' + _0x1493b3.getDate()).slice(-2) + '.' + ('0' + (_0x1493b3.getUTCMonth() + 1)).slice(-2) + '.' + _0x1493b3.getFullYear();
                  $("#spectativePunishments").prepend("\n                        <tr class=\"text-center\">\n                            <td class=\"p-1\">" + _0x5b69b3.type + "</td>\n                            <td class=\"p-1\">" + _0x5b69b3.expire + "</td>\n                            <td class=\"p-1\">" + _0x5b69b3.admin + "</td>\n                            <td class=\"p-1\">" + _0x120db7 + "</td>\n                        </tr>\n                    ");
                });
              }
              if (_0x47f48d.data.playerData) {
                if (_0x47f48d.data.playerData.source) {
                  $("#spectaticeSource").text(_0x47f48d.data.playerData.source);
                }
                if (_0x47f48d.data.playerData.steam) {
                  $("#spectaticeSteam").text(_0x47f48d.data.playerData.steam);
                }
                if (_0x47f48d.data.playerData.steamId) {
                  $("#spectaticeSteamId").text(_0x47f48d.data.playerData.steamId);
                }
                if (_0x47f48d.data.playerData.identifier) {
                  $("#spectaticeIdentifier").text(_0x47f48d.data.playerData.identifier);
                }
                if (_0x47f48d.data.playerData.name) {
                  $("#spectaticeName").text(_0x47f48d.data.playerData.name);
                }
                if (_0x47f48d.data.playerData.job) {
                  $("#spectaticeJob").text(_0x47f48d.data.playerData.job);
                }
                if (_0x47f48d.data.playerData.duty) {
                  $("#spectaticeDuty").text(_0x47f48d.data.playerData.duty);
                }
              }
              if (_0x47f48d.data.liveData) {
                if (_0x47f48d.data.liveData.health) {
                  $("#spectaticeHealth").text(_0x47f48d.data.liveData.health + '/' + _0x47f48d.data.liveData.maxHealth);
                }
                if (_0x47f48d.data.liveData.vest) {
                  $("#spectaticeVest").text(_0x47f48d.data.liveData.vest + "/100");
                }
              }
              if (_0x47f48d.data.vehicleData) {
                $("#spectaticeVehicleData").show();
                $("#spectaticeModel").text(_0x47f48d.data.vehicleData.model);
                $("#spectaticePlate").text(_0x47f48d.data.vehicleData.plate);
                $("#spectaticeVehicleHealth").text(_0x47f48d.data.vehicleData.health);
                $("#spectaticeFuel").text(_0x47f48d.data.vehicleData.fuel);
                $("#spectaticeSpeed").text(_0x47f48d.data.vehicleData.speed);
              } else {
                $("#spectaticeVehicleData").hide();
              }
            } else {
              if (_0x47f48d.action === "stopSpectating") {
                $("#spectating").hide();
              } else {
                if (_0x47f48d.action === "addMessage") {
                  $("#adminAlertMessage").text(_0x47f48d.data.message);
                  $("#adminAlert").fadeIn(200);
                } else if (_0x47f48d.action === "removeMessage") {
                  $("#adminAlert").fadeOut(200);
                }
              }
            }
          }
        }
      }
      $(document).on("focus", "input, textarea", function (_0x5016f2) {
        $.post("https://kk-admin2/nuiFocus", JSON.stringify({
          'val': false
        }));
      });
      $(document).on("focusout", "input, textarea", function (_0x14a21a) {
        $.post("https://kk-admin2/nuiFocus", JSON.stringify({
          'val': true
        }));
      });
    });
  });