$(document).ready(function(){
  $("a[rel^='youtubeSearch']").youtubeSearch();

  // Make pagination ajax
  $('.pagination a').click(handlePaginationClick);

  // BBQ state will be set if some reloads the page via 
  // the back button, which means we need to reload the page
  // they where previously on
  var page = $.bbq.getState( "page" );
  if (page){
    refreshPageWith('/?page=' + page);
  }
});

function handlePaginationClick(e){
  e.preventDefault();
  refreshPageWith($(this).attr("href"));
}

function refreshPageWith(url){
  $.get(url,{},function(response){
    var newSearchResults = $(response).find('#search-results');
    $('#search-results').html(newSearchResults);

    $("a[rel^='youtubeSearch']").youtubeSearch();
    setCustomLinks(); 
    $(".tooltip").simpletooltip(); 
    $('.pagination a').click(handlePaginationClick);

    // Stash the page number in a hash so we can handle the back button
    params = $.deparam.querystring(url)
    $.bbq.pushState({ page: params.page }); 
  })
}
