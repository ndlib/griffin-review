class Item < ActiveRecord::Base

  has_many :requests

  validates :title, :type, presence: true

  self.inheritance_column = nil

  has_attached_file :pdf, { :path => ":rails_root/uploads/pdfs/:id/:filename" }


  def creator_contributor
    self.creator
  end


  def publisher_provider
    self.journal_title
  end

end
