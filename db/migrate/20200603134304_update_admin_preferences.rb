class UpdateAdminPreferences < ActiveRecord::Migration
  def up
    libs_to_remove = ["math", "chem", "engineering"]
    User.find_each do |user|
      if user.admin_preferences.any?
        if user.admin_preferences["libraries"].any?{|x| libs_to_remove.include?(x)}
          p user.id.to_s + " " + user.first_name + " " + user.last_name
          p user.admin_preferences["libraries"]
          user.admin_preferences["libraries"] = user.admin_preferences["libraries"] - libs_to_remove
          p user.admin_preferences["libraries"]
          user.save!
        end
      end
    end
  end

  def down
  end
end
