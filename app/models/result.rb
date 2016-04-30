class Result < ActiveRecord::Base
  attr_accessor :correct_answers

  self.per_page = 200

  belongs_to :player#, autosave: true
  # belongs_to foreign_key: :n, primary_key: :n #TODO
  PENDING   = 'pending'
  DONE   = 'done'
  REJECT     = 'reject'

  TRANSITIONS = {
    answer_correctly: [PENDING, DONE],
    answer_reject: [PENDING, REJECT]
  }

  state_machine initial: PENDING do
    TRANSITIONS.each do |event_name, transitions|
      event event_name do
        transition transitions[0] => transitions[1]
      end
    end
  end

  validates_presence_of :player
  validates_associated :player


  # это про победителей
  scope :board, -> { with_state(DONE).order(:score).preload(:player) }
  
  def as_json(options = {})
    {
      name: player.name,
      seconds: seconds,
      date: I18n.l(updated_at, format: :list)
    }.merge(options[:place] ? { place: options[:place] } : { score: score })
  end

  private

end
