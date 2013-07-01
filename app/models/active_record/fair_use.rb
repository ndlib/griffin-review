class FairUse < ActiveRecord::Base
  has_paper_trail

  store :fair_uses, accessors: [ :checklist ]

  validates :user_id, presence: true

  belongs_to :user
  belongs_to :request

  scope :request, lambda { | request | where(request_id: request.id).order("created_at") }
  scope :by_item, lambda { | item | where(item_id: item.id) }

  state_machine :state, :initial => :update do

    event :send_to_council do
      transition [:update] => :awaiting_council
    end

    event :approve do
      transition [:update, :awaiting_council] => :approved
    end

    event :deny do
      transition [:update, :approved, :awaiting_council] => :denied
    end

    state :update
    state :awaiting_council
    state :approved
    state :denied
  end


  def copy_to_new_request!(new_request, current_user)
    new_fair_use = self.dup

    new_fair_use.comments = ""
    new_fair_use.state = "update"
    new_fair_use.request = new_request
    new_fair_use.user = current_user

    new_fair_use.save!

    new_fair_use
  end


  def semester
    request.semester
  end


  def complete?
    (state == 'approved' || state == 'denied')
  end
end
