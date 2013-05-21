require 'spec_helper'
require 'cancan/matchers'

describe User do

  context "with admin abilities" do

    before(:all) do
      @admin_role = Factory.build(:admin_role)
      @admin_user = Factory.build(:user, :roles => [@admin_role])
    end

    subject { ability }
    let(:ability){ Ability.new(@admin_user) }

    it "should be able to manage groups" do
      should be_able_to(:manage, Group.new)
    end

    it "should be able to manage roles" do
      should be_able_to(:manage, Role.new)
    end

    it "should be able to manage items" do
      should be_able_to(:manage, OpenItem.new)
    end

    it "should be able to manage requests" do
      should be_able_to(:manage, Request.new)
    end

  end

end
