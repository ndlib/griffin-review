class UpdateJournalTitleLength < ActiveRecord::Migration
  def change

    change_column :items, :journal_title, :text
  end
end
