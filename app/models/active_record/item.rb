class Item < ActiveRecord::Base

  has_many :requests
  has_one :media_playlist

  validates :title, :type, presence: true

  self.inheritance_column = nil

  has_attached_file :pdf, { :path => ":rails_root/uploads/pdfs/:id/:filename" }

  store :description, accessors: [ :subtitle_language, :language_track ]

  def creator_contributor
    if !self.creator.blank? and !self.contributor.blank?
      self.creator + ", " + self.contributor
    elsif !self.creator.blank?
      self.creator
    elsif !self.contributor.blank?
      self.contributor
    else
      ""
    end
  end


  def publisher_provider
    self.journal_title
  end

end
