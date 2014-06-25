class SakaiContextCache < ActiveRecord::Base

  self.table_name = 'sakai_context_cache'

  validates :context_id, :course_id, presence: true

  scope :by_term, lambda { | term_id | where(term: term_id) }

end
