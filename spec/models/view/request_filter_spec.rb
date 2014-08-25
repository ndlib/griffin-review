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

    it "saves the semester value in the session when it is changed " do
      params[:admin_request_filter] = { semester_id: 1  }

      expect(subject.semester_filter).to eq(1)
    end


    it "saves the new params over the old session data " do
      params[:admin_request_filter] = { semester_id: 1  }

      expect(subject.session).to eq( { admin_request_filter: { semester: 1 } } )
    end
  end

  describe '#all_types' do
    it "is all types" do
      expect(subject.all_types).to eq(["BookReserve", "BookChapterReserve", "JournalReserve", "AudioReserve", "VideoReserve"])
    end
  end

  describe '#all_libraries' do
    it "is all libraries" do
      expect(subject.all_libraries).to eq(["hesburgh", "math", "chem", "business", "architecture", "engineering"])
    end
  end

  describe '#all_statuses' do
    it "is all statuses plus a combined new & in process" do
      expect(subject.all_statuses).to eq(["new|inprocess", "new", "inprocess", "on_order", "available", "removed", "not_in_aleph"])
    end
  end


  describe :determine_filters do

    it "defaults to everything if there is nothing to choose from" do
      expect(subject.library_filters).to eq(described_class::VALID_LIBRARIES)
      expect(subject.type_filters).to eq(described_class::VALID_TYPES)
      expect(subject.semester_filter).to be(false)
    end


    it "reloads the semester from the session " do
      session[:admin_request_filter] = { semester: 1  }

      expect(subject.semester_filter).to eq(1)
    end

    describe 'user with preferences' do
      before do
        user.stub(:admin_preferences).and_return({:libraries => '32432423'})
        user.stub(:libraries).and_return([ 'library1', 'library2'])
        user.stub(:types).and_return( [ 'type1', 'type2' ] )
      end

      it "loads the filters from the user record" do

        expect(subject.library_filters).to eq([ 'library1', 'library2'])
        expect(subject.type_filters).to eq([ 'type1', 'type2' ])
      end


      it "does not load the semester from the user record" do
        user.stub(:semeseter).and_return( 1 )

        expect(subject.semester_filter).to be(false)
      end

      describe '#default_library?' do
        it 'is true for library1' do
          expect(subject.default_library?('library1')).to be_true
        end

        it 'is false for library3' do
          expect(subject.default_library?('library3')).to be_false
        end

        it 'is true if the params change the selected libraries' do
          params[:admin_request_filter] = { libraries: [ 'library3', 'library4'] }
          expect(subject.library_selected?('library1')).to be_false
          expect(subject.default_library?('library1')).to be_true
        end
      end

      describe '#default_type?' do
        it 'is true for type1' do
          expect(subject.default_type?('type1')).to be_true
        end

        it 'is false for type3' do
          expect(subject.default_type?('type3')).to be_false
        end

        it 'is true if the params change the selected types' do
          params[:admin_request_filter] = { types: [ 'type3', 'type4' ] }
          expect(subject.type_selected?('type1')).to be_false
          expect(subject.default_type?('type1')).to be_true
        end
      end
    end
  end


  describe :library_selected? do

    it "returns true if the library selected is in the filters for the library" do
      params[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }

      expect(subject.library_selected?('library1')).to be_true
    end


    it "returns false if the library selected is in the filters for the library" do
      params[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }

      expect(subject.library_selected?('library3')).to be_false
    end
  end


  describe :type_selected? do

    it "returns true if the type selected is in the filters for the type" do
      params[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }

      expect(subject.type_selected?('types')).to be_true
    end


    it "returns false if the type selected is in the filters for the types" do
      params[:admin_request_filter] = { libraries: [ 'library1', 'library2'], types: [ 'types' ] }

      expect(subject.type_selected?('other type')).to be_false
    end
  end

  describe '#status_selected?' do
    it 'is true for new|inprocess' do
      expect(subject.status_selected?('new|inprocess')).to be_true
    end

    it 'is false for another status' do
      expect(subject.status_selected?('new')).to be_false
    end
  end

  describe '#default_status?' do
    it 'is true for new|inprocess' do
      expect(subject.default_status?('new|inprocess')).to be_true
    end

    it 'is false for another status' do
      expect(subject.default_status?('new')).to be_false
    end
  end

end
