
class FairUseQuestion < ActiveRecord::Base

  validates :question, :ord, :category, presence: true

  scope :order, order(:ord)
  scope :active, where(active: true).order
  scope :further_questions, lambda{ | order | where("ord >= ? ", order).order }


  def deactivate!
    self.active = false
    self.save!
  end


  def reorder!(new_order)
    FairUseQuestion.push_back_order!(new_order)

    self.ord = new_order
    self.save!
  end


  def self.add_new_question!(question, category, order, active = true)
    FairUseQuestion.push_back_order!(order)
    FairUseQuestion.create!(question: question, category: category, ord: order, active: active)
  end


  def self.push_back_order!(new_order)
    self.further_questions(new_order).each do | question |
      new_order += 1
      question.ord = new_order
      question.save!
    end
  end

end
