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

  it "requires a type" do
    subject.should have(2).error_on(:type)
  end

  it "expects type to be audio or video " do
    subject.type = 'audio'
    expect(subject).to have(0).error_on(:type)

    subject.type = 'video'
    expect(subject).to have(0).error_on(:type)

    subject.type = 'other'
    subject.should have(1).error_on(:type)
  end


end
