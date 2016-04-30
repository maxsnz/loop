class Player < ActiveRecord::Base
  has_many :results

  validates :uid, presence: true, uniqueness: true
  validates_presence_of :name

  # scope :board, -> { order(:score) }
  
  def as_json(options = {})
    {
      name: name,
      score: score
    }#.merge(options[:place] ? { place: options[:place] } : { score: score })
  end

end
