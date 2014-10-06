require 'spec_helper'


describe ParsePlaylistCsv do
  subject { described_class }
  let(:upload_file) { fixture_file_upload("#{Rails.root}/spec/fixtures/mp3tag.csv", 'application/csv') }

  it "takes a mp3tag title and adds it to the playlist" do
    expect(subject.rows(upload_file).first['title']).to eq("Brahms: String Quartet No.1 in C minor, Op.51 No.1: I. Allegro")
  end

  it "takes a mp3tag  file with a dash and adds it to the playlist" do
    expect(subject.rows(upload_file).first['filename']).to match("C01528/C01528-11_1.mp3")
  end

  it "takes a mp3tag  file with a underscore and adds it to the playlist" do
    expect(subject.rows(upload_file)[1]['filename']).to match("C04189/C04189_2.mp3")
  end

end
