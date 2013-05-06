class InstructorReserveRequest < SimpleDelegator

  attr_accessor :reserve, :current_user

  def initialize(reserve, current_user)
    @reserve = reserve
    @current_user = current_user

    super(reserve)
  end




end
