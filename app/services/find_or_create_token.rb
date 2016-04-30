class FindOrCreateToken
  include CallableClass

  attr_reader :id, :token

  def initialize(id, token)
    @id = id
    @token = token
  end

  def checker
    @checker ||= TokenChecker.new(id, token)
  end

  def attrs
    checker.attributes
  end

  def find
    Token.where(attrs).first
  end

  def call
    find || (checker.valid? && Token.create(attrs))
  end
end
