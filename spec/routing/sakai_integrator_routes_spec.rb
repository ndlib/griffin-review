require 'spec_helper'

describe "Sakai Integrator Routes" do
  it "routes to sakai integrator via post" do
    { post: "/sakai" }.
      should route_to(
        controller: "sakai_integrator",
        action: "sakai_redirect"
      )
  end
end
