module ApiMocks

  def stub_discovery!
    API::Resource.stub(:search_catalog) do | id |
      path = File.join(Rails.root, "spec/fixtures/json_save/discovery", "generic.json")
      file = File.open(path, "rb")
      contents = file.read

      ActiveSupport::JSON.decode(contents)["records"].first
    end
  end

  def turn_on_ldap!
    Rails.configuration.stub(:ldap_lookup_flag).and_return(true)
  end


  def mock_reserve(request, course)
    if !course.nil?
      request.course_id = course.id
      request.save!
    end

    Reserve.factory(request, course)
  end

end
