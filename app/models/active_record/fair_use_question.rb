
class FairUseQuestion < ActiveRecord::Base

  validates :question, :ord, :category, presence: true

  scope :default_order, -> { order(:ord) }
  scope :active, -> { where(active: true).default_order }
  scope :further_questions, lambda{ | order | where("ord >= ? ", order).default_order }


  def deactivate!
    self.active = false
    self.save!
  end


  def reorder!(new_order)
    FairUseQuestion.push_back_order!(new_order)

    self.ord = new_order
    self.save!
  end


  def self.add_new_question!(question, category, order, favoring_fair_use = true, active = true)
    subcategory = favoring_fair_use ? 'Trending Toward Fair Use' : 'Trending Away From Fair Use'

    FairUseQuestion.push_back_order!(order)
    FairUseQuestion.create!(question: question, category: category, ord: order, active: active, subcategory: subcategory)
  end


  def self.push_back_order!(new_order)
    self.further_questions(new_order).each do | question |
      new_order += 1
      question.ord = new_order
      question.save!
    end
  end

end
