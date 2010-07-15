require 'open-uri'

class MovieImage < ActiveRecord::Base
  IMAGE_BASE_DIR = "#{Rails.root}/public/images/"
  
  validates_presence_of :file_name, :movie
  belongs_to :movie
  
  def self.download_image(url, movie, format=nil)
    download_location  = self.complete_file_name(movie, url, format)
    logger.info "Downloading image: #{url} to #{download_location}"
    self.get_image(download_location, url)
    width, height = ImageSize.new(File.new(download_location, "r")).get_size
    logger.info "Img (#{width}, #{height}) - #{format}"
    movie.movie_images.create!(:file_name => download_location[IMAGE_BASE_DIR.length..-1],
                               :width => width, :height => height, :format => format.to_s)
  end  
  
  private
    def self.complete_file_name(movie, url, type)
      "#{IMAGE_BASE_DIR}posters/#{movie.id.to_s.rjust(6, '0').insert(-4, '/')}/#{movie.name.downcase.gsub(/\s+/, '_').gsub(/[^\_\w]/, '')}#{type.nil? ? '' : '_' + type.to_s}.#{url.downcase.split('.').last}"
    end  
    
    def self.get_image(download_location, url)
      FileUtils.mkdir_p(File.dirname(download_location))
      open(url, 'rb') do |img|
        File.open(download_location, 'wb') do |file|
          file.write(img.read)
        end
      end      
    end  
end
