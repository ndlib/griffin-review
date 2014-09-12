# sanitizes semester dates in preparation for create/update
# activities against the semester active record objects
class SemesterDateNormalizer
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Callbacks

  attr_reader :begin_date_string, :end_date_string
  
  validates :begin_date_string, :end_date_string, presence: true
  validates :begin_date_string, :end_date_string, format: { with: /\d{8}/,
                                              message: 'eight digits required for valid date' }

  def initialize(begin_date:, end_date:)
    @begin_date_string = begin_date
    @end_date_string = end_date
  end

  def begin_date
    Date.parse(begin_date_string)
  end

  def end_date
    Date.parse(end_date_string)
  end

  def derive_begin_date(prior_end_date)
    prev_date = Date.parse(prior_end_date)
    @begin_date_string = prev_date.next_day.strftime('%Y%m%d')
  end

  def derive_code
    if determine_term == '20'
      begin_date.prev_year.year.to_s + determine_term
    else
      begin_date.year.to_s + determine_term
    end
  end

  def derive_semester_name
    determine_season + ' ' + begin_date.year.to_s
  end

  private

  def determine_term
    if compare_month?('begin', '==', 8) && compare_month?('end', '==', 12)
      '10'
    elsif compare_month?('begin', '>=', 5) && compare_month?('end', '==', 8)
      '00'
    elsif compare_month?('begin', '==', 1) && compare_month?('end', '<=', 5)
      '20'
    end
  end

  def compare_month?(type, op, value)
    eval("#{type}_date.mon #{op} #{value}")
  end

  def determine_season
    case determine_term
    when '00'
      'Summer'
    when '10'
      'Fall'
    when '20'
      'Spring'
    end
  end

end
