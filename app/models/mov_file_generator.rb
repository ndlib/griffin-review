class MovFileGenerator


  def initialize(reserve)
    @reserve = reserve
  end


  def mov_file_path
    save_file

    file_path
  end


  def generate_file_text
    @text ||= sample_text + full_url
  end


  def save_file
    f = File.open(file_path, 'wb')
    f.write(generate_file_text)
    f.close
  end


  def file_path
    path = File.join(Rails.root, "uploads/movs/", "#{@reserve.id}")
    FileUtils.mkdir_p(path)

    File.join(path, @reserve.url)
  end


  private

    def sample_text
      f = File.open(sample_file, 'rb')
      txt = f.read
      f.close

      txt
    end


    def full_url
      "quicktime.nd.edu:80/LTL/#{@reserve.semester.movie_directory}/#{@reserve.url}"
    end


    def sample_file
      File.join(Rails.root, 'uploads/movs', 'sample.mov')
    end
end
