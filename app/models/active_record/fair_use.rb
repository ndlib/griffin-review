class FairUse < ActiveRecord::Base
#  has_paper_trail

  store :fair_uses, accessors: [ :checklist ]

  validates :user_id, presence: true

  belongs_to :user
  belongs_to :request

  scope :request, lambda { | request | where(request_id: request.id).order("created_at") }
  scope :by_item, lambda { | item | where(item_id: item.id) }

  # the state_machine gem is no longer maintained and initial values are broken in rails 4.2. This is a work around.
  # see https://github.com/pluginaweek/state_machine/issues/334
  after_initialize :set_initial_status
  def set_initial_status
    self.state ||= :update
  end

  state_machine :state, :initial => :update do

    event :approve do
      transition [ :denied, :update, :temporary_approval, :copy_rights_cleared, :sipx_cleared ] => :approved
    end


    event :clear_with_sipx do
      transition [ :denied, :update, :temporary_approval, :approved, :copy_rights_cleared, :sipx_cleared ] => :sipx_cleared
    end


    event :clear_with_copy_rights do
      transition [ :denied, :update, :temporary_approval, :approved, :copy_rights_cleared, :sipx_cleared ] => :copy_rights_cleared
    end


    event :deny do
      transition [ :update, :approved, :temporary_approval, :copy_rights_cleared, :sipx_cleared ] => :denied
    end

    event :temporary_approval do
      transition [ :sipx_cleared, :copy_rights_cleared, :approved, :denied, :update ] => :temporary_approval
    end

    state :update
    state :temporary_approval
    state :approved
    state :copy_rights_cleared
    state :sipx_cleared
    state :denied
  end


  def copy_to_new_request!(new_request, current_user)
    new_fair_use = self.dup

    new_fair_use.comments = ""
    new_fair_use.state    = "update"
    new_fair_use.request  = new_request
    new_fair_use.user     = current_user

    new_fair_use.save!

    new_fair_use
  end


  def semester
    request.semester
  end


  def reserve
    Reserve.factory(request)
  end


  def complete?
    (state != 'update')
  end

end
