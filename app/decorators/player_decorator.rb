# encoding: UTF-8
class PlayerDecorator < Draper::Decorator

  def player
    social = model.uid.split(":")[0]
    uid = model.uid.split(":")[1]
    url = ''
    if social == 'fb'
      url = 'http://facebook.com/'+uid
    end
    if social == 'vk'
      url = 'http://vk.com/id'+uid
    end
    h.link_to model.name, url, :target => "_blank"
  end


  def picture
    h.image_tag model.picture
  end
  def score
    model.score
    # model.results.where(:state => Result::DONE).sum(:score)
  end
  def attempts
    url = '/admin/results?q[player_id_eq]='+model.id.to_s
    a = model.results.where(:state => Result::DONE).length
    h.link_to a, url, :target => "_blank"
  end
  def created_at
    model.created_at.strftime("%d.%m.%Y  %H:%M ")
  end
  
end
