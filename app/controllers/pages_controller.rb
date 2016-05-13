class PagesController < ApplicationController

  # def check_for_mobile
  #   session[:mobile_override] = params[:mobile] if params[:mobile]
  #   prepare_for_mobile if mobile_device?
  # end

  # def gallery
  #   if mobile_device?
  #     render(:layout => "layouts/gallery_mobile")
  #   else
  #     render(:layout => "layouts/gallery")
  #   end
  # end

  def index
    render(:layout => "layouts/main")
  end

  def result
    render(:layout => "layouts/result")
  end





  private

end
