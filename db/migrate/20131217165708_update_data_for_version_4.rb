class UpdateDataForVersion4 < ActiveRecord::Migration
  def change
    FixElectronicReserves.new.fix!
    FixBookChapters.new.fix!
  end
end
