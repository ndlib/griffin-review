class AdminFairUseForm
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :fair_use, :reserve

  delegate :can_approve?, :can_deny?, :can_send_to_council?, to: :fair_use
  delegate :id, :workflow_state, to: :reserve
  attribute :comments, String

  attribute :checklist, Hash
  attribute :event, String


  def initialize(current_user, params)
    @reserve = reserve_search.get(params[:id], nil)
    @fair_use = @reserve.fair_use
    @current_user = current_user

    self.checklist = @fair_use.checklist
    self.comments = @fair_use.comments

    if params[:admin_fair_use_form]
      self.attributes = params[:admin_fair_use_form]
    end

    ReserveCheckInprogress.new(@reserve).check!
  end


  def reserve_title
    @reserve.title
  end


  def reserve_id
    @reserve.id
  end


  def term_title
    @fair_use.semester.full_name
  end


  def save_fair_use
    if valid?
      persist!
      true
    else
      false
    end
  end


  def checklist_questions
    res = {}
    FairUseQuestion.active.each do | q |
      res[q.category] ||= { favoring: [], notfavoring: [] }
      if q.subcategory == 'Trending Toward Fair Use'
        res[q.category][:favoring] << q
      else
        res[q.category][:notfavoring] << q
      end
    end

    res
  end


  def question_checked?(question)
    checklist && checklist.has_key?(question.id.to_s) && checklist[question.id.to_s] == "true"
  end


  def previous_fair_uses
    @previous_fair_uses ||= @reserve.item.requests.where('id != ?', @reserve.id).order(:created_at).collect{ | r | Reserve.factory(r).fair_use }
  end


  def persisted?
    false
  end


  def state_transition_available?(state, transition)
    is_state?(state) || @fair_use.state_events.include?(transition.to_sym)
  end


  def is_state?(state)
    @fair_use.state == state
  end


  private

    def persist!
      @fair_use.user_id = @current_user.id
      @fair_use.comments = self.comments
      @fair_use.checklist = self.checklist

      if self.event
        @fair_use.send(self.event)
      end

      if @fair_use.denied?
        @fair_use.reserve.remove
        @fair_use.reserve.save!
      elsif @fair_use.reserve.removed?
        @fair_use.reserve.restart
        @fair_use.reserve.save!
      end

      @fair_use.save!

      ReserveCheckIsComplete.new(@fair_use.reserve).check!
    end


    def reserve_search
      @search ||= ReserveSearch.new
    end

end
