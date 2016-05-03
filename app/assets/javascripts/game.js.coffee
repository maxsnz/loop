#= require requestAnimationFrame.js

class Game
  score = 0
  arrScrolls = [0]
  currentV = 0
  bgp = 0
  cp = 0
  config = {
    t:10
  }

  gamePaused = () ->
    console.log('gamePaused')

  animate = () ->
    requestAnimationFrame( animate )
    render()

  render = ->
    if arrScrolls.length > 2
      currentTime = new Date()
      lastTime = arrScrolls[arrScrolls.length-1]
      lastlastTime = arrScrolls[arrScrolls.length-2]
      deltaT = (currentTime - lastTime)/1000  
      
      if deltaT > 1
        currentV = currentV - 2 if currentV > 0
        currentV = 0 if currentV < 0
      else if deltaT > 0.5
        currentV = currentV-1 if currentV > 0
      else if deltaT > 0.1
        currentV = currentV + 1 if currentV < 100
      else
        currentV = currentV + 1 if currentV < 170
      
      bgp = bgp + Math.round(currentV/10)
      cp = cp + Math.round(currentV/12)
      $('.game-background').css('background-position', bgp+'px 100%')
      $('.game-clouds').css('background-position', cp+'px 100%')
      $('#speed').html('speed: '+currentV)

  start = () ->
    # initSpeedTester()
    ee.emitEvent('app_NavPopupCtrl', [ {action:'close', popup:"start"}, null ])
    ee.emitEvent('app_NavScreenCtrl', [ {screen:"game"}, null ])
    animate()

    gameIndicator = new WheelIndicator(
      elem: document.querySelector('.screen_game')
      callback: (e) ->
        if e.direction is 'down'
          # clearTimeout(prevScrollTimeOut) if prevScrollTimeOut
          # prevScrollTimeOut = setTimeout (->
          #   gamePaused()
          # ), 10000    
          time = new Date()
          arrScrolls.shift() if arrScrolls.length > 9
          arrScrolls.push(time)
          score = score + 2
          $('#score').html(Math.round(score)+' loop')
        return
    )

  gameController = (params, targetElement) =>
    console.log params
    start() if params.action is 'start'
    pause() if params.action is 'pause'

  @init = () ->
    ee.addListener('ui_GameCtrl', gameController)

window.Game = Game

  # initSpeedTester = () ->
  #   speedTesterInterval = setInterval (->
  #     scrollSpeed = score - score_last
  #     score_last = score
      
  #   ), 500


  # if gameSpeed < scrollSpeed
  #   gameSpeed = gameSpeed + config.accelerationPlus/gameSpeed * deltaT
  #   # прибавляем скорость
  # else if gameSpeed > scrollSpeed
  #   gameSpeed = gameSpeed - config.accelerationMinus * deltaT
  #   # снижаем скорость
  # gameSpeed = Math.round(gameSpeed)
  # gameSpeed = 0 if gameSpeed < 0
  # gameSpeed = 100 if gameSpeed > 100
  # $('#speed').html('speed: '+gameSpeed)
  # deltaY = gameSpeed * deltaT / 100




  # console.log delta 

  # lastframe = currentframe
  # currenttime = new Date()
  # time = slides * 25 / 4 / 60
  # fpms = time/slides*1000 * time_slow
  # slide_number = Math.floor((currenttime-starttime)/fpms)