

describe SipxRedirect do
  before(:each) do
    @semester = double(Semester, date_begin: '1/1/2013'.to_date(), date_end: '6/6/2013'.to_date)
    @course = double(Course, id: 'id', title: 'title', crosslisted_course_number: 'crosslisted_course_number', semester: @semester, enrollment_netids: ['1', '2', '3'])
    @user = double(User, username: 'username', display_name: 'display_name', email: 'email')

    @sipx_redirect = SipxRedirect.new(@course, @user)
  end

  describe :post_params do

    context :student do

      it "returns a correct hash" do
        @post_params = @sipx_redirect.send(:post_params, 'student')
        expect(@post_params).to eq({:api_version=>"1", :userId=>"username", :userName=>"display_name", :emailAddress=>"email", :userRole=>"student", :courseId=>"id", :courseName=>"title", :courseNumber=>"crosslisted_course_number", :courseStartDate=>"2013-01-01", :courseEndDate=>"2013-06-06", :courseClassEnrollment=>3, :returnParameters=>"user_id|institution_id|document_id|course_id|course_name|course_number", :institution=>"in-851c0f70-8534-11e2-8ba2-12313d299634", :callerType=>"Notre-Dame-EReserves", :lmsId=>"Development", :key=>"IpqrnsO1Ba0vPa4t9DQ+7dEtc5o0jKgxG+Ac/VJ5PV9SuST8ZLgmNqqCVm0meFvEvkQAFeBDSfI="})
      end

      it "returns a corrrect hash in production " do
        Rails.stub(:env).and_return('production')
        @post_params = @sipx_redirect.send(:post_params, 'student')
        expect(@post_params).to eq({:api_version=>"1", :userId=>"username", :userName=>"display_name", :emailAddress=>"email", :userRole=>"student", :courseId=>"id", :courseName=>"title", :courseNumber=>"crosslisted_course_number", :courseStartDate=>"2013-01-01", :courseEndDate=>"2013-06-06", :courseClassEnrollment=>3, :returnParameters=>"user_id|institution_id|document_id|course_id|course_name|course_number", :institution=>"in-851c0f70-8534-11e2-8ba2-12313d299634", :callerType=>"Notre-Dame-EReserves", :lmsId=>"Production", :key=>"IpqrnsO1Ba0vPa4t9DQ+7dEtc5o0jKgxG+Ac/VJ5PV9SuST8ZLgmNskBPdE6eA0fgb877Fu3okw="})
      end
    end


    context :instructor do
      it "returns a correct hash" do
        @post_params = @sipx_redirect.send(:post_params, 'instructor')
        expect(@post_params).to eq({:api_version=>"1", :userId=>"username", :userName=>"display_name", :emailAddress=>"email", :userRole=>"instructor", :courseId=>"id", :courseName=>"title", :courseNumber=>"crosslisted_course_number", :courseStartDate=>"2013-01-01", :courseEndDate=>"2013-06-06", :courseClassEnrollment=>3, :returnParameters=>"user_id|institution_id|document_id|course_id|course_name|course_number", :institution=>"in-851c0f70-8534-11e2-8ba2-12313d299634", :callerType=>"Notre-Dame-EReserves", :lmsId=>"Development", :key=>"IpqrnsO1Ba0vPa4t9DQ+7dEtc5o0jKgxG+Ac/VJ5PV9SuST8ZLgmNqqCVm0meFvEvkQAFeBDSfI="})
      end

      it "returns a correct hash in production" do
        Rails.stub(:env).and_return('production')
        @post_params = @sipx_redirect.send(:post_params, 'instructor')
        expect(@post_params).to eq({:api_version=>"1", :userId=>"username", :userName=>"display_name", :emailAddress=>"email", :userRole=>"instructor", :courseId=>"id", :courseName=>"title", :courseNumber=>"crosslisted_course_number", :courseStartDate=>"2013-01-01", :courseEndDate=>"2013-06-06", :courseClassEnrollment=>3, :returnParameters=>"user_id|institution_id|document_id|course_id|course_name|course_number", :institution=>"in-851c0f70-8534-11e2-8ba2-12313d299634", :callerType=>"Notre-Dame-EReserves", :lmsId=>"Production", :key=>"IpqrnsO1Ba0vPa4t9DQ+7dEtc5o0jKgxG+Ac/VJ5PV9SuST8ZLgmNskBPdE6eA0fgb877Fu3okw="})
      end
    end


    context :other do

      it "raises an error if the role is invalid" do
        expect {
          @sipx_redirect.send(:post_params, 'not_valid')
        }.to raise_error
      end
    end

  end


  describe :response_parsing do
    before(:each) do
      @body = "SQL error: Column 'api_version' cannot be null\n****************\nn0XLqWnQKYONoXbLS3X8TcDOUvD1WDTpa7ZK1PfM_tr6_UouoDooyNdYmzeJddmTULOBKIbLq4Y,\nhttp://service.sipx.com/service/php/instructor_inspect_course.php?course_id=c-e58fa126-5790-11e3-b4ce-22000a90058c\nhttp://service.sipx.com/service/php/home.php?"
    end
    it "parses out the junk at the front of the reseponse" do
      expect(@sipx_redirect.send(:parse_unused_text_out_of_body, @body)).to eq("n0XLqWnQKYONoXbLS3X8TcDOUvD1WDTpa7ZK1PfM_tr6_UouoDooyNdYmzeJddmTULOBKIbLq4Y,\nhttp://service.sipx.com/service/php/instructor_inspect_course.php?course_id=c-e58fa126-5790-11e3-b4ce-22000a90058c\nhttp://service.sipx.com/service/php/home.php?")
    end


    it "creates a hash with the token to auto login a user" do
      expect(@sipx_redirect.send(:parse_response, @body)[:token]).to eq("n0XLqWnQKYONoXbLS3X8TcDOUvD1WDTpa7ZK1PfM_tr6_UouoDooyNdYmzeJddmTULOBKIbLq4Y,")
    end

    it "creates a hash with the url we should go to" do
      expect(@sipx_redirect.send(:parse_response, @body)[:url]).to eq("http://service.sipx.com/service/php/instructor_inspect_course.php?course_id=c-e58fa126-5790-11e3-b4ce-22000a90058c")
    end
  end


  describe :course_redirect_url do
    before(:each) do
      @body = "SQL error: Column 'api_version' cannot be null\n****************\nn0XLqWnQKYONoXbLS3X8TcDOUvD1WDTpa7ZK1PfM_tr6_UouoDooyNdYmzeJddmTV7kVw2KswH8,\nhttp://service.sipx.com/service/php/user_inspect_course.php?course_id=c-e58fa126-5790-11e3-b4ce-22000a90058c\nhttp://service.sipx.com/service/php/home.php?"
      response = double("SIPX_RESPONSE", body: @body)

      @sipx_redirect.send(:connection).stub(:post).and_return(response)
    end


    it "returns the correct url for a student" do
      expect(@sipx_redirect.course_redirect_url).to eq("http://service.sipx.com/service/php/user_inspect_course.php?course_id=c-e58fa126-5790-11e3-b4ce-22000a90058c&sipx_lms_token=n0XLqWnQKYONoXbLS3X8TcDOUvD1WDTpa7ZK1PfM_tr6_UouoDooyNdYmzeJddmTV7kVw2KswH8,")
    end


    it "allows the url to be overwritten " do
      expect(@sipx_redirect.course_redirect_url('http://www.google.com')).to eq("http://www.google.com?sipx_lms_token=n0XLqWnQKYONoXbLS3X8TcDOUvD1WDTpa7ZK1PfM_tr6_UouoDooyNdYmzeJddmTV7kVw2KswH8,")
    end


    it "allows the overwritten url to have query params" do
      expect(@sipx_redirect.course_redirect_url('http://www.google.com?a=1')).to eq("http://www.google.com?a=1&sipx_lms_token=n0XLqWnQKYONoXbLS3X8TcDOUvD1WDTpa7ZK1PfM_tr6_UouoDooyNdYmzeJddmTV7kVw2KswH8,")
    end
  end


  describe :admin_redirect_url do
    before(:each) do
      @body = "SQL error: Column 'api_version' cannot be null\n****************\nn0XLqWnQKYONoXbLS3X8TcDOUvD1WDTpa7ZK1PfM_tr6_UouoDooyNdYmzeJddmTULOBKIbLq4Y,\nhttp://service.sipx.com/service/php/instructor_inspect_course.php?course_id=c-e58fa126-5790-11e3-b4ce-22000a90058c\nhttp://service.sipx.com/service/php/home.php?"
      response = double("SIPX_RESPONSE", body: @body)

      @sipx_redirect.send(:connection).stub(:post).and_return(response)
    end

    it "returns the correct url for a student" do
      expect(@sipx_redirect.admin_redirect_url).to eq("http://service.sipx.com/service/php/instructor_inspect_course.php?course_id=c-e58fa126-5790-11e3-b4ce-22000a90058c&sipx_lms_token=n0XLqWnQKYONoXbLS3X8TcDOUvD1WDTpa7ZK1PfM_tr6_UouoDooyNdYmzeJddmTULOBKIbLq4Y,")
    end
  end
end
