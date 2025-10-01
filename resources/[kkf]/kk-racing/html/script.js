var CreatorActive = false;
var RaceActive = false;

$(document).ready(function(){
    window.addEventListener('message', function(event){
        var data = event.data;

        if (data.action == "Update") {
            UpdateUI(data.type, data);
        }
    });
});

function secondsTimeSpanToHMS(s) {
    var h = Math.floor(s/3600); //Get whole hours
    s -= h*3600;
    var m = Math.floor(s/60); //Get remaining minutes
    s -= m*60;
    return h+":"+(m < 10 ? '0'+m : m)+":"+(s < 10 ? '0'+s : s); //zero padding on minutes and seconds
}

function UpdateUI(type, data) {
    if (type == "creator") {
        if (data.active) {
            if (!CreatorActive) {
                CreatorActive = true;
                $("#editor").fadeIn(300);
                $("#editor-racename").html(data.data.RaceName);
                $("#editor-checkpoints").html(data.data.Checkpoints.length + ' / ?');
                $("#editor-keys-tiredistance").html(data.data.TireDistance + '.0');

                if (data.racedata.ClosestCheckpoint !== undefined && data.racedata.ClosestCheckpoint !== 0) {
                    $("#editor-pointId").text(data.racedata.ClosestCheckpoint);
                } else {
                    $("#editor-pointId").text(0);
                }
            } else {
                $("#editor-racename").html(data.data.RaceName);
                $("#editor-checkpoints").html(data.data.Checkpoints.length + ' / ?');
                $("#editor-keys-tiredistance").text(data.data.TireDistance + '.0');

                if (data.racedata.ClosestCheckpoint !== undefined && data.racedata.ClosestCheckpoint !== 0) {
                    $("#editor-pointId").text(data.racedata.ClosestCheckpoint);
                } else {
                    $("#editor-pointId").text(0);
                }
            }
        } else {
            CreatorActive = false;
            $("#editor").fadeOut(300);
        }
    } else if (type == "race") {
        if (data.active) {
            if (!RaceActive) {
                RaceActive = true;
                $("#editor").hide();
                $("#race").fadeIn(300);
                $("#race-racename").html(data.data.RaceName);
                $("#race-checkpoints").html(data.data.CurrentCheckpoint + ' / ' + data.data.TotalCheckpoints);
                if (data.data.TotalLaps == 0) {
                    $("#race-lap").html('Sprint');
                } else {
                    $("#race-lap").html(data.data.CurrentLap + ' / ' + data.data.TotalLaps);
                }
                $("#race-time").html(secondsTimeSpanToHMS(data.data.Time));
                if (data.data.BestLap !== 0) {
                    $("#race-besttime").html(secondsTimeSpanToHMS(data.data.BestLap));
                } else {
                    $("#race-besttime").html('N/A');
                }
                $("#race-totaltime").html(secondsTimeSpanToHMS(data.data.TotalTime));
            } else {
                $("#race-racename").html(data.data.RaceName);
                $("#race-checkpoints").html(data.data.CurrentCheckpoint + ' / ' + data.data.TotalCheckpoints);
                if (data.data.TotalLaps == 0) {
                    $("#race-lap").html('Sprint');
                } else {
                    $("#race-lap").html(data.data.CurrentLap + ' / ' + data.data.TotalLaps);
                }
                $("#race-time").html(secondsTimeSpanToHMS(data.data.Time));
                if (data.data.BestLap !== 0) {
                    $("#race-besttime").html(secondsTimeSpanToHMS(data.data.BestLap));
                } else {
                    $("#race-besttime").html('N/A');
                }
                $("#race-totaltime").html(secondsTimeSpanToHMS(data.data.TotalTime));
            }
        } else {
            RaceActive = false;
            $("#editor").hide();
            $("#race").fadeOut(300);
        }
    }
}