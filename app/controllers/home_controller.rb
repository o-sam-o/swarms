class HomeController < ApplicationController
  
  def index
    if params[:q].present?
      @movies = Movie.where('name like ?', "%#{params[:q]}%")
      if @movies.size == 1
        redirect_to(movie_path(@movies.first)) && return
      end
    else
      @movies = Movie.where('current_rank != 0')
    end 

    unless params[:genre].blank?
       @movies = @movies.joins(:genres).where('genres.name' => params[:genre])
    end

    @movies = @movies.order('current_rank').includes(:movie_images)
                     .paginate(:page => params[:page], :per_page => 15)

    @recent_additions = Movie.where('current_rank != 0').order('created_at DESC').limit(5)
  end

end
