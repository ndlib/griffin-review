require 'spec_helper'

describe AdminController do

  context "Semester Administration" do
    describe "list of semesters" do
      it "shows a list of all semesters in the system"
      it "shows the three active semesters via a filter"
      it "provides a link to all requests for a semester"
      it "provides an edit link for each semester"
    end
    describe "GET #new" do
      it "assigns a new semester to @semester"
      it "renders the :new template"
    end
    describe "GET #edit" do
      it "assigns the requested semester to @semester"
      it "renders the :edit template"
    end
  end

end
