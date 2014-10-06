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
    out = []
    playlist_rows.each_with_index do |row, line|
      if line == 0 || match_extra_row?(row)
        next
      end

      out << translate_row(row);
    end

    out
  end

  private

    def match_extra_row?(row)
      row.match(/build on .* with Mp3tag v2.50 - the universal Tag editor - http:\/\/www.mp3tag.de\/en\//)
    end

    def playlist_rows
      File.open(file.path, 'r', encoding: 'bom|utf-8').each_line
    end

    def translate_row(row)
      row = row.split(';')
      {
        'title' => row[0],
        'filename' =>  "#{parsed_directory(row)}/#{filename_from_row(row)}"
      }
    end

    def filename_from_row(row)
      row[row.size - 2]
    end

    def parsed_directory(row)
      filename_from_row(row).match(/^([0-9a-zA-Z]*)([-]|[_])/).captures.first
    end

end
