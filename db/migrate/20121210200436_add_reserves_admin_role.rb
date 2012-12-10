class AddReservesAdminRole < ActiveRecord::Migration
  def up
    Role.where(:name => 'Reserves Admin').first_or_create(:description => 'This role allows the user to administer almost all aspects of the reserves system.')
  end

  def down
    Role.where(:name => 'Reserves Admin').destroy
  end
end
