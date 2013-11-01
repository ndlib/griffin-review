

class SipxQuery
  attr_accessor :userId, :userName, :emailAddress, :userRole, :courseId, :courseName, :courseNumber, :courseStartDate, :courseEndDate, :courseClassEnrollment, :cancelUrl, :returnUrl

  INSTITUTION_ID = "in-851c0f70-8534-11e2-8ba2-12313d299634"
  CALLER_TYPE = "Notre-Dame-EReserves"
  LMS_ID = 'IpqrnsO1Ba0vPa4t9DQ+7dEtc5o0jKgxG+Ac/VJ5PV9SuST8ZLgmNqqCVm0meFvEvkQAFeBDSfI='
  # IpqrnsO1Ba0vPa4t9DQ+7dEtc5o0jKgxG+Ac/VJ5PV9SuST8ZLgmNskBPdE6eA0fgb877Fu3okw=
  API_VERSION = '1'
  API_URL = "https://service.sipx.com"
  API_PATH = "/service/php/lms_onramp.php"
  RETURN_PARAMETERS = "user_id|institution_id|document_id|course_id|course_name|course_number"


  def request

  end



    def connection
      @connection ||= Faraday.new(:url => API_URL) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end


    def post_params
      @post_parans ||= {
        api_version: API_VERSION,
        userId: 'jhartzle',
        userName: 'jon hartzler',
        emailAddress: 'jhartzler@nd.edu',
        userRole: 'instructor',
        courseId: 'test_course',
        courseName: "Introdcution to a test course",
        courseNumber: "Test 101",
        courseStartDate: 25.days.ago,
        courseEndDate: 25.days.from_now,
        courseClassEnrollment: '33',
        returnParameters: RETURN_PARAMETERS,
        institution: INSTITUTION_ID,
        callerType: CALLER_TYPE,
        lmsId: 'Development',
        key: LMS_ID
      }
    end

    def stu_params
    {
        api_version: API_VERSION,
        userId: 'bobbobbers',
        userName: 'Bob bobbers',
        emailAddress: 'bbobbers@nd.edu',
        userRole: 'user',
        courseId: 'test_course',
        courseName: "Introdcution to a test course",
        courseNumber: "Test 101",
        courseStartDate: 25.days.ago,
        courseEndDate: 25.days.from_now,
        courseClassEnrollment: '33',
        returnParameters: RETURN_PARAMETERS,
        institution: INSTITUTION_ID,
        callerType: CALLER_TYPE,
        lmsId: 'Development',
        key: LMS_ID
      }
    end
end

