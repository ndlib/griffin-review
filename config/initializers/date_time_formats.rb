Date::DATE_FORMATS[:default] = '%m/%d/%Y'
Time::DATE_FORMATS[:default]= '%m/%d/%Y %I:%M%p'

Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") }
