$(document).ready(function(){
  bindEventHandlers() 

  // BBQ state will be set if some reloads the page via 
  // the back button, which means we need to reload the page
  // they where previously on
  var page = $.bbq.getState( "page" );
  if (page){
    // TODO disable animation for this
    refreshPageWith('/?page=' + page);
  }
});

function getRowClass(element){
  var tileClasses = $(element).attr('class').split(' ');
  return $.grep(tileClasses, function(n, i){
    return tileClasses[i].match(/movie-tile-row-\d+/)
  })[0];
}

function handlePaginationClick(e){
  e.preventDefault();
  refreshPageWith($(this).attr("href"));
}

function refreshPageWith(url){
  // TODO add some kind of loading graphic
  $.get(url,{},function(response){
    //Animate pagination
    $('.movie_tiles').quicksand($(response).find('.movie_tiles li'), {}, function(){
      bindEventHandlers();
    });

    //Update paginator
    $('.movies_paginator').html($(response).find('.movies_paginator'));

    // Stash the page number in a hash so we can handle the back button
    params = $.deparam.querystring(url)
    $.bbq.pushState({ page: params.page }); 
  })
}

function bindEventHandlers() {
  $("a[rel^='youtubeSearch']").youtubeSearch();
  setCustomLinks(); 
  $(".tooltip").simpletooltip(); 

  $('.movie-tile').hover(function(){
    $('.' + getRowClass(this)).addClass('movie-tile-row-mouseover')
  }, function(){
    $('.' + getRowClass(this)).removeClass('movie-tile-row-mouseover')
  });

  $('.pagination a').click(handlePaginationClick);
}
