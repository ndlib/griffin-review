require 'spec_helper'

describe BookReserveImporter do

  before(:each) do
    @bri = BookReserveImporter.new
    @bri.stub(:print_reserves).and_return([ {'bib_id' => 'id'} ])
    BookReserveImport.any_instance.stub(:reserves).and_return([double(Reserve, id: 'id')])

    semester = FactoryGirl.create(:semester)
    @course = double(Course, id: 'crosslist_id', semester: semester)
    BookReserveImport.any_instance.stub(:course).and_return(@course)
  end


  it "saves successful import results" do
    BookReserveImport.any_instance.stub(:success?).and_return(true)
    BookReserveImport.any_instance.stub(:bib_id).and_return("bib_id")
    BookReserveImport.any_instance.stub(:course_id).and_return("course_id")
    BookReserveImport.any_instance.stub(:import!).and_return(true)
    BookReserveImport.any_instance.stub(:validate!).and_return(true)

    @bri.import!
    expect(@bri.successes).to eq( [{:bib_id=>"bib_id", :course_id=>"course_id", :reserve_id=>"id"}] )
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


  it "logs successful imports" do
    BookReserveImport.any_instance.stub(:success?).and_return(true)
    BookReserveImport.any_instance.stub(:bib_id).and_return("bib_id")
    BookReserveImport.any_instance.stub(:course_id).and_return("course_id")
    BookReserveImport.any_instance.stub(:import!).and_return(true)
    BookReserveImport.any_instance.stub(:validate!).and_return(true)

    @bri.import!

    expect(ErrorLog.last.message).to eq("Aleph Importer Finished without errors")
  end


  it "logs unsuccessful imports" do
    BookReserveImport.any_instance.stub(:success?).and_return(false)
    BookReserveImport.any_instance.stub(:bib_id).and_return("bib_id")
    BookReserveImport.any_instance.stub(:course_id).and_return("course_id")
    BookReserveImport.any_instance.stub(:import!).and_return(false)
    BookReserveImport.any_instance.stub(:validate!).and_return(true)
    BookReserveImport.any_instance.stub(:errors).and_return([ "error1", "error2"])

    @bri.import!
    expect(ErrorLog.last.message).to eq("Aleph Importer Finished with errors \nBIB_ID: bib_id COURSE: course_id ERRORS: error1, error2")
  end
end
