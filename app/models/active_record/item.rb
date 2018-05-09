class Item < ActiveRecord::Base

  has_many :requests
  has_one :media_playlist

  validates :title, :type, presence: true
  do_not_validate_attachment_file_type :pdf
  before_save :normalize_url, :on => :save

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

  private

  # Takes standard Leganto citation and strips irrelevant prefix
  # and stores the id.
  # initial url: citation_id=1456343252335
  # normalized url:  1456343252335
  def normalize_url
    if !self.url.blank? and self.url.include? "="
      self.url = self.url.split('=').at(1)
    end
  end

end