class SakaiContextCache < ActiveRecord::Base

  self.table_name = 'sakai_context_cache'

  validates :context_id, :external_id, :course_id, :user_id, :term, presence: true

  scope :by_term, lambda { | term_id | where(term: term_id) }

end
