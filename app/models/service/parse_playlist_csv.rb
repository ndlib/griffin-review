require 'csv'

class ParsePlaylistCsv
  attr_reader :file

  def self.rows(file)
    new(file).rows
  end

  def initialize(file)
    @file = file
  end

  def rows
    playlist_rows.collect { | row | translate_row(row) }
  end

  private

    def playlist_rows
      CSV.foreach(file, { col_sep: ';', headers: :first_row } )
    end

    def translate_row(row)
      {
        'title' => row[0],
        'filename' => parse_directory(row[8]) + row[9]
      }
    end

    def parse_directory(directory)
      directory.gsub(/\\/,'/').gsub('L:/Departmental/Digital Library Services/Private/StreamingAudio/', '')
    end
end
