class ApplicationController < ActionController::Base

  # def mobile_device?
  #    (request.user_agent =~ /(iPhone|iPod|Android|webOS|Mobile)/) && (request.user_agent !~ /iPad/)
  # end

  # helper_method :mobile_device?

  protect_from_forgery

  protected
  def authenticate_basic
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "Areyouaspy?"
    end
  end

  def allow_xframe
    response.headers.except! 'X-Frame-Options'
  end
end
