require 'securerandom'
require 'erb'
require 'base64'
require 'openssl'

include ERB::Util

class LtiConnection

  attr_reader :launch_data
  attr_reader :launch_url

  def initialize(course, lti_citation, current_user)

    @launch_url = "https://na01.alma.exlibrisgroup.com/lti/launch"

    @launch_data = {}
    @launch_data["ext_user_email"] = current_user.email
    @launch_data["ext_user_firstname"] = current_user.first_name
    @launch_data["ext_user_lastname"] = current_user.last_name
    @launch_data["ext_user_username"] = current_user.username.downcase
    @launch_data["custom_lis_course_id"] = course.id
    if ! lti_citation.to_s.empty?
      @launch_data["citation_id"] = lti_citation
    end
    @launch_data["institute"] = "01NDU_INST"
    @launch_data["tool"] = "LMS_OTHER_1"
    @launch_data["oauth_callback"] = "about:blank"
    @launch_data["oauth_consumer_key"] = get_consumer_key
    @launch_data["oauth_version"] = "1.0"
    @launch_data["oauth_nonce"] = Base64.encode64(OpenSSL::Random.random_bytes(16)).gsub(/\W/, '')
    @launch_data["oauth_timestamp"] = Time.now.to_i.to_s
    @launch_data["oauth_signature_method"] = "HMAC-SHA1"
    @launch_data["lti_version"] = "LTI-1p0"
    @launch_data["lti_message_type"] = "basic-lti-launch-request"
    signature = generate_signature
    @launch_data["oauth_signature"] = signature
  end

  private

  def get_secret_key
    Rails.application.secrets.leganto["secret"]
  end

  def get_consumer_key
    Rails.application.secrets.leganto["consumer"]
  end

  def generate_signature
    @launch_data = @launch_data.sort.to_h
    base_string = "POST&" + url_encode(@launch_url)
    counter = 0
    @launch_data.each {
      |key, value|
      params = "#{key}=" + url_encode("#{value}")
      if counter == 0
        base_string += "&" + url_encode(params)
      else
        base_string += url_encode("&" + params)
      end
      counter += 1
    }
    Base64.encode64("#{OpenSSL::HMAC.digest('sha1', url_encode(get_secret_key) + "&", base_string)}").chomp
  end
end