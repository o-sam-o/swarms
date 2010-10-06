$(document).ready(function(){
  $("a[rel^='youtubeSearch']").youtubeSearch();
  $("a[rel^='prettyPhoto']").prettyPhoto({theme:'light_rounded'});

  $(".navigation a").click(pageTorrents);

  $("#graph-tabs").tabs();
});

function pageTorrents(e){
  e.preventDefault();
  $.get($(this).attr("href"),{},function(response){
    $("#all-torrents").html($(response).find('#all-torrents').html());
    $(".navigation a").click(pageTorrents);
  });
}
