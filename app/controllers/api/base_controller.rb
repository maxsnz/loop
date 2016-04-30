class Api::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token

  private

  def render_json(json, options = {})
    render({json: json, callback: params[:callback]}.merge(options))
  end

  def find_or_create_token
    params[:user_id].present? && params[:token].present? && FindOrCreateToken.call(params[:user_id], params[:token])
  end
end
