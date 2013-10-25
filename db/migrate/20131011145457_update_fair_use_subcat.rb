class UpdateFairUseSubcat < ActiveRecord::Migration
  def change

    add_column :fair_use_questions, :subcategory, :string

  end
end
