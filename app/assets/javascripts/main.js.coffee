#= require jquery2
#= require wheel-indicator.js
#= require EventEmitter.min
#= require userinterface
#= require navigation
#= require game



$ ->
  window.ee = new EventEmitter()
  Navigation.init({currentScreen:'main'})
  Game.init()

  startIndicator = new WheelIndicator(
    elem: document.querySelector('.screen_main')
    callback: (e) ->
      if e.direction is 'down'
        ee.emitEvent('app_NavPopupCtrl', [ {action:'open', popup:"start"}, null ])
        startIndicator.destroy()
  )

  $('.where-is-auth-button').click (e) ->
    e.preventDefault()
    $b = $(@).parent().find('.buttons-container')
    $b.addClass('anonse')
    setTimeout(->
      $b.removeClass('anonse')
    , 500)
