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

end  
