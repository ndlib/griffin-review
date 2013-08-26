class Reserve
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Callbacks

  delegate :display_length, :language_track, :subtitle_language, :metadata_synchronization_date, :on_order, :on_order?, :details, :type, :publisher, :title, :journal_title, :creator, :length, :url, :nd_meta_data_id, :overwrite_nd_meta_data, :overwrite_nd_meta_data?, to: :item
  delegate :display_length=, :language_track=, :subtitle_language=, :metadata_synchronization_date=, :on_order=, :details=, :type=, :publisher=, :title=, :journal_title=, :creator=, :length=, :pdf, :pdf=, :url=, :nd_meta_data_id=, :overwrite_nd_meta_data=, :overwrite_nd_meta_data=, to: :item
  delegate :details, :available_library, :availability, :publisher_provider, :creator_contributor, to: :item

  delegate :created_at, :id, :semester, :workflow_state, :course_id, :crosslist_id, :requestor_netid, :needed_by, :number_of_copies, :note, :requestor_owns_a_copy, :library, :requestor_netid, to: :request
  delegate :id=, :semester=, :workflow_state=, :course_id=, :requestor_netid=, :needed_by=, :number_of_copies=, :note=, :requestor_owns_a_copy=, :library=, :requestor_netid=, to: :request

  attr_accessor :course, :request
  attr_accessor :requestor_has_an_electronic_copy
  attr_accessor :fair_use, :requestor

  state_machine :workflow_state, :initial => :new do

    event :complete do
      transition [:new, :inprocess] => :available
    end


    event :remove do
      transition [:new, :inprocess, :available] => :removed
    end


    event :start do
      transition [:new] => :inprocess
    end


    event :restart do
      transition [:available] => :inprocess
    end

    state :new
    state :inproess
    state :available
    state :removed
  end


  def self.factory(request, course = nil)
    self.new(request: request, course: course)
  end


  def initialize(attrs = {})
    self.attributes= attrs

    # this is required for the state_machine gem do not forget again and remove
    super()

    if !self.request.new_record?
      ReserveSynchronizeMetaData.new(self).check_synchronized!
    end
  end


  def attributes=(attrs= {})
    attrs.keys.each do  | key |
      self.send("#{key}=", attrs[key])
    end
  end


  def title
    if !self.overwrite_nd_meta_data? && @item.display_length.present?
      "#{@item.title} - #{@item.display_length}"
    else
      "#{@item.title}"
    end
  end


  def item
    @item ||= (request.item || request.build_item)
  end


  def item_id
    item.id
  end


  def requestor_name
    if requestor_netid == 'import'
      return "imported"
    end

    @user ||= requestor
    if !@user
      return ""
    end

    @user.display_name
  end


  def requestor
    @user ||= User.where(:username => self.requestor_netid).first
  end


  def request
    @request ||= Request.new
  end


  def save!
    ActiveRecord::Base.transaction do
      item.save!

      request.item = item
      request.course_id = course.id
      request.crosslist_id = course.crosslist_id
      request.semester_id = course.semester.id

      request.save!

      ReserveCheckIsComplete.new(self).check!
    end
  end


  def destroy!
    if self.remove
      self.save!
    end
  end


  def set_topics!(topics)
    request.topic_list = topics
    save!
  end


  def topics
    request.topics
  end


  def persisted?
    false
  end


  def course
    @course ||= CourseSearch.new.get(self.course_id)
  end


  def fair_use
    @fair_use ||= ( FairUse.request(self).first || FairUse.new(request: request) )
  end


end

