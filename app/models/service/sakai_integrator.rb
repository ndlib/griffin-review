class SakaiIntegrator


  def initialize(controller)
    @controller = controller
  end

  private


  def soap_call(session_id)
    client = Savon.client(wsdl: Rails.configuration.sakai_script_wsdl)
    site_id = "4a970344-3170-4e4b-ab36-e80f0244cb16"
    response = client.call(:get_site_property) do
      message sessionid: session_id, site_id: site_id, propname: 'externalSiteId'
    end
  end

  
  def soap_auth
    client = Savon.client(wsdl: Rails.configuration.sakai_login_wsdl)
    response = client.call(:login) do
      message id: ENV["SAKAI_ADMIN_USERNAME"], pw: ENV["SAKAI_ADMIN_PASSWORD"]
    end

    return response.body[:login_response][:login_return]
  end

end
