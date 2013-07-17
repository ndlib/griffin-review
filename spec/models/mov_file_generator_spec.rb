require 'spec_helper'

describe MovFileGenerator do


  it "generates a file with the correct url embeded in it" do
    semester = double(:semester, :movie_directory => 'movie_dir')
    reserve = mock_reserve FactoryGirl.create(:request, :video), nil
    reserve.stub(:url).and_return('movie.mov')

    mfg = MovFileGenerator.new(reserve)
    mfg.generate_file_text.include?("rtsp://quicktime.nd.edu:80/LTL/movie_dir/movie.mov")
  end


  it " generates a file path for send file " do
    semester = double(:semester, :movie_directory => 'movie_dir')
    reserve = mock_reserve FactoryGirl.create(:request, :video), nil
    reserve.stub(:url).and_return('movie.mov')

    mfg = MovFileGenerator.new(reserve)
    mfg.mov_file_path.should == File.join(Rails.root, "uploads/movs/", "#{reserve.id}", reserve.url)
  end
end
