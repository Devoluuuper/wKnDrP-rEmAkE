$(function() {
    KKF = {}

    $(document).keyup(function(event) {
        if ( event.keyCode == 27 ) {
            $.post("https://kk-multicharacter/closeMenu", JSON.stringify({type: 'just'})); $("#main-container").fadeOut(500);
        }
    } );


    function onlyLettersSpacesDots(str) {
        return /^[a-zA-Z\s.,]+$/.test(str);
    }

    KKF.registerCharacter = function() {

        if(onlyLettersSpacesDots($("#firstname").val()) && onlyLettersSpacesDots($("#lastname").val())) {

            $.post("https://kk-core/registerCharacter", JSON.stringify({
                firstname: $("#firstname").val(),
                lastname: $("#lastname").val(),
                dateofbirth: $("#dateofbirth").val(),
                sex: $("input[type='radio'][name='sex']:checked").val()
		    }));

            $.post("https://kk-multicharacter/closeMenu", JSON.stringify({}));
            $("#main-container").fadeOut(500);
            
        } else {

            $.post("https://kk-multicharacter/errorNotif");
            
        }

	}

    window.addEventListener("message", function (event) {
        var event = event.data;
    
        if (event.action === "registerCharacter") {
            $("#main-container").fadeIn(500);
        } else if (event.action === "closeCharacter") {
            $("#main-container").fadeOut(500);
        }
    });  
});