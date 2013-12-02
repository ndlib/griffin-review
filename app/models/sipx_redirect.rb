

class SipxRedirect

  INSTITUTION_ID = "in-851c0f70-8534-11e2-8ba2-12313d299634"
  CALLER_TYPE = "Notre-Dame-EReserves"
  API_VERSION = '1'
  API_URL = "https://service.sipx.com"
  API_PATH = "/service/php/lms_onramp.php"
  RETURN_PARAMETERS = "user_id|institution_id|document_id|course_id|course_name|course_number"


  def initialize(course, current_user)
    @course = course
    @current_user = current_user
  end


  def admin_redirect_url
    request = connection.post(API_PATH, post_params('instructor'))
    response = parse_response(request.body)

    "#{response[:url]}&sipx_lms_token=#{response[:token]}"
  end


  def course_redirect_url(overwrite_url = false)
    request = connection.post(API_PATH, post_params('student'))
    response = parse_response(request.body)

    if overwrite_url
      "#{overwrite_url}#{overwrite_url.scan(/[?]/).present? ? '&' : '?'}sipx_lms_token=#{response[:token]}"
    else
      "#{response[:url]}&sipx_lms_token=#{response[:token]}"
    end
  end


  private

    def connection
      @connection ||= Faraday.new(:url => API_URL) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end


    def post_params(role = 'student')
      if !['student', 'instructor'].include?(role)
        raise "Invalid Role passed to post parmas"
      end

      {
        api_version: API_VERSION,
        userId: @current_user.username,
        userName: @current_user.display_name,
        emailAddress: @current_user.email,
        userRole: role,
        courseId: @course.id,
        courseName: @course.title,
        courseNumber: @course.crosslisted_course_number,
        courseStartDate: @course.semester.date_begin.to_s(:sipx),
        courseEndDate: @course.semester.date_end.to_s(:sipx),
        courseClassEnrollment: @course.enrollment_netids.size,
        returnParameters: RETURN_PARAMETERS,
        institution: INSTITUTION_ID,
        callerType: CALLER_TYPE,
        lmsId: lms_id,
        key: lms_key
      }
    end


    def lms_id
      if Rails.env == 'production'
        'Production'
      else
        'Development'
      end
    end


    def lms_key
      if Rails.env == 'production'
        'IpqrnsO1Ba0vPa4t9DQ+7dEtc5o0jKgxG+Ac/VJ5PV9SuST8ZLgmNskBPdE6eA0fgb877Fu3okw='
      else
        'IpqrnsO1Ba0vPa4t9DQ+7dEtc5o0jKgxG+Ac/VJ5PV9SuST8ZLgmNqqCVm0meFvEvkQAFeBDSfI='
      end
    end


    def parse_unused_text_out_of_body(body)
      body.gsub(/.*\n[*]{16}\n/, "")
    end


    def parse_response(body)
      body = parse_unused_text_out_of_body(body)
      body = body.split("\n")
      {
        token: body[0],
        url: body[1]
      }
    end
end
