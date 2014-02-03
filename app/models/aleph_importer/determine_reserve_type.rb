class AlephImporter::DetermineReserveType


  def initialize(api_data)
    @api_data = api_data
  end


  def determine_type
    format_to_type[format]
  end


  def determine_electronic_reserve(current_reserve)
    if current_reserve.electronic_reserve.nil?
      ['VideoReserve', 'AudioReserve'].include?(determine_type)
    else
      current_reserve.electronic_reserve
    end
  end


  def determine_physical_reserve(reserve)
    if reserve.physical_reserve.nil?
      true
    else
      reserve.physical_reserve
    end
  end


  def format
    @api_data['format'].downcase
  end


  private


    def format_to_type
    {
      'book' => 'BookReserve',
      'bound serial' => 'BookReserve',
      'serial (unbound issue)' => 'BookReserve',
      'dvd (visual)' => 'VideoReserve',
      'video cassette (visual)' => 'VideoReserve',
      'digital form (software, etc.)' => 'VideoReserve',
      'compact disc (sound recording)' => 'AudioReserve',
      'audio (sound recordings)' => 'AudioReserve',
      'score' => 'BookReserve',
      'kit' => 'BookReserve',
      'graphic (2d pict., poster etc)' => 'BookReserve',
    }
  end


end
