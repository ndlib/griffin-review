require 'spec_helper'


describe RequestFilter do


  before(:each) do
    @controller = ApplicationController.new
    @controller.stub(:current_user).and_return(double(User, id: 1, username: 'usernaem', admin_preferences: {}))
    @controller.stub(:session).and_return({ } )
    @controller.stub(:params).and_return( { } )
  end

  describe :session_saving do

    it "saves the status value in the session when it is changed " do
      @controller.params[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }
      arf = RequestFilter.new(@controller)

      expect(arf.library_filters).to eq([ 'library1', 'library2'])
      expect(arf.type_filters).to eq([ 'types' ])
    end


    it "saves the new params over the old session data " do
      @controller.session[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }
      @controller.params[:admin_request_filter] = { libraries: [ 'library1'], types: [ 'type1' ], semester_id: 1  }
      arf = RequestFilter.new(@controller)

      expect(@controller.session).to eq( { admin_request_filter: { libraries: [ 'library1'], types: [ 'type1' ], semester: 1 } } )
    end
  end


  describe :determine_filters do

    it "defaults to everything if there is nothing to choose from" do
      arf = RequestFilter.new(@controller)
      expect(arf.library_filters).to eq(RequestFilter::VALID_LIBRARIES)
      expect(arf.type_filters).to eq(RequestFilter::VALID_TYPES)
    end


    it "reloads from the session " do
      @controller.session[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }

      arf = RequestFilter.new(@controller)

      expect(arf.library_filters).to eq([ 'library1', 'library2'])
      expect(arf.type_filters).to eq([ 'types' ])
    end


    it "loads the filters from the user record" do
      @controller.current_user.stub(:admin_preferences).and_return({:libraries => '32432423'})
      @controller.current_user.stub(:libraries).and_return([ 'library1', 'library2'])
      @controller.current_user.stub(:types).and_return( [ 'types' ] )

      arf = RequestFilter.new(@controller)

      expect(arf.library_filters).to eq([ 'library1', 'library2'])
      expect(arf.type_filters).to eq([ 'types' ])
    end
  end


  describe :library_selected? do

    it "returns true if the library selected is in the filters for the library" do
      @controller.session[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }

      arf = RequestFilter.new(@controller)
      expect(arf.library_selected?('library1')).to be_true
    end


    it "returns fakse if the library selected is in the filters for the library" do
      @controller.session[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }

      arf = RequestFilter.new(@controller)
      expect(arf.library_selected?('library3')).to be_false
    end
  end


  describe :type_selected? do

    it "returns true if the type selected is in the filters for the type" do
      @controller.session[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }

      arf = RequestFilter.new(@controller)
      expect(arf.type_selected?('types')).to be_true
    end


    it "returns fakse if the type selected is in the filters for the types" do
      @controller.session[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }

      arf = RequestFilter.new(@controller)
      expect(arf.type_selected?('other type')).to be_false
    end
  end

end
