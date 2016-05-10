#= require authorize

class Player
  data = {}


  @init = () ->
    Player.setState 'anonymous'
    ee.addListener('ui_AuthCtrl', @authController)


  sendAuth = (obj) ->
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
        Game.start()
        # Player.updateScore()
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
    console.log('player state is '+state)
    $('.player-state').hide()
    $('.player-state.'+state).show()

  @updateScore = () ->
    # Player.getPlayer (data) =>


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
    

window.Player = Player
