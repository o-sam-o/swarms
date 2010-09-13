class HomeController < ApplicationController
  
  def index
    @movies = Movie.where('current_rank != 0')
                   .order('current_rank')
                   .paginate(:page => params[:page], :per_page => 15)

    @recent_additions = Movie.where('current_rank != 0').order('created_at DESC').limit(5)
  end

end
