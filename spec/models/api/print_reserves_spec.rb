require 'spec_helper'


describe API::PrintReserves do


  before(:each) do
    API::Base.stub(:get).and_return(all_results)
  end

  it "returns an array with the results" do
    API::PrintReserves.all.class.should == Array
  end

  it "has a bib_id" do
    record = API::PrintReserves.all.first
    expect(record.has_key?("bib_id")).to be_true
  end

  it "has a section_group_id" do
    record = API::PrintReserves.all.first
    expect(record.has_key?("section_group_id")).to be_true
  end


  def all_results
    file = File.join(Rails.root, 'spec', 'fixtures', 'json_save', 'print_reserves', 'all.json')
    File.read(file)
  end

end
