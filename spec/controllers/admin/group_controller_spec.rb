require 'spec_helper'

describe Admin::GroupController do
  describe "GET index" do
    it "creates new group and assigns all groups to @groups" do
      group = Factory.create(:group)
      get :index
      assigns(:groups).should include(group)
      group.destroy
    end
  end

end
