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
    @reserve.set_topics!(self.topcs)
  end

end
