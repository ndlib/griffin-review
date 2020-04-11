class Request < ActiveRecord::Base
  belongs_to :semester
  belongs_to :item
  has_many :message, dependent: :destroy

  validates :semester, :course_id, :requestor_netid, :item, :presence => true

  before_save :set_sortable_title

  def primary_title
    if item_selection_title.present?
      item_selection_title
    else
      item_title
    end
  end

  private

  def set_sortable_title
    self.sortable_title = SortableTitleConverter.convert(primary_title)
  end
end
