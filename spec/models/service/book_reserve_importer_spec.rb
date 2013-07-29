require 'spec_helper'

describe BookReserveImporter do

  before(:each) do
    @bri = BookReserveImporter.new
    @bri.stub(:print_reserves).and_return([ {'bib_id' => 'id'} ])
  end


  it "saves successful import results" do
    BookReserveImport.any_instance.stub(:success?).and_return(true)
    BookReserveImport.any_instance.stub(:bib_id).and_return("bib_id")
    BookReserveImport.any_instance.stub(:course_id).and_return("course_id")
    BookReserveImport.any_instance.stub(:import!).and_return(true)
    BookReserveImport.any_instance.stub(:validate!).and_return(true)

    @bri.import!
    expect(@bri.successes).to eq([ { bib_id: "bib_id", course_id: "course_id" } ])
  end


  it "saves errored imports results" do
    BookReserveImport.any_instance.stub(:success?).and_return(false)
    BookReserveImport.any_instance.stub(:bib_id).and_return("bib_id")
    BookReserveImport.any_instance.stub(:course_id).and_return("course_id")
    BookReserveImport.any_instance.stub(:import!).and_return(false)
    BookReserveImport.any_instance.stub(:validate!).and_return(true)
    BookReserveImport.any_instance.stub(:errors).and_return([ "error1", "error2"])

    @bri.import!
    expect(@bri.errors).to eq([ { bib_id: "bib_id", course_id: "course_id", errors: [ "error1", "error2" ] } ])
  end

end
