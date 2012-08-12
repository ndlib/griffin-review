require 'spec_helper'

describe Ldap do
  before :each do
    @ldap = Factory.build(:ldap_tls)
  end

  describe "Connecting to Directory Services" do
    it "should create a valid connection" do
      @ldap.connect
      @ldap.should be_a_valid_connection
    end
    it "should fail with bad authentication credentials" do
      @ldap.ldap_password = 'bad_password'
      @ldap.connect
      @ldap.should_not be_a_valid_connection
    end
  end

  describe "Lookup records by attribute" do
    before :each do
      @ldap.connect
    end
    it "should lookup by uid" do
      @ldap.find("uid", Rails.configuration.rspec_uid).cn.first.should eq(Rails.configuration.rspec_cn)
    end
    it "should lookup by common name" do
      @ldap.find("uid", Rails.configuration.rspec_uid).uid.first.should eq(Rails.configuration.rspec_uid)
    end
    it "should return a list from lookup by last name" do
      @ldap.find("sn", Rails.configuration.rspec_last_name).should have_at_least(1).record
    end

    it "should return the appropriate exception if no records found" do
      @ldap.find("cn", "Man With No Name").should be_nil
    end
  end

  describe "Return field values for individual records" do
    it "should return value by field name" do
      record = @ldap.find("uid", Rails.configuration.rspec_uid)
      record.cn.first.should eq(Rails.configuration.rspec_cn)
    end
    it "should give exception when no field found" do
      record = @ldap.find("uid", Rails.configuration.rspec_uid)
      expect { record.non_field.first }.to raise_error
    end
    it "should return a list of fields if multiple are found and requested" do
      record = @ldap.find("uid", Rails.configuration.rspec_uid)
      record.ndmail.should have_at_least(1).entry
    end
  end
end
