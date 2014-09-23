require 'spec_helper'


describe ParsePlaylistCsv do
  subject { described_class }
  let(:upload_file) { fixture_file_upload("#{Rails.root}/spec/fixtures/mp3tag.csv", 'application/csv') }

  it "takes a mp3tag title and adds it to the playlist" do
    expect(subject.rows(upload_file, 'C032432').first['title']).to eq("Brahms: String Quartet No.1 in C minor, Op.51 No.1: I. Allegro")
  end

  it "takes a mp3tag  file and adds it to the playlist" do
    expect(subject.rows(upload_file, 'C032432').first['filename']).to match("C032432/C01528-11_1.mp3")
  end

  it "puts the directory in the audio" do
    expect(subject.rows(upload_file, 'directory').first['filename']).to match("directory/C01528-11_1.mp3")
  end

  it "does not duplicate the / if the directory has one at the end" do
    expect(subject.rows(upload_file, 'directory/').first['filename']).to match("directory/C01528-11_1.mp3")
  end

  it "converts \ to / " do
    expect(subject.rows(upload_file, 'dir\ectory\\').first['filename']).to match("dir/ectory/C01528-11_1.mp3")
  end
end
