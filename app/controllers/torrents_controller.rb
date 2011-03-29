class TorrentsController < ApplicationController
  
  def index
    @torrents = Torrent.includes(:movie).where(:verified => false)
    @torrents = @torrents.paginate(:page => params[:page], :per_page => 30)

    render 'index'
  end

  def verify
      params[:verify].each do |verify_param|
        next unless verify_param[:verified] == '1'
        Torrent.find(verify_param[:torrent_id]).update_attributes!(:movie_id => verify_param[:movie_id], 
                                                                   :verified => true)
      end
      redirect_to(:action => :index)
  end

  def find_movie
    render :json => 
      YayImdbs.search_imdb(params[:new_movie_title]).collect { |movie_info|
        movie_info.merge(:movie_id => (Movie.find_by_imdb_id(movie_info[:imdb_id]).id rescue nil))
      }
  end
end
