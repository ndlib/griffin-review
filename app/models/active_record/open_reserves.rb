class OpenReserves < ActiveRecord::Base
  self.abstract_class = true
  case Rails.env
  when "production"
    establish_connection configurations['open_reserves_prod']
  when "pre_production"
    # establish_connection configurations['open_reserves_pprd']
    establish_connection configurations['open_reserves_prod']

  when "development"
    #establish_connection configurations['open_reserves_development']
    establish_connection configurations['open_reserves_prod']

  else
    establish_connection configurations['open_reserves_test']
  end
end
