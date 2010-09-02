$(function() {
  function updateTips(t) {
    var tips = $('#download-dialog-form .validate-tips');

    tips.text(t).addClass('ui-state-highlight');
      
    setTimeout(function() {
      tips.removeClass('ui-state-highlight', 1500);
    }, 500);
  }

  function checkPresents(o,n) {
    if ( o.val().length < 1 ) {
      o.addClass('ui-state-error');
      updateTips("You must provide a " + n + ".");
      return false;
    } else {
      return true;
    }
  }

  function setCustomLinks(customLink){
    $('.download-link').each(function(){
        var link = $(this);
        link.attr("href", customLink.replace('%TITLE%', escape(link.attr('movieTitle'))));
        link.attr('target', '_blank');
    });
  }

  $("#download-dialog-form").dialog({
    autoOpen: false,
    height: 350,
    width: 320,
    modal: true,
    buttons: {
      Save: function() {
        $('#download-dialog-form input').removeClass('ui-state-error');

        if (checkPresents($("#url"), "url")) {
        $.cookie('custom_download_link', $("#url").val(), { path: '/', expires: 1000});
          setCustomLinks($("#url").val());
          //Dialog no longer needed
          $('.download-link').unbind('click');
          $(this).dialog('close');
        }
      },
      Cancel: function() {
        $(this).dialog('close');
      }
    },
    close: function() {
      updateTips('');
      $('#download-dialog-form input').removeClass('ui-state-error');
    }
  });
  
  //Setup what action a custom link performs when clicked	
  if ($.cookie('custom_download_link')){
    setCustomLinks($.cookie('custom_download_link'));   
  }else {
    $('.download-link').click(function(){
      $('#download-dialog-form').dialog('open');
      return false;
    });
  }

  $('#download-dialog-form .link-example')
    .click(function() {
      $('#url').val(this.innerHTML);
      return false;
  });

});

