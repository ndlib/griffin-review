class MovFileGenerator


  def initialize(reserve)
    @reserve = reserve
  end


  def generate_file_text
    sample_text.gsub('{urlgoeshere}', full_url)
  end


  private

    def sample_text
      File.read(sample_file).encode!('UTF-8', 'UTF-8', :invalid => :replace)
    end


    def full_url
      "quicktime.nd.edu:80/LTL/#{@reserve.semester.movie_directory}/#{@reserve.url}"
    end


    def sample_file
      File.join(Rails.root, 'uploads/movs', 'sample.mov')
    end
end
