require 'spec_helper'

describe AdminController do
      
  
  before(:all) do
    @current_semester = Factory.create(:semester)
    @next_semester = Factory.create(:semester, :date_begin => Date.today + 3.months, :date_end => Date.today + 6.months)
    @distant_semester = Factory.create(:semester, :date_begin => Date.today + 7.months, :date_end => Date.today + 12.months)
    @old_semester = Factory.create(:semester, :date_begin => Date.today - 6.months, :date_end => Date.today - 2.months)
    @admin_role = Factory.create(:admin_role)
    @jane_user = Factory.create(:user)
    @admin_user = Factory.create(:user)
    @admin_user.roles = [@admin_role]
    @pending_request_a = Factory.create(:generic_request, :semester => @current_semester, :user => @jane_user)
    @pending_request_b = Factory.create(:generic_request, :semester => @current_semester, :user => @jane_user)
    @pending_request_c = Factory.create(:generic_request, :semester => @next_semester, :user => @admin_user)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @admin_user
  end

  after(:each) do
    sign_out @admin_user
  end

  context "Semester Administration" do
    describe "list of semesters" do
      
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
        get :edit_semester, {:s_id => @semester.id}
        assigns(:semester).should eq(@semester)
      end
      it "renders the :edit template" do
        get :edit_semester, {:s_id => @semester.id}
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
          response.should redirect_to admin_semester_url(@last_semester)
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
          put :update_semester, :s_id => @changeable_semester,
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
          put :update_semester, :s_id => @changeable_semester,
            :semester => Factory.attributes_for(
              :semester,
              :code => 'WIN25',
              :date_begin => Date.today - 6.months, 
              :date_end => Date.today - 3.months
            )
            response.should redirect_to admin_semester_url(@changeable_semester)
        end
      end

      context "with invalid attributes" do
        it "rejects an invalid record" do
          put :update_semester, :s_id => @changeable_semester,
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
            put :update_semester, :s_id => @changeable_semester, 
              :semester => Factory.attributes_for(:semester, :code => '')
            response.should render_template 'admin/semester/edit'
        end
      end


    end

  end

end
