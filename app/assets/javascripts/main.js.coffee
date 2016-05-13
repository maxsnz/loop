#= require jquery2
#= require lodash.compat.min
#= require wheel-indicator.js
#= require spin.min
#= require EventEmitter.min
#= require userinterface
#= require navigation
#= require player
#= require rating
#= require game



$ ->
  window.ee = new EventEmitter()
  Navigation.init({currentScreen:'main'})
  # Navigation.openPopup('pause')
  Player.init()
  Rating.init()
  Game.init()

  startIndicator = new WheelIndicator(
    elem: document.querySelector('.screen_main')
    callback: (e) ->
      if e.direction is 'down'
        ee.emitEvent('app_NavPopupCtrl', [ {action:'open', popup:"start"}, null ])
        startIndicator.destroy()
  )

  spin_opts = {lines: 12, length: 6, width: 3, radius: 8, corners: 0.9, rotate: 0, color: '#213767', speed: 1, trail: 49, shadow: false, hwaccel: false, className: 'spinner', zIndex: 2e9, top: '50%', left: '50%'}
  $('.auth-player-loader').each ->
    loader = new Spinner(spin_opts).spin $(@)[0]

  $('.where-is-auth-button').click (e) ->
    e.preventDefault()
    $b = $(@).parent().find('.buttons-container')
    $b.addClass('anonse')
    setTimeout(->
      $b.removeClass('anonse')
    , 500)
