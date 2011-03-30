$(document).ready(function(){
  //Make clicking row check verified checkbox
  $('#verify-torrents-table td:nth-child(2), td:nth-child(3)').click(function(){
    var $checkbox = $(this).parent().find('input[type=checkbox]');
    $checkbox.attr('checked', !$checkbox.attr('disabled') && !$checkbox.attr('checked'));
  });

  //Add select all helper
  $('#select-all-checkboxes').click(function(){
    $('input[type=checkbox]:not(:disabled)').attr('checked', true);
  });

  //Create dialog for changing movie to torrent match
  $("#change-movie-dialog").dialog({
    autoOpen: false,
    height: 350,
    width: 650,
    modal: true,
    buttons: {
      Search: function() {
        //TODO handle blank
        searchForMovies($('#new_movie_title').val());
      },
      Cancel: function() {
        $(this).dialog('close');
      }
    }
  });

  //Make change button show dialog
  $('.change-movie').click(function(){
    $('#new_movie_title').val($(this).attr('data-movie-name'));
    $('#new_movie_title').attr('data-torrent-id', $(this).attr('data-torrent-id'));
    $('#change-movie-table').hide();
    $('#change-movie-dialog').dialog('open'); 
  });

});

function searchForMovies(movieName){
  $('#change-movie-table').hide();
  $('#change-movie-loading-indicator').show();
  $.ajax({
    url: "torrents/find_movie",
    data: "new_movie_title=" + movieName,
    success: function(data){
      var resultTable = $('<tbody></tbody>');
      $.each(data, function(index, movieResult) { 
        var resultRow = $('<tr></tr>');
        resultRow.append('<td><a href="http://www.imdb.com/title/tt' + movieResult.imdb_id + '" target="_blank">' + movieResult.name + '</a></td>');
          resultRow.append('<td>' + movieResult.year + '</td>');
        if (movieResult.movie_id) {
          resultRow.append('<td><a href="/movies/' + movieResult.movie_id + '/id" target="_blank">View</a></td>');
        }else{
          resultRow.append('<td></td>');
        }

        var useLink = $('<a href="#">Use</a>');
        if (movieResult.movie_id) {
          useLink.attr('data-movie-id', movieResult.movie_id);
        }
        useLink.attr('data-imdb-id', movieResult.imdb_id);
        useLink.attr('data-movie-name', movieResult.name + ' (' + movieResult.year + ')');
        useLink.click(updateTorrentMovie);
        resultRow.append($('<td></td>').append(useLink));

        resultTable.append(resultRow);
      });
      $('#change-movie-table tbody').replaceWith(resultTable);
      $('#change-movie-table').show();
      $('#change-movie-loading-indicator').hide();
    }
  });
}

function updateTorrentMovie(e){
  e.preventDefault();

  var torrentId = $('#new_movie_title').attr('data-torrent-id');
  var movieId = $(this).attr('data-movie-id');
  var imdbId = $(this).attr('data-imdb-id');
  var movieName = $(this).attr('data-movie-name');

  $('#imdb_id_for_' + torrentId).val(imdbId);

  if (movieId){
    $('#movie_id_for_' + torrentId).val(movieId);
    $('#link_to_movie_for_' + torrentId).html('<a href="/movies/' + movieId + '/id" target="_blank">' + movieName + '</a>'); 
  }else{
    $('#movie_id_for_' + torrentId).val(0);
    $('#link_to_movie_for_' + torrentId).html('<a href="http://www.imdb.com/title/tt' + imdbId + '" target="_blank">' + movieName + '</a>'); 
  }

  $('#verify_torrent_' + torrentId).attr('checked', true);
  $('#verify_torrent_' + torrentId).attr('disabled', false);

  $('#change-movie-dialog').dialog('close'); 
}
