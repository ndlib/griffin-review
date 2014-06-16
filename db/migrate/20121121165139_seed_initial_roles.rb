class SeedInitialRoles < ActiveRecord::Migration
  class Role < ActiveRecord::Base
  end

  def up
    Role.where(:name => 'Administrator').first_or_create(:description => 'This role allows the user to create and update most objects in the system.')
    Role.where(:name => 'Reserves Technician').first_or_create(:description => 'The reserves technician can add and update courses, items, and student permissions.')
    Role.where(:name => 'Media Admin').first_or_create(:description => 'A person responsible for the digitization of multimedia materials that are incorporated into the reserves system.')
    Role.where(:name => 'Faculty').first_or_create(:description => 'The reserves technician can add and update courses, items, and student permissions.')
    Role.where(:name => 'Graduate Student').first_or_create(:description => 'A student who is enrolled in a graduate course of studies at the University.')
    Role.where(:name => 'Staff').first_or_create(:description => 'Full or part time staff of the university.')
  end

  def down
    Role.where(:name => 'Administrator').destroy
    Role.where(:name => 'Reserves Technician').destroy
    Role.where(:name => 'Media Admin').destroy
    Role.where(:name => 'Faculty').destroy
    Role.where(:name => 'Graduate Student').destroy
    Role.where(:name => 'Staff').destroy
  end
end
