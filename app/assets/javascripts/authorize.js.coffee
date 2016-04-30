class Authorize

  @authorize = {}


  getFbLoginStatus = ->
    deferred = $.Deferred()
    FB.getLoginStatus (status)->
      if status.status == 'connected'
        deferred.resolve status
        return
      else
        FB.login((login)->
           if login.authResponse
              deferred.resolve login
              return
           else
              deferred.reject status.status
              return
        {scope: 'email'})
        return
    return deferred.promise()


  getFbUserInfo = ->
    deferred = $.Deferred()
    FB.api '/me', (me)->
      deferred.resolve me
      return
    return deferred.promise()


  @authorize.Fb = ->
    deferred = $.Deferred()
    _user = {}
    _user.provider = 'fb'

    getFbLoginStatus().then((status)->
      _user.token = status.authResponse.accessToken
      return getFbUserInfo()
    (error)->
      deferred.reject error
      return
    ).then (user)->
      if user?
        _user.name = user.name
        # _user.id = parseInt(user.id)
        _user.id = user.id
        _user.photo = 'https://graph.facebook.com/' + _user.id + '/picture'
        if user.email?
          _user.email = user.email
        deferred.resolve _user
        # console.log user, _user
        return

    return deferred.promise()


  getVkLoginStatus = ->
    deferred = $.Deferred()
    VK.Auth.login (status)->
       if status.session
          deferred.resolve status
          return
       else
          deferred.reject 'disconnected'
          return

    return deferred.promise()

  @authorize.Vk = ->
    deferred = $.Deferred()
    _user = {}
    _user.provider = 'vk'

    getVkLoginStatus().then((status)->
      _user.token = status.session.sig + ',' + status.session.expire + ',' + status.session.mid + ',' + status.session.sid
      _user.name = status.session.user.first_name + ' ' + status.session.user.last_name
      _user.id = parseInt(status.session.user.id)
      
      $.getJSON 'https://api.vk.com/method/users.get?user_id=' + _user.id + '&fields=photo&callback=?', (data) ->
        _user.photo = data.response[0].photo if data.response
        deferred.resolve _user
      
      return
    (error)->
       deferred.reject error
       return
    )

    return deferred.promise()

window.Authorize = Authorize