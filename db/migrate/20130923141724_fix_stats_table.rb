class FixStatsTable < ActiveRecord::Migration
  def change

    add_column :reserve_stats, :created_at, :datetime
    add_column :reserve_stats, :from_lms, :boolean

  end
end
