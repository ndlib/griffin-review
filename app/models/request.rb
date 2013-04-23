class Request < VideoWorkflow

  attr_accessor :extent, :cms

  #extras to be replaced when the schema is finalized.
  attr_accessor :requestor_owns_a_copy, :number_of_copies, :creator
  attr_accessor :length

  belongs_to :semester
  belongs_to :user

  validates_presence_of :title, :needed_by, :course, :user, :semester
  validates :cms, :inclusion => { :in => %w(vista_concourse sakai_concourse both_concourse), :message => "CMS choice required" }, :on => :create
  validates_presence_of :extent, :message => 'Please indicate whether you need clips or the entire video', :on => :create
  validates_presence_of :cms, :message => 'CMS choice required', :on => :create
  validates :course, :format => { :with => /^(FA|SP|SU)[1-2][0-9] [A-Z]{1,10} [0-9]{1,10} ([A-Z,0-9]{2,4}|[0-9]{2})$/i,
    :message => "Course string should match pattern similar to FA12 BUS 3023 01" }
  validates_date :needed_by, :on_or_after => lambda { Date.current }



end
