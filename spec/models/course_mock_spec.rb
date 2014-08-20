
require 'spec_helper'

describe CourseMock do


  describe :missing_data do

    it "updates the id of the current id into the json" do
      expect(CourseMock.missing_data("idid").first['section_groups'].first['crosslist_id']).to eq("idid")
    end

  end

end
