class Request < VideoQueue

  validates_presence_of :title, :needed_by, :course
  validates :course, :format => { :with => /^(FA|SP|SU)[1-2][0-9] [A-Z]{1,10} [0-9]{1,10} ([A-Z,0-9]{2,4}|[0-9]{2})$/,
    :message => "Course code should match pattern similar to FA12 BUS 3023 01" }
end
