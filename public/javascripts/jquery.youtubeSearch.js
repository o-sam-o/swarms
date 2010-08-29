jQuery.fn.youtubeSearch = function() {
  return this.each(function(){
    var searchElement = $(this);
    $.ajax({url: "http://gdata.youtube.com/feeds/api/videos?q=" + escape(searchElement.attr('searchTerm')) +"&v=2&alt=jsonc&format=5", 
      success: function(data){
        searchElement.attr("href", data.data.items[0].player['default']);
        searchElement.prettyPhoto({theme:'light_rounded'});
    }});
  });
};

