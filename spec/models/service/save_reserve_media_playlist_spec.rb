require 'spec_helper'


describe SaveReserveMediaPlaylist do
  let(:reserve) { Reserve.factory(FactoryGirl.create(:request))}
  let(:media_playlist) { m = MediaPlaylist.new(item_id: reserve.item.id); m.save!; m}

  it "creates a playlist if there is not one" do
    expect(reserve.media_playlist).to be_nil

    SaveReserveMediaPlaylist.call(reserve)
    expect(reserve.media_playlist).to be_a(MediaPlaylist)
  end

  it "updates the existing playlist if there is one" do
    reserve.media_playlist = media_playlist

    SaveReserveMediaPlaylist.call(reserve)
    expect(reserve.media_playlist).to be(media_playlist)
  end

  it "resets the playlist before it updates it" do
    reserve.media_playlist = media_playlist
    expect(media_playlist).to receive(:rows=).with([])

    SaveReserveMediaPlaylist.call(reserve)
  end

  it "adds rows with titles and files" do
    playlist = SaveReserveMediaPlaylist.call(reserve) do | srmp |
      srmp.add_row('title', 'file')
    end
    expect(playlist.rows).to eq([{"title"=>"title", "file"=>"file"}])
  end

end
