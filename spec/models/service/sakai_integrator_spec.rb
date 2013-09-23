require 'spec_helper'

describe SakaiIntegrator do

  before(:each) do
    @controller = double(ActionController, :session => {}, :current_user => double(User, id: 1, username: 'jdan', name: 'Scooby Doo') )
    @controller.stub(:sign_in)
  end

  let(:si) {
    VCR.use_cassette 'sakai/sakai_integrator' do
      SakaiIntegrator.new(@controller)
    end
  }
  let(:course_search) { CourseSearch.new }

  describe "#get_site_property" do

    it "retrieves an external site id" do
      VCR.use_cassette 'sakai/external_site_id' do
        si.site_id = "21590942-4d68-4f83-8529-da22ea02fd0e"
        si.get_site_property('externalSiteId').should eq "XLS33201300"
      end
    end


    it "returns null with invalid site id" do
      VCR.use_cassette 'sakai/invalid_site_id' do
        si.site_id = "21590942-4d68-4f83-8529-da22ea02fd0"
        si.get_site_property('externalSiteId').should_not eq "XLS33201300"
      end
    end

  end


  describe "#parse_external_site_id" do

    it "parses crosslist external id" do
      si.send(:parse_external_site_id, "XLSCE201200")[1].should eq '201200_CE'
    end

    it "parses supersection external id" do
      si.send(:parse_external_site_id, "FA12-ACMS-10001-SS03")[1].should eq "FA12-ACMS-10001-SS03"
    end

    it "parses section external id" do
      si.send(:parse_external_site_id, "SU13-ACCT-20100-01")[1].should eq "201300_ACCT_20100_01"
    end

    it "determines the site term value" do
      si.send(:parse_external_site_id, "SU13-ACCT-20100-01")[2].should eq "201300"
    end

  end

  describe "#translate_external_site_id" do

    let(:section_external_site_id) {
      VCR.use_cassette 'sakai/translate_single_section' do
        si.site_id = "749d7ca8-4743-431e-a102-a4c042db8337"
        si.get_site_property('externalSiteId')
      end
    }

    let(:supersection_external_site_id) {
      VCR.use_cassette 'sakai/translate_supersection' do
        si.site_id = "0753e1de-d90f-43d5-a0de-6e9761a35690"
        si.get_site_property('externalSiteId')
      end
    }

    let(:crosslist_external_site_id) {
      VCR.use_cassette 'sakai/translate_crosslist' do
        si.site_id = "21590942-4d68-4f83-8529-da22ea02fd0e"
        si.sakai_user = "vcoyne"
        si.get_site_property('externalSiteId')
      end
    }

    it "translates single section into course id" do
      VCR.use_cassette 'sakai/jdan_all_spring2013_courses' do
        si.sakai_user = "jdan"
        si.translate_external_site_id(section_external_site_id).should include '201220_28970_28969'
      end
    end

    it "translates supersection into course id" do
      VCR.use_cassette 'sakai/jdan_all_spring2013_courses' do
        si.sakai_user = "jdan"
        si.translate_external_site_id(supersection_external_site_id).should include '201220_28972_28971'
      end
    end

    it "translates crosslist into course id" do
      @controller = double(ActionController, :session => {}, :current_user => double(User, id: 1, username: 'vcoyne', name: 'Fred') )
      @controller.stub(:sign_in)
      VCR.use_cassette 'sakai/vcoyne_all_summer2013_courses' do
        si.translate_external_site_id(crosslist_external_site_id).should include '201300_33'
      end
    end
  end

end
