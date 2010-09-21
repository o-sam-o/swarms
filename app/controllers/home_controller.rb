class HomeController < ApplicationController
  
  def index
    @movies = Movie.where('current_rank != 0')
                   .order('current_rank')
                   .includes(:movie_images)

    unless params[:genre].blank?
       @movies = @movies.joins(:genres).where('genres.name' => params[:genre])
    end

    @movies = @movies.paginate(:page => params[:page], :per_page => 15)

    @recent_additions = Movie.where('current_rank != 0').order('created_at DESC').limit(5)
  end

end
