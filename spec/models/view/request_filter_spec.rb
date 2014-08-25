require 'spec_helper'


describe RequestFilter do
  let(:user) { double(User, id: 1, username: 'username', admin_preferences: {}) }
  let(:session) { {} }
  let(:params) { {} }
  let(:controller) do
    ApplicationController.new.tap do |c|
      c.stub(:current_user).and_return(user)
      c.stub(:session).and_return( session )
      c.stub(:params).and_return( params )
    end
  end

  subject { described_class.new(controller)}

  describe :session_saving do

    it "saves the status value in the session when it is changed " do
      params[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ], semester_id: 1  }

      expect(subject.library_filters).to eq([ 'library1', 'library2'])
      expect(subject.type_filters).to eq([ 'types' ])
      expect(subject.semester_filter).to eq(1)
    end


    it "saves the new params over the old session data " do
      session[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }
      params[:admin_request_filter] = { libraries: [ 'library1'], types: [ 'type1' ], semester_id: 1  }

      expect(subject.session).to eq( { admin_request_filter: { libraries: [ 'library1'], types: [ 'type1' ], semester: 1 } } )
    end
  end


  describe :determine_filters do

    it "defaults to everything if there is nothing to choose from" do
      expect(subject.library_filters).to eq(described_class::VALID_LIBRARIES)
      expect(subject.type_filters).to eq(described_class::VALID_TYPES)
      expect(subject.semester_filter).to be(false)
    end


    it "reloads from the session " do
      session[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ], semester: 1  }

      expect(subject.library_filters).to eq([ 'library1', 'library2'])
      expect(subject.type_filters).to eq([ 'types' ])
      expect(subject.semester_filter).to eq(1)
    end

    describe 'user with preferences' do
      before do
        user.stub(:admin_preferences).and_return({:libraries => '32432423'})
        user.stub(:libraries).and_return([ 'library1', 'library2'])
        user.stub(:types).and_return( [ 'types' ] )
      end

      it "loads the filters from the user record" do

        expect(subject.library_filters).to eq([ 'library1', 'library2'])
        expect(subject.type_filters).to eq([ 'types' ])
      end


      it "does not load the semester from the user record" do
        user.stub(:semeseter).and_return( 1 )

        expect(subject.semester_filter).to be(false)
      end
    end
  end


  describe :library_selected? do

    it "returns true if the library selected is in the filters for the library" do
      session[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }

      expect(subject.library_selected?('library1')).to be_true
    end


    it "returns fakse if the library selected is in the filters for the library" do
      session[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }

      expect(subject.library_selected?('library3')).to be_false
    end
  end


  describe :type_selected? do

    it "returns true if the type selected is in the filters for the type" do
      session[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }

      expect(subject.type_selected?('types')).to be_true
    end


    it "returns fakse if the type selected is in the filters for the types" do
      session[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }

      expect(subject.type_selected?('other type')).to be_false
    end
  end

end
