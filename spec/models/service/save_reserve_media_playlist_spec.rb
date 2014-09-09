require 'spec_helper'


describe SaveReserveMediaPlaylist do
  let(:reserve) { Reserve.factory(FactoryGirl.create(:request))}
  let(:media_playlist) { m = MediaPlaylist.new(item_id: reserve.item.id, type: 'audio', rows: [{}]); m.save!; m}

  it "creates a playlist if there is not one" do
    expect(reserve.media_playlist).to be_nil

    SaveReserveMediaPlaylist.call(reserve, 'audio') do |srmp|
      srmp.add_row('title', 'file')
    end

    expect(reserve.media_playlist).to be_a(MediaPlaylist)
  end

  it "replaces the existing playlist if there is one" do
    reserve.media_playlist = media_playlist

    SaveReserveMediaPlaylist.call(reserve, 'audio') do |srmp|
      srmp.add_row('title', 'file')
    end

    expect(reserve.media_playlist.id).to_not eq(media_playlist.id)
  end

  it "does not save a new record if there is no rows" do
    expect(SaveReserveMediaPlaylist.call(reserve, 'audio')).to be_false
    expect(reserve.media_playlist).to be_nil
  end

  it "adds rows with titles and files" do
    playlist = SaveReserveMediaPlaylist.call(reserve, 'audio') do | srmp |
      srmp.add_row('title', 'file')
    end
    expect(playlist.rows).to eq([{"title"=>"title", "file"=>"file"}])
  end

end
