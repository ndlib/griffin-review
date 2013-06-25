require 'spec_helper'

describe MovFileGenerator do


  it "generates a file with the correct url embeded in it" do
    semester = mock(:semester, :movie_directory => 'movie_dir')
    reserve = mock_reserve FactoryGirl.create(:request, :video), nil
    reserve.stub(:url).and_return('movie.mov')

    mfg = MovFileGenerator.new(reserve)
    mfg.generate_file_text.include?("rtsp://quicktime.nd.edu:80/LTL/movie_dir/movie.mov")
  end
end
