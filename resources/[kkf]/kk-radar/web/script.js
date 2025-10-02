var radarEnabled = false; 
var targets = []; 

$( function() {
    radarInit();

    var radarContainer = $('#radarContainer');

    var fwdArrowFront =  $('#fwd_arrow_front');
    var fwdArrowBack =  $('#fwd_arrow_back');
    var bwdArrowFront =  $('#bwd_arrow_front');
    var bwdArrowBack =  $('#bwd_arrow_back');

    var fwdSame = $('#fwd_same');
    var fwdOpp = $('#fwd_opp');
    var fwdXmit = $('#fwd_xmit');

    var bwdSame = $('#bwd_same');
    var bwdOpp = $('#bwd_opp');
    var bwdXmit = $('#bwd_xmit');

    var radarRCContainer = $('#controllerContainer');

    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);

        if (keycode == '27') {
            sendData('RadarRC', 'close' ); 
        }
    });

    window.addEventListener('message', function( event ) {
        var item = event.data;

        if (item.hideAll) {
            $('body').hide()
        }

        if (item.showAll) {
            $('body').show()
        }

        if ( item.toggleradar ) {
            radarEnabled = !radarEnabled; 
            radarContainer.fadeToggle();
        }

        if (item.disableRadar) {
            radarEnabled = false;
            radarContainer.fadeOut();
        }

        if ( item.hideradar ) {
            radarContainer.fadeOut();
        } else if ( item.hideradar == false ) {
            radarContainer.fadeIn();
        }

        if ( item.frontchange ) {
            $("#plate_front").text(item.plate);
        }

        if ( item.rearchange ) {
            $("#plate_back").text(item.plate);
        }

        if ( item.patrolspeed ) {
            updateSpeed('patrolspeed', item.patrolspeed ); 
        }

        if ( item.fwdspeed ) {
            updateSpeed('fwdspeed', item.fwdspeed ); 
        }

        if ( item.fwdfast ) {
            updateSpeed('fwdfast', item.fwdfast ); 
        }

        if ( item.lockfwdfast == true || item.lockfwdfast == false ) {
            lockSpeed('fwdfast', item.lockfwdfast )
        }

        if ( item.bwdspeed ) {
            updateSpeed('bwdspeed', item.bwdspeed );  
        }

        if ( item.bwdfast ) {
            updateSpeed('bwdfast', item.bwdfast );    
        }

        if ( item.lockbwdfast == true || item.lockbwdfast == false ) {
            lockSpeed('bwdfast', item.lockbwdfast )
        }

        if ( item.manuallock ) {
            if (item.status) {
                $('#fwd_lock').removeClass('text-zinc-500').addClass('text-red-600');
                $('#bwd_lock').removeClass('text-zinc-500').addClass('text-red-600');
            } else {
                $('#fwd_lock').removeClass('text-red-600').addClass('text-zinc-500');
                $('#bwd_lock').removeClass('text-red-600').addClass('text-zinc-500');
            }
        }

        if ( item.fwddir || item.fwddir == false ) {
            updateArrowDir( fwdArrowFront, fwdArrowBack, item.fwddir )
        }

        if ( item.bwddir || item.bwddir == false  ) {
            updateArrowDir( bwdArrowFront, bwdArrowBack, item.bwddir )
        }

        if ( item.fwdxmit ) {
            fwdXmit.removeClass('text-yellow-600').addClass('text-yellow-400');;
        } else if ( item.fwdxmit == false ) {
            fwdXmit.removeClass('text-yellow-400').addClass('text-yellow-600'); 
        }

        if ( item.bwdxmit ) {
            bwdXmit.removeClass('text-yellow-600').addClass('text-yellow-400');
        } else if ( item.bwdxmit == false ) {
            bwdXmit.removeClass('text-yellow-400').addClass('text-yellow-600');    
        }

        if ( item.fwdmode ) {
            modeSwitch( fwdSame, fwdOpp, item.fwdmode );
        }

        if ( item.bwdmode ) {
            modeSwitch( bwdSame, bwdOpp, item.bwdmode );
        }

        if ( item.toggleradarrc ) {
            radarRCContainer.fadeToggle();
        }

        if ( item.fastLimit ) {
            $('#fastLimit').val(item.fastLimit);
        }
    });

    $('#fastLimit').on('input', function(e){
        sendData('setFastLimit', $('#fastLimit').val() ); 
    });
})

function radarInit() {
    $('.itemContainer').each( function( i, obj ) {
        $( this ).find('[data-target]').each( function( subi, subobj ) {
            targets[ $( this ).attr('data-target') ] = $( this )
        } )
     } );

    $('#controllerContainer').find('button').each( function( i, obj ) {
        if ( $( this ).attr('data-action') ) {
            $( this ).click( function() { 
                var data = $( this ).data('action'); 

                sendData('RadarRC', data ); 
            } )
        }
    } );
}

function updateSpeed( attr, data ) {
    targets[ attr ].find('.speedNumber').each( function( i, obj ) {
        $( obj ).text( data[i] ); 
    } ); 
}

function lockSpeed( attr, state ) {
    if (attr == 'fwdfast') {
        if (state) {
            $('#fwd_lock_fast').removeClass('text-zinc-500').addClass('text-red-600');
        } else {
            $('#fwd_lock_fast').removeClass('text-red-600').addClass('text-zinc-500');
        }
    } else if (attr == 'bwdfast') {
        if (state) {
            $('#bwd_lock_fast').removeClass('text-zinc-500').addClass('text-red-600');
        } else {
            $('#bwd_lock_fast').removeClass('text-red-600').addClass('text-zinc-500');
        }
    }
}

function modeSwitch( sameEle, oppEle, state ) {
    if ( state == "same" ) {
        sameEle.removeClass('text-yellow-600').addClass('text-yellow-400');
        oppEle.removeClass('text-yellow-400').addClass('text-yellow-600');
    } else if ( state == "opp" ) {
        oppEle.removeClass('text-yellow-600').addClass('text-yellow-400');
        sameEle.removeClass('text-yellow-400').addClass('text-yellow-600');
    } else if ( state == "none" ) {
        oppEle.removeClass('text-yellow-400').addClass('text-yellow-600');
        sameEle.removeClass('text-yellow-400').addClass('text-yellow-600');
    }
}

function updateArrowDir( fwdEle, bwdEle, state ) {
    if ( state == true ) {
        fwdEle.removeClass('text-zinc-700').addClass('text-red-500');
        bwdEle.removeClass('text-red-500').addClass('text-zinc-700');
    } else if ( state == false ) {
        bwdEle.removeClass('text-zinc-700').addClass('text-red-500');
        fwdEle.removeClass('text-red-500').addClass('text-zinc-700'); 
    } else if ( state == null ) {
        fwdEle.removeClass('text-red-500').addClass('text-zinc-700'); 
        bwdEle.removeClass('text-red-500').addClass('text-zinc-700');
    }
}

function sendData( name, data ) {
    $.post('https://kk-radar/'+ name, JSON.stringify( data ), function( datab ) {
        if ( datab !='ok') {
            console.log( datab );
        }            
    } );
}