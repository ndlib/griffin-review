require 'spec_helper'

describe "Semester Admin Integration" do

  before(:all) do
    @admin_role = FactoryBot.create(:admin_role)
    @admin_user = FactoryBot.create(:user)
    @admin_user.roles = [@admin_role]
    @semester_a = FactoryBot.create(:semester)
    @semester_b = FactoryBot.create(:semester)
    @semester_c = FactoryBot.build(:semester)
  end

  describe "Create new semester" do
    it "fills in new semester form and submits" do
      login_as @admin_user
      expect {
        visit new_semester_path
        fill_in 'Code', :with => @semester_c.code
        fill_in 'Full Name', :with => @semester_c.full_name
        fill_in 'Begin Date', :with => Date.today + 2.weeks
        fill_in 'End Date', :with => Date.today + 4.months
        click_button 'Create Semester'
      }.to change(Semester, :count).by(1)
      @last_semester = Semester.last
      current_path.should eq(semester_path(:semester_id => @last_semester.id))
      page.should have_content('End Date')
    end
  end

  describe "Show all semesters" do
    it "gives a tabular list of all semesters in system" do
      login_as @admin_user
      visit all_semester_path
      page.should have_content(@semester_a.code)
    end
  end

end
