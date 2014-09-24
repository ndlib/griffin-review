require 'spec_helper'

describe MediaPlaylist do

  it "has item_id" do
    expect(subject).to respond_to(:item_id)
    expect(subject).to respond_to(:item_id=)
  end

  it "has rows" do
    expect(subject).to respond_to(:rows)
    expect(subject).to respond_to(:rows=)
  end


  it "has a type" do
    expect(subject).to respond_to(:rows)
    expect(subject).to respond_to(:rows=)
  end

  it " requires a item_id" do
    subject.should have(1).error_on(:item_id)
  end


end
