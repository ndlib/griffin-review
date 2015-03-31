
class SakaiContextId
  attr_reader :context_id, :term, :course_number

  def initialize(context_id)
    @context_id = context_id
    parse
  end

  private

  def parse
    parts = context_id.split('-')
    @course_number = "#{parts[1]} #{parts[2]}".upcase

    term_array = /^(\w{2})(\d{2})/.match(parts[0]).captures
    @term = calculate_term(term_array)
  end

  def calculate_term(parts_array)
    year_value = calculate_year(parts_array)
    term = year_value + term_alpha_to_num(parts_array[0])
    return term
  end

  def calculate_year(parts_array)
    year_value = 2000 + parts_array[1].to_i
    year_value = year_value - 1 if parts_array[0] == 'SP'
    return year_value.to_s
  end

  def term_alpha_to_num(alpha)
    case alpha
    when 'SU'
      '00'
    when 'FA'
      '10'
    when 'SP'
      '20'
    end
  end
end
