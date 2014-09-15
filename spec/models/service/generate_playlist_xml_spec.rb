require 'spec_helper'

describe GeneratePlaylistXml do
  let(:playlist) { double(MediaPlaylist, rows: [ {title: 'title', file: 'file'}, {title: 'category', file: '' } ]) }
  subject { GeneratePlaylistXml }

  it "creates a playlist parent node" do
    xml = Hash.from_xml(subject.call(playlist))
    expect(xml['playlist']).to be_a(Hash)
  end

  it "sets the version on the playlist" do
    xml = Hash.from_xml(subject.call(playlist))
    expect(xml['playlist']['version']).to eq("1")
  end

  it "adds an xmlns" do
    xml = Hash.from_xml(subject.call(playlist))
    expect(xml['playlist']['xmlns']).to eq("http://xspf.org/ns/0/")
  end

  it "creates a tracklist node as a second level node" do
    xml = Hash.from_xml(subject.call(playlist))
    expect(xml['playlist']['tracklist']).to be_a(Hash)
  end

  it "creates tracks in tracklist" do
    xml = Hash.from_xml(subject.call(playlist))
    expect(xml['playlist']['tracklist']['track']).to be_a(Array)
  end

  it "has rows that have a title" do
    xml = Hash.from_xml(subject.call(playlist))
    expect(xml['playlist']['tracklist']['track'].first['title']).to eq('title')
  end

  it "has rows that have a location" do
    xml = Hash.from_xml(subject.call(playlist))
    expect(xml['playlist']['tracklist']['track'].first['location']).to eq('file')
  end

end
