module MoviesHelper
  
  def rank_number_class(rank)
    if rank < 10
      'number'
    elsif rank < 100
     'number-2d'
    else
      'number-3d'
    end
  end  

  def rank_ordinal_class(rank)
    if rank < 10
      'ordinal'
    elsif rank < 100
      'ordinal-2d'
    else
      'ordinal-3d'
    end
  end

  def ordinal(rank)
    rank.ordinalize.gsub(/\d/, '')
  end  

  def runtime_span(runtime)
    %Q{<span class="tooltip" title="#{runtime} mins">#{runtime / 60}h #{runtime % 60}m</span>} unless runtime.blank?
  end

  def limit_image_size(params)
    return {} unless params[:width] && params[:height]
    
    width = params[:width]    
    height = params[:height]

    if width > params[:max_width]
      ratio = Float(params[:max_width]) / Float(width)
      width = params[:max_width]
      height = Integer(height * ratio)
    end
    
    if height > params[:max_height]
      ratio = Float(params[:max_height]) / Float(height)
      height = params[:max_height]
      width = Integer(width * ratio)
    end  
    
    return {:width => width, :height => height}
  end  


end  
