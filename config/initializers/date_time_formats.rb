Date::DATE_FORMATS[:default] = '%m/%d/%Y'
Time::DATE_FORMATS[:default]= '%m/%d/%Y %I:%M%p'

Date::DATE_FORMATS[:cache_key] = '%m-%d-%Y'
Time::DATE_FORMATS[:cache_key]= '%m-%d-%Y'

Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") }

