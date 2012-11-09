require 'spec_helper'

describe AdminController do
      
  
  before(:all) do
    @current_semester = Factory.create(:semester)
    @next_semester = Factory.create(:semester, :date_begin => Date.today + 3.months, :date_end => Date.today + 6.months)
    @distant_semester = Factory.create(:semester, :date_begin => Date.today + 7.months, :date_end => Date.today + 12.months)
    @old_semester = Factory.create(:semester, :date_begin => Date.today - 6.months, :date_end => Date.today - 2.months)
    @admin_role = Factory.create(:admin_role)
    @media_admin_role = Factory.create(:media_admin_role)
    @jane_user = Factory.create(:user)
    @admin_user = Factory.create(:user)
    @admin_user.roles = [@admin_role]
    @media_admin_user = Factory.create(:user)
    @media_admin_user.roles = [@media_admin_role]
    @pending_request_a = Factory.create(:generic_request, :semester => @current_semester, :user => @jane_user)
    @pending_request_b = Factory.create(:generic_request, :semester => @current_semester, :user => @jane_user)
    @pending_request_c = Factory.create(:generic_request, :semester => @next_semester, :user => @admin_user)
    @metadata_a = Factory.create(:metadata_attribute)
    @metadata_b = Factory.create(:metadata_attribute)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "Metadata Attribute Administration" do
    describe "view, create, and edit metadata attributes" do

      before(:each) do
        @changeable_metadata_attribute = Factory.create(:metadata_attribute, :name => 'Changed')
        sign_in @media_admin_user
      end

      after(:each) do
        @changeable_metadata_attribute.destroy
        sign_out @media_admin_user
      end

      it "shows a list of all metadata attributes in the system" do
        get :all_metadata_attributes
        assigns(:metadata_attributes).should have(3).items
      end

      it "assigns a new meta attr to @metadata_attribute" do
        get :new_metadata_attribute
        assigns(:metadata_attribute).should be_a_new(MetadataAttribute)
      end

      it "renders the :new template" do
        get :new_metadata_attribute
        response.should render_template :new
      end

      context "creates with valid parameters" do
        it "saves the metadata attribute to the database" do
          expect {
            post :create_metadata_attribute, :metadata_attribute => Factory.attributes_for(:metadata_attribute)
          }.to change(MetadataAttribute, :count).by(1)
        end
        it "redirect to the full list of metadata attributes" do
          post :create_metadata_attribute, :metadata_attribute => Factory.attributes_for(:metadata_attribute)
          response.should redirect_to all_metadata_attribute_url
        end
      end

      context "rejects with invalid attributes" do
        it "rejects an invalid record" do
          expect {
            post :create_metadata_attribute, :metadata_attribute => Factory.attributes_for(:metadata_attribute, :name => '')
          }.to_not change(MetadataAttribute, :count)
        end
        it "re-renders the :new_metadata_attribute template" do
            post :create_metadata_attribute, :metadata_attribute => Factory.attributes_for(:metadata_attribute, :name => '')
            response.should render_template 'admin/metadata_attribute/new'
        end
      end

      context "opening the edit metadata page" do
        it "assigns the requested metadata_attribute to @metadata_attribute" do
          get :edit_metadata_attribute, {:metadata_attribute_id => @metadata_a.id}
          assigns(:metadata_attribute).should eq(@metadata_a)
        end
        it "renders the :edit template" do
          get :edit_metadata_attribute, {:metadata_attribute_id => @metadata_a.id}
          response.should render_template :edit
        end
      end

      context "updates metadata object with valid attributes" do
        it "updates the metadata object's attributes" do
          put :update_metadata_attribute, :metadata_attribute_id => @changeable_metadata_attribute.id,
            :metadata_attribute => Factory.attributes_for(
              :metadata_attribute,
              :name => 'Another Name',
              :definition => 'Another definition',
              :metadata_type => 'Another type'
            )
            @changeable_metadata_attribute.reload
            @changeable_metadata_attribute.definition.should eq('Another definition')
        end
        it "redirects to the metadata_attribute page" do
          put :update_metadata_attribute, :metadata_attribute_id => @changeable_metadata_attribute.id,
            :metadata_attribute => Factory.attributes_for(
              :metadata_attribute,
              :name => 'Another Name',
              :definition => 'Another definition',
              :metadata_type => 'Another type'
            )
            response.should redirect_to all_metadata_attribute_url
        end
      end

      context "does not update metadata with invalid attributes" do
        it "rejects an invalid record" do
          put :update_metadata_attribute, :metadata_attribute_id => @changeable_metadata_attribute.id,
            :metadata_attribute => Factory.attributes_for(
              :metadata_attribute,
              :name => nil,
              :definition => 'Another definition'
            )
            @changeable_metadata_attribute.reload
            @changeable_metadata_attribute.name.should eq(@changeable_metadata_attribute.name)
        end
        it "re-renders the :new_metadata_attribute edit template" do
            put :update_metadata_attribute, :metadata_attribute_id => @changeable_metadata_attribute.id, 
              :metadata_attribute => Factory.attributes_for(:metadata_attribute, :name => '')
            response.should render_template 'admin/metadata_attribute/edit'
        end
      end
    end
  end

  context "Semester Administration" do
    describe "list of semesters" do

      before(:each) do
        sign_in @admin_user
      end

      after(:each) do
        sign_out @admin_user
      end
      
      it "shows a list of all semesters in the system" do
        get :show_all_semesters
        assigns(:semesters).should have(4).items
      end

      it "shows the three active semesters via a filter" do
        get :show_proximate_semesters
        assigns(:semesters).should include(@old_semester, @current_semester, @next_semester)
      end

      it "provides access to all requests for a semester" do
        @current_semester.should have(2).pending_requests 
      end

    end

    describe "GET #new_semester" do
      
      before(:all) do 
        @semester = Factory.create(:semester)
        @admin_user.roles = [@admin_role]
      end

      before(:each) do
        sign_in @admin_user
      end

      after(:each) do
        sign_out @admin_user
      end

      it "assigns a new semester to @semester" do
        get :new_semester
        assigns(:semester).should be_a_new(Semester)
      end

      it "renders the :new template" do
        get :new_semester
        response.should render_template :new
      end

    end

    describe "GET #edit_semester" do
      
      before(:all) do 
        @admin_user.roles = [@admin_role]
      end

      before(:each) do
        @semester = Factory.create(:semester)
        sign_in @admin_user
      end

      after(:each) do
        @semester.destroy
        sign_out @admin_user
      end

      it "assigns the requested semester to @semester" do
        get :edit_semester, {:semester_id => @semester.id}
        assigns(:semester).should eq(@semester)
      end
      it "renders the :edit template" do
        get :edit_semester, {:semester_id => @semester.id}
        response.should render_template :edit
      end
    end

    describe "POST #create_semester" do
      
      before(:all) do 
        @admin_user.roles = [@admin_role]
      end

      before(:each) do
        sign_in @admin_user
      end

      after(:each) do
        sign_out @admin_user
      end

      context "with valid attributes" do
        it "saves the semester to the database" do
          expect {
            post :create_semester, :semester => Factory.attributes_for(:semester)
          }.to change(Semester, :count).by(1)
        end
        it "redirect to this semester page" do
          post :create_semester, :semester => Factory.attributes_for(:semester)
          @last_semester = Semester.last
          response.should redirect_to semester_url(@last_semester)
        end
      end

      context "with invalid attributes" do
        it "rejects an invalid record" do
          expect {
            post :create_semester, :semester => Factory.attributes_for(:semester, :code => '')
          }.to_not change(Semester, :count)
        end
        it "re-renders the :new_semester template" do
            post :create_semester, :semester => Factory.attributes_for(:semester, :code => '')
            response.should render_template 'admin/semester/new'
        end
      end

    end

    describe "PUT #update_semester" do
      
      before(:all) do 
        @admin_user.roles = [@admin_role]
      end

      before(:each) do
        @changeable_semester = Factory.create(:semester, :code => 'SU14')
        sign_in @admin_user
      end

      after(:each) do
        @changeable_semester.destroy
        sign_out @admin_user
      end

      context "with valid attributes" do
        it "updates the semester's attributes" do
          put :update_semester, :semester_id => @changeable_semester,
            :semester => Factory.attributes_for(
              :semester,
              :code => 'WIN25',
              :date_begin => Date.today - 6.months, 
              :date_end => Date.today - 3.months
            )
            @changeable_semester.reload
            @changeable_semester.date_end.should eq(Date.today - 3.months)
            @changeable_semester.code.should eq('WIN25')
        end
        it "redirects to the semester page" do
          put :update_semester, :semester_id => @changeable_semester,
            :semester => Factory.attributes_for(
              :semester,
              :code => 'WIN25',
              :date_begin => Date.today - 6.months, 
              :date_end => Date.today - 3.months
            )
            response.should redirect_to semester_url(@changeable_semester)
        end
      end

      context "with invalid attributes" do
        it "rejects an invalid record" do
          put :update_semester, :semester_id => @changeable_semester,
            :semester => Factory.attributes_for(
              :semester,
              :full_name => '',
              :code => 'WIN25'
            )
            @changeable_semester.reload
            @changeable_semester.full_name.should eq(@changeable_semester.full_name)
            @changeable_semester.code.should_not eq('WIN25')
        end
        it "re-renders the :new_semester template" do
            put :update_semester, :semester_id => @changeable_semester, 
              :semester => Factory.attributes_for(:semester, :code => '')
            response.should render_template 'admin/semester/edit'
        end
      end

    end

  end

end
