class UpdateResult
  include CallableClass

  attr_reader :result

  def initialize(result)
    @result = result
  end

  def call
    result.seconds = (Time.now.to_f - result.start).round(2)

    method = "answer_correctly" # если все ок
    if (result.seconds > 100 * 10) || (result.seconds < 0) # TODO поменять минимальное время
      method = "answer_reject"
      result.score = 0
    end


    result.send(method)
  end
end
