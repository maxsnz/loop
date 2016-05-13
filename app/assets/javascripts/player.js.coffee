#= require authorize

class Player
  data = {}


  @init = () ->
    Player.setState 'anonymous'
    ee.addListener('ui_AuthCtrl', @authController)


  sendAuth = (obj, forceStart) ->
    # stateController('auth_loading')
    console.log('sendAuth', obj)
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
        console.log('sendAuth success', data)
        Player.setState 'authorized'
        ee.emitEvent('PlayerCtrl', [ action:'authorized' ])
        Game.start() if forceStart
        Player.updateScore()
      error: (xhr, textStatus, error) ->
        stateController('auth_error')
        console.log xhr.responseJSON.errors


  @authController = (params, targetElement) ->
    Player.setState 'loading'
    forceStart = false
    forceStart = true if params.start
    switch params.provider
      when 'fb'
        Authorize.authorize.Fb().then (obj)->
          sendAuth(obj, forceStart)
      when 'vk'
        Authorize.authorize.Vk().then (obj)->
          sendAuth(obj, forceStart)
      when 'forcefb'
        Player.setState('loading')
        FB.login((login)->
          console.log 'FB.login', login
        )

    Player.setState 'anonymous' if params.action is 'back'

  @setState = (state) ->
    console.log('player state is '+state)
    $('.player-state').hide()
    $('.player-state.'+state).show()

  @updateScore = () ->
    Player.getPlayer (data) =>


  @getPlayer = (callback) ->
    $.ajax 
      type: 'GET'
      url: '/api/players/'+Player.data.provider+':'+Player.data.id
      success: (data) =>
        callback(data)
        return
      error: (xhr, textStatus, error) ->
        console.log xhr.responseJSON.errors
        callback({error:error})
        return

  @updateScore = () ->
    $('.player-position').addClass('loading')
    Player.getPlayer (data) =>
      $('.player-pic img').attr('src', data.picture)
      $('.player-score span').html(data.score)
      $('.player-place span').html(data.place)
      $('.player-name').html(data.name)
      $('.player-position').removeClass('loading')

window.Player = Player
