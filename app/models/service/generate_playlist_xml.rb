class GeneratePlaylistXml
  attr_reader :playlist

  def self.call(playlist)
    new(playlist).generate
  end

  def initialize(playlist)
    @playlist = playlist
  end

  def generate
    generated_xml
  end

  private

    def generated_xml
      builder = Nokogiri::XML::Builder.new(encoding: 'utf-8') do | xml |
        xml.playlist(version: '1', xmlns: "http://xspf.org/ns/0/") {
          xml.tracklist {
            playlist.rows.each do | row |
              xml.track {
                xml.title(row[:title])
                xml.location(row[:file])
              }
            end
          }
        }
      end

      builder.to_xml
    end
end
