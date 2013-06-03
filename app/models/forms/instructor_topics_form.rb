class InstructorTopicsForm
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :reserve, :current_user

  attribute :topics, String

  def initialize(current_user, reserve, request_attributes = {} )
    @current_user = current_user
    @reserve = reserve
    self.attributes = request_attributes
  end


  def available_topics
    @reserve.course.all_topics
  end


  def topic_checked?(topic)
    @reserve.topics.include?(topic)
  end


  def current_topics
    @reserve.topics
  end


  def save_topics
    if valid?
      persist!
      true
    else
      false
    end
  end


  private

  def persist!
    @reserve.set_topics!(self.topics)
  end

end
