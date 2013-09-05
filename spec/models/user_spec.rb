require 'spec_helper'

describe User do


  it "downcases the username no matter what was entered" do
    expect(User.new(username: "UPPER").username).to eq("upper")
  end


  it "strips the username no matter what was entered" do
    expect(User.new(username: " strip ").username).to eq("strip")
  end

end
