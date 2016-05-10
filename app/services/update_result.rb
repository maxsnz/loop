class UpdateResult
  include CallableClass

  attr_reader :result, :score

  def initialize(result, score)
    @result = result
    @result.score = score.to_i
  end

  def call
    result.seconds = (Time.now.to_f - result.start).round(2)

    method = "answer_correctly" # если все ок
    if (result.score > result.seconds * 20) || (result.seconds > 1000000 * 10) || (result.seconds < 0) # TODO поменять минимальное время
      method = "answer_reject"
      result.score = 0
    end


    result.send(method)
  end
end
