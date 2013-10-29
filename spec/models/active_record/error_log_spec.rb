require 'spec_helper'

describe ErrorLog do


  before(:each) do
    @user = double(User, id: 1, username: 'username')
    @request = double( path: '/path/to/url', params: { id: 'id', contorller: 'controller'}, user_agent: 'user_agent' )
    @exception = double(Exception, message: 'message', backtrace: [ 'line 1', 'line 2' ])

    @controller = double(ApplicationController, current_user: @user, request: @request)

    Masquerade.any_instance.stub(:masquerading?).and_return
    @error_log = ErrorLog.log_error(@controller, @exception)
  end


  it "logs an error " do
    expect(@error_log.valid?).to be_true
  end


  it "logs the error class" do
    expect(@error_log.exception_class).to eq("RSpec::Mocks::Mock")
  end

  it "logs the user agent " do
    expect(@error_log.user_agent).to eq("user_agent")
  end


  it "logs the request path" do
    expect(@error_log.path).to eq '/path/to/url'
  end


  it "logs the backtrace" do
    expect(@error_log.stack_trace).to eq @exception.backtrace.join("\n")
  end


  it "saves the message" do
    expect(@error_log.message).to eq "message"
  end


  it "determins the netid of the person with the problem" do
    expect(@error_log.netid).to eq "username"
  end


  it "saves the params" do
    expect(@error_log.params).to eq("{:id=>\"id\", :contorller=>\"controller\"}")
  end


  describe :masquerading_user do

    before(:each) do
      @user_in_masquerade = double(User, id: 2, username: 'original_username')

      Masquerade.any_instance.stub(:masquerading?).and_return(true)
      Masquerade.any_instance.stub(:original_user).and_return(@user_in_masquerade)

      @error_log = ErrorLog.log_error(@controller, @exception)
    end


    it "determins the netid of the person with the problem when they are masquerading" do
      expect(@error_log.netid).to eq "original_username (as: username)"
    end
  end


  it " defaults to new " do
    expect(@error_log.state).to eq("new")
  end


  it "can tranistion to resolved" do
    @error_log.resolve
    expect(@error_log.state).to eq("resolved")
  end


  it "can transition to active" do
    @error_log.start
    expect(@error_log.state).to eq("active")
  end


  it "can transition from active to resolved " do
    @error_log.start
    @error_log.resolve
    expect(@error_log.state).to eq("resolved")
  end

end
