$(document).ready(function(){
  bindEventHandlers() 

  // BBQ state will be set if some reloads the page via 
  // the back button, which means we need to reload the page
  // they where previously on
  var page = $.bbq.getState( "page" );
  if (page && page != getCurrentPageNumber()){
    refreshPageWith('/?page=' + page, {'hideInitalPage' : true});
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

function refreshPageWith(url, params){
  if(params && params.hideInitalPage){
    $("#movie-tiles-reel").css('left', '-600px');
    $('#movie-tiles-container').append('<div class="loading-search-results"> Loading ... </div>');
  }

  // TODO add some kind of loading graphic
  $.get(url,{},function(response){
    $('.loading-search-results').remove();
   
    var currentPage = getCurrentPageNumber();
    var newPage =  getSearchResultsPageNumber($(response).find('.movie_tiles'));

    var transitionPosition = '-600px';
    if (newPage > currentPage){
      $('#movie-tiles-reel').append($(response).find('.movie_tiles'))
    }else{
      $("#movie-tiles-reel").css('left', '-600px');
      transitionPosition = '0';
      $('#movie-tiles-reel').prepend($(response).find('.movie_tiles'))
    }

    //Animate pagination
    $("#movie-tiles-reel").animate({
        left: transitionPosition
    }, 1500, 'easeInExpo', function() {
      $('#movie-tiles-for-' + currentPage).remove();
      $("#movie-tiles-reel").css('left', 0);
    });

    //Update paginator
    $('.movies_paginator').html($(response).find('.movies_paginator'));

    bindEventHandlers();

    // Stash the page number in a hash so we can handle the back button
    params = $.deparam.querystring(url)
    $.bbq.pushState({ page: params.page }); 
  })
}

function getSearchResultsPageNumber(movieTiles){
  return parseInt(movieTiles.attr('id').replace(/[^\d]/g, ''))
}

function getCurrentPageNumber(){
  return getSearchResultsPageNumber($('.movie_tiles'));
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
