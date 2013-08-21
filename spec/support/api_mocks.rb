module ApiMocks

  def stub_courses!

    API::Person.stub(:courses) do  | netid, semester |
      begin
        path = File.join(Rails.root, "spec/fixtures/json_save/", "#{netid}_#{semester}.json")
        file = File.open(path, "rb")
        contents = file.read

        ActiveSupport::JSON.decode(contents)["people"].first
      rescue Errno::ENOENT
        {
          'enrolled_courses' => [],
          'instructed_courses' => []
        }
      end
    end


    API::CourseSearchApi.stub(:course_id) do | course_id |
      begin
        path = File.join(Rails.root, "spec/fixtures/json_save/get_course", "#{course_id}.json")
        file = File.open(path, "rb")
        contents = file.read

        ActiveSupport::JSON.decode(contents)
      rescue Errno::ENOENT
        nil
      end
    end


    API::CourseSearchApi.stub(:search) do |  term_code, search |
      begin
        path = File.join(Rails.root, "spec/fixtures/json_save/search_course", "#{search}.json")
        file = File.open(path, "rb")
        contents = file.read

        ActiveSupport::JSON.decode(contents)
      rescue
        []
      end
    end

  end


  def stub_discovery!
    API::Resource.stub(:search_catalog) do | id |
      path = File.join(Rails.root, "spec/fixtures/json_save/discovery", "generic.json")
      file = File.open(path, "rb")
      contents = file.read

      ActiveSupport::JSON.decode(contents)["records"].first
    end
  end


  def stub_ssi!
    ApplicationController.any_instance.stub(:include_ssi).and_return("SSI INCLUDE!!!!")
  end


  def turn_on_ldap!
    Rails.configuration.stub(:ldap_lookup_flag).and_return(true)
  end


  def mock_reserve(request, course)
    if !course.nil?
      request.course_id = course.id
      request.crosslist_id = course.crosslist_id
      request.save!
    end

    Reserve.factory(request, course)
  end

end
