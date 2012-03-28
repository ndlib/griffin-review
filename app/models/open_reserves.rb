class OpenReserves < ActiveRecord::Base
  case Rails.env
  when "production"
    establish_connection configurations['open_reserves_prod']
  when "pre_production"
    establish_connection configurations['open_reserves_pprd']
  when "development"
    establish_connection configurations['open_reserves_development']
  else
    establish_connection configurations['open_reserves_test']
  end
end
