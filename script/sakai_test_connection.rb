#!/Users/rfox2/.rvm/rubies/ruby-1.9.3-p362/bin/ruby

require 'savon'

response = soap_call(soap_auth)

BEGIN {


  def soap_call(session_id)
    client = Savon.client(wsdl: "https://nd-dev.rsmart.com/sakai-axis/SakaiScript.jws?wsdl")
    site_id = "4a970344-3170-4e4b-ab36-e80f0244cb16"
    response = client.call(:get_site_property) do
      message sessionid: session_id, site_id: site_id, propname: 'externalSiteId'
    end
  end

  
  def soap_auth
    client = Savon.client(wsdl: "https://nd-dev.rsmart.com/sakai-axis/SakaiLogin.jws?wsdl")
    response = client.call(:login) do
      message id: 'hesburgh', pw: 'funkyCh1ck3n'
    end

    return response.body[:login_response][:login_return]
  end

}
