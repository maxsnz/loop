# encoding: UTF-8
class ResultDecorator < Draper::Decorator

  def player
    social = Player.find(model.player_id).uid.split(":")[0]
    uid = Player.find(model.player_id).uid.split(":")[1]
    url = ''
    if social == 'fb'
      url = 'http://facebook.com/'+uid
    end
    if social == 'vk'
      url = 'http://vk.com/id'+uid
    end
    h.link_to Player.find(model.player_id).name, url, :target => "_blank"
  end


  def seconds
    model.seconds
  end
  def score
    model.score
  end
  def created_at
    model.created_at.strftime("%d.%m.%Y  %H:%M ")
  end
  
end
