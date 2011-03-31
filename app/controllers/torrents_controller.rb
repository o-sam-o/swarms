class TorrentsController < ApplicationController
  layout 'no_sidebar'

  def index
    @torrents = Torrent.includes(:movie)
    unless params[:search_torrents].blank?
      @torrents = @torrents.where('name like ?', "%#{params[:search_torrents]}%")
    else
      @torrents = @torrents.where(:verified => false)
    end
    @torrents = @torrents.paginate(:page => params[:page], :per_page => 30)

    render 'index'
  end

  def verify
      params[:verify].each do |index, verify_param|
        next unless verify_param[:verified] == '1'
        verify_param[:movie_id] = Movie.find_or_create_by_imdb_id(verify_param[:imdb_id]).id if verify_param[:movie_id].to_i < 1
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
