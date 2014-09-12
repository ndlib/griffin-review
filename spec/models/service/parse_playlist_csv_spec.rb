require 'spec_helper'


describe ParsePlaylistCsv do
  subject { described_class }
  let(:upload_file) { fixture_file_upload("#{Rails.root}/spec/fixtures/mp3tag.csv", 'application/csv') }

  it "takes a mp3tag title and adds it to the playlist" do
    expect(subject.rows(upload_file).first['title']).to eq("Brahms: String Quartet No.1 in C minor, Op.51 No.1: I. Allegro")
  end

  it "takes a mp3tag  file and adds it to the playlist" do
    expect(subject.rows(upload_file).first['filename']).to match("C01528-11_1.mp3")
  end

  it "uses parse_directory" do
    expect_any_instance_of(subject).to receive(:parse_directory).at_least(:once).and_return("")
    subject.rows(upload_file)
  end

  it "converts the \ in the path to a / " do
    csv = subject.new(upload_file)
    expect(csv.send(:parse_directory, 'asdf\asdf')).to eq('asdf/asdf')
  end

  it "removes the path  " do
    csv = subject.new(upload_file)
    expect(csv.send(:parse_directory, 'L:/Departmental/Digital Library Services/Private/StreamingAudio/')).to eq('')
  end


end
