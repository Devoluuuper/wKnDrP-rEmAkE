$(document).ready(function(){
    window.addEventListener("message", function(event){
        $('body').fadeIn(500)
    });

    $(document).on("click", ".spawn-points [data-id]", function(e){
        e.preventDefault();
        $("body").fadeOut(500);
        $.post('https://kk-scripts/locationChoosen', JSON.stringify({id: $(this).data("id")}));
    });

    $(document).on("click", "#lastspawn", function(e){
        e.preventDefault();
        $("body").fadeOut(500);
        $.post('https://kk-scripts/lastLocation', JSON.stringify({}));
    });
});