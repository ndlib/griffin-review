class MovFileGenerator

  FILE_REPLACEMENT_PATTERN = '{replaceurl}'

  def initialize(reserve)
    @reserve = reserve
  end


  def mov_file_path
    save_file

    file_path
  end


  def generate_file_text
    url = full_url #.encode('ASCII-8BIT')
    sample_text.gsub('{replaceurl}', url)
  end


  def save_file
    f = File.open(file_path, 'w')

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
      f = File.open(sample_file, 'r')

      txt = f.read
      f.close

      txt
    end


    def full_url
      "129.74.250.126:80/LTL/#{@reserve.semester.movie_directory}/#{@reserve.url}"
    end


    def sample_file
      File.join(Rails.root, 'uploads', 'sample.mov')
    end
end
