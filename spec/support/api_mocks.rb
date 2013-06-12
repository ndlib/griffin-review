module ApiMocks

  def stub_courses!

    puts 'stubbing !!'
    API::Person.stub!(:courses) do  | netid, semester |
      path = File.join(Rails.root, "spec/fixtures/json_save/", "#{netid}_#{semester}.json")
      file = File.open(path, "rb")
      contents = file.read

      ActiveSupport::JSON.decode(contents)["people"].first
    end


    API::CourseSearchApi.stub!(:course_id) do | course_id |
      begin
        path = File.join(Rails.root, "spec/fixtures/json_save/get_course", "#{course_id}.json")
        file = File.open(path, "rb")
        contents = file.read

        ActiveSupport::JSON.decode(contents)
      rescue Errno::ENOENT
        nil
      end
    end


    API::CourseSearchApi.stub!(:course_by_section_id) do | term_code, section_id |
      path = File.join(Rails.root, "spec/fixtures/json_save/course_by_section", "#{term_code}-#{section_id}.json")

      file = File.open(path, "rb")
      contents = file.read

      ActiveSupport::JSON.decode(contents)
    end

  end


  def stub_discovery!
    API::Resource.stub!(:search_catalog) do | id |
      path = File.join(Rails.root, "spec/fixtures/json_save/discovery", "generic.json")
      file = File.open(path, "rb")
      contents = file.read

      ActiveSupport::JSON.decode(contents)["records"].first
    end
  end


  def mock_reserve(request, course)
    Reserve.factory(request, course)
  end
end