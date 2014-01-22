

describe API::Resource do


  describe :fix_id do

    it "appends ndu_aleph if the the id is all numeric and 9 characters long" do
      expect(API::Resource.fix_id("025332532")).to eq("ndu_aleph025332532")
    end


    it "does not append ndu_aleph if the id is less then 9 characters" do
      expect(API::Resource.fix_id("02533253")).to eq("02533253")
    end


    it "does not append ndu_aleph if the id contains alpha charcters" do
      expect(API::Resource.fix_id("a02533253")).to eq("a02533253")
    end

    it "does not append ndu_aleph if the number is longer then 9 characters" do
      expect(API::Resource.fix_id("0253325300")).to eq("0253325300")
    end

  end
end
