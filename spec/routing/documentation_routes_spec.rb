require 'spec_helper'

describe "Documentation Routes" do
  it "routes to documentation via get" do
    { get: "/documentation" }.
      should route_to(
        controller: "documentation",
        action: "index"
      )
  end
end
