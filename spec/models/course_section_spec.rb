require 'spec_helper'


describe CourseSection do

  before(:each) do
    @semester = FactoryBot.create(:semester, :code => default_data[:term])
    @course_section = CourseSection.factory('crosslist_id', default_data)
  end

  it "sets an id" do
    expect(@course_section.id).to eq("section_id")
  end

  it "has a supersection_id" do
    expect(@course_section.supersection_id).to eq("supersection_id")
  end

  it "sets a triple" do
    expect(@course_section.triple).to eq("course_triple")
  end

  it "has a crosslist_id " do
    expect(@course_section.crosslist_id).to eq("crosslist_id")
  end

  it "has a title" do
    expect(@course_section.title).to eq("course_title")
  end

  it "has a full_title" do
    expect(@course_section.full_title).to eq("course_title - #{@course_section.semester.name}")
  end

  it "has a section number" do
    expect(@course_section.section_number).to eq(1)
  end

  it "has enrollment_netids" do
    expect(@course_section.enrollment_netids).to eq(["student1", "student2"])
  end

  it "has instructor_ids" do
    expect(@course_section.instructor_netids).to eq(["netid"])
  end

  it "has a term " do
    expect(@course_section.term).to eq('term')
  end

  it "has a semester" do
    expect(@course_section.semester).to eq(@semester)
  end

  it "has a alpha_prefix" do
    expect(@course_section.alpha_prefix).to eq('alpha_prefix')
  end

  def default_data
    {
      section_id: "section_id",
      supersection_id: "supersection_id",
      instructors: [
        {
          id: "netid",
          identifier_contexts: {
            ldap: "uid",
            staff_directory: "email"
          },
          identifier: "by_netid",
          netid: "netid",
          first_name: "Marisel",
          last_name: "Moreno-Anderson",
          full_name: "Marisel Moreno-Anderson",
          ndguid: "nd.edu.ndsk3qr4",
          position_title: "Fellow",
          campus_department: "Kellogg Institute for International Studies",
          primary_affiliation: "Faculty",
          contact_information: {
            campus_address: "343 O'Shaughnessy Hall&#10;Notre Dame, IN 46556-5639",
            email: "Marisel.C.Moreno-Anderson.1@nd.edu",
            phone: "+1 574 631 6737"
          }
        }
      ],
    term: "term",
    course_triple: "course_triple",
    course_title: "course_title",
    alpha_prefix: "alpha_prefix",
    number: 73947,
    section_number: 1,
    crn: "19290",
    enrollments: [
      "student1", "student2"
      ]
    }
  end
end
