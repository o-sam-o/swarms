class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  before_filter :load_layout_vars

private

  def load_layout_vars
    @genres = Genre.order(:name)
  end  

end
