class TokenChecker
  attr_reader :id, :token

  def initialize(id, token)
    @id = id.to_s
    @token = token.to_s
    raise(ArgumentError, "invalid id: #{@id}") if @id !~ /\A\d+\Z/
  end

  def attributes
    {uid: uid, token: token}
  end

  def uid
    "#{prefix}#{id}"
  end

  def valid?
    if vkontakte?
      sig, expire, mid, sid = token.split(',')
      sig == Digest::MD5.hexdigest("expire=#{expire}mid=#{mid}secret=oauthsid=#{sid}#{Rails.configuration.vk_secret}") && mid == id
    else
      begin
        user = Koala::Facebook::API.new(token).get_object("me")
        user["id"] == id
      rescue Koala::Facebook::AuthenticationError
        false
      end
    end
  end

  private

  def vkontakte?
    token.include? ","
  end

  def prefix
    vkontakte? ? "vk:" : "fb:"
  end
end
