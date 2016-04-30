class Player
  data = {}


  @init = () ->
    Player.setState 'anonymous'
    ee.addListener('ui_AuthCtrl', @authController)


  sendAuth = (obj) ->
    # stateController('auth_loading')
    Player.data = obj
    $.ajax 
      type: 'POST'
      url: '/api/players'
      data: {
        user_id: Player.data.id
        token: Player.data.token
        name: Player.data.name
        email: Player.data.email
        picture: Player.data.photo
      }
      success: (data) =>  
        if data.limit > 0
          Player.setState 'authorized'
        else
          Player.setState 'toomuch' 
        ee.emitEvent('PlayerCtrl', [ action:'authorized' ])
        Player.updateScore()
      error: (xhr, textStatus, error) ->
        stateController('auth_error')
        console.log xhr.responseJSON.errors


  @authController = (params, targetElement) ->
    Player.setState 'loading'
    switch params.provider
      when 'fb'
        Authorize.authorize.Fb().then (obj)->
          sendAuth(obj)
      when 'vk'
        Authorize.authorize.Vk().then (obj)->
          sendAuth(obj)

    Player.setState 'anonymous' if params.action is 'back'

  @setState = (state) ->
    $('.player-state').hide()
    $('.player-state.'+state).show()

  @updateScore = () ->
    $('.player-position').addClass('loading')
    Player.getPlayer (data) =>
      $('.player-pic img').attr('src', data.picture)
      $('.player-score span').html(data.score)
      $('.player-place span').html(data.place)
      $('.player-name').html(data.name)
      $('.player-position').removeClass('loading')
      # console.log 'update score', data.limit
      unless (data.limit > 0) 
        $('.rotate-near-tryanotherone, .tryanotherone').remove()
        Player.setState 'toomuch'

  @getPlayer = (callback) ->
    $.ajax 
      type: 'GET'
      url: '/api/players/'+Player.data.provider+':'+Player.data.id
      success: (data) =>
        callback(data)
        return
      error: (xhr, textStatus, error) ->
        console.log xhr.responseJSON.errors
        callback(player)
        return
    

window.Player = Player
