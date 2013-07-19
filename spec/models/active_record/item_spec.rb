require 'spec_helper'

describe Item do

  describe "validations" do

    it " requires a title" do
      Item.new.should have(1).error_on(:title)
    end

    it "requires a type" do
      Item.new.should have(1).error_on(:type)
    end
  end



end
