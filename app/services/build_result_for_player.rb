class BuildResultForPlayer
  def self.call(player)
    Result.new(player: player, state: Result::PENDING, start: Time.now.to_f, score: 0)
  end
end
