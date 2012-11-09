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

  context "with reserves admin privileges" do

    before(:all) do
      @reserves_admin_role = Factory.build(:reserves_admin_role)
      @reserves_admin = Factory.build(:user, :roles => [@reserves_admin_role])
    end

    subject { ability }
    let(:ability){ Ability.new(@reserves_admin) }

    it "should be able to view user accounts" do
      should be_able_to(:read, User.new)
    end

  end

  context "with media admin privileges" do

    before(:all) do
      @media_admin_role = Factory.build(:media_admin_role)
      @media_admin = Factory.build(:user, :roles => [@media_admin_role])
    end

    subject { ability }
    let(:ability){ Ability.new(@media_admin) }

    it "should be able to manage the video workflow" do
      should be_able_to(:manage, VideoWorkflow.new)
    end

    it "should be able to view user accounts" do
      should be_able_to(:read, User.new)
    end

  end
  
  context "with no special privileges" do

    before(:all) do
      @user = Factory.build(:user)
    end

    subject { ability }
    let(:ability){ Ability.new(@user) }

    it "should not be able to manage groups" do
      should_not be_able_to(:manage, Group.new)
    end

    it "should not be able to manage roles" do
      should_not be_able_to(:manage, Role.new)
    end

    it "should not be able to manage items" do
      should_not be_able_to(:manage, OpenItem.new)
    end

    it "should not be able to manage requests" do
      should_not be_able_to(:manage, Request.new)
    end

    it "should not be able to manage video workflow" do
      should_not be_able_to(:manage, VideoWorkflow.new)
    end

  end
      
end
