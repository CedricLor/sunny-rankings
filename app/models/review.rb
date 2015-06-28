class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :firm
  has_many :answers
  accepts_nested_attributes_for :answers

  def contains_sensitive_answers
    response = { sensitive: false, count: 0}
    answers.each do | answer |
      if answer.sensitive
        response[:sensitive] = true
        response[:count] += 1
      end
    end
    response
  end
end
