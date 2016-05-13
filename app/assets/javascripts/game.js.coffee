#= require requestAnimationFrame.js

class Game
  state = 'initial'
  currentBg = 0
  score = 0
  prev_score = 0
  arrScrolls = [0]
  currentV = 0
  bgp = 0
  cloudp = 0
  cloudw = 6000
  bgw = 1366
  cp = 0
  windowWidth = undefined
  config = {
    t:10
  }
  $bg    =  undefined
  $clouds=  undefined
  $speed =  undefined
  $score =  undefined
  $plane =  undefined
  $wheel =  undefined
  $share =  undefined
  bgs = ['winter', 'forest', 'sea', 'city']
  periods = [
    {score:100, text:'100 LOOP’ов = 1€', description:''}
    {score:500, text:'500 LOOP’ов Путешествуете с семьёй и друзьями.', description: 'И накапливайте LOOP’ы на одном счёте.'}
    {score:1000, text:'У вас 1000 LOOP’ов!', description: 'Теперь вы можете оплатить топливный сбор!'}
    {score:3500, text:'3500 LOOP’ов', description: 'Оплачивайте багаж LOOP’ами!'}
    {score:5000, text:'5000 LOOP’ов', description: 'Недостаточно LOOP’ов на билет? Оплатите билет частично!'}
    {score:9900, text:'9900 LOOP’ов на вашем счёте!', description: 'И бесплатный билет Москва–Брюссель–Москва у вас в кармане!'}
    {score:13000, text:'13000 LOOP’ов Планируете путешествие на праздники?', description: 'Используйте LOOP’ы в любое время'}
    {score:999999999, text:'Выкупили авиакомпанию', description:''}
  ]




  animate = () ->
    requestAnimationFrame( animate )
    render()

  nextBg = () ->
    $('.bg-container.'+bgs[currentBg]).removeClass('active')
    currentBg = currentBg + 1
    currentBg = 0 if currentBg == bgs.length
    $bg = $('.bg-container.'+bgs[currentBg])
    $bg.addClass('active')

  render = ->
    if arrScrolls.length > 2
      currentTime = new Date()
      lastTime = arrScrolls[arrScrolls.length-1]
      lastlastTime = arrScrolls[arrScrolls.length-2]
      deltaT = (currentTime - lastTime)/1000  
      # пересчитываем скорость только если игра идет
      unless state is 'pause'
        if deltaT > 3
          timeout() unless state is 'timeout' or state is 'pause'
          state = 'timeout'
          return
        else if deltaT > 1
          currentV = currentV - 2 if currentV > 0
          currentV = 0 if currentV < 0
        else if deltaT > 0.5
          currentV = currentV-1 if currentV > 0
        else if deltaT > 0.1
          currentV = currentV + 1 if currentV < 100
        else
          currentV = currentV + 1 if currentV < 170
      
      bgp = bgp + Math.round(currentV/10)
      old_cloudp = cloudp
      cloudp = cloudp + Math.round(currentV/20)
      bgp = bgp % bgw if bgp > bgw

      cloudp = -cloudw/2 if (cloudp > (cloudw/2))
      
      cp = cp + Math.round(currentV/12)
      $bg.css('transform', 'translateX('+bgp+'px)')
      # $clouds.css('background-position', cp+'px 100%')
      # $speed.text('speed: '+currentV)
      unless old_cloudp == cloudp
        # console.log cloudp
        $clouds.find('.cloud').each ->
          $(@).css('transform', 'translateX('+cloudp+'px)')
      $score.text(Math.round(score)) if prev_score != score
      prev_score = score
      if score >= periods[0].score
        pause()
      if currentV is 0
        $plane.removeClass('takeoff')
      else
        $plane.addClass('takeoff')

  play = () ->
    state = 'play'  
    Navigation.closePopup('pause')
    Navigation.closePopup('finish')
    time = new Date()
    arrScrolls.shift() if arrScrolls.length > 9
    arrScrolls.push(time)
    nextBg()

  pause = () ->
    $('.popup_pause-blue').text(periods[0].text)
    $('.popup_pause-black').text(periods[0].description)
      
    periods.splice(0,1)
    state = 'pause'
    Navigation.openPopup('pause')

  timeout = () ->
    console.log('timeout')
    Navigation.openPopup('finish')
    $share.attr('data-url', 'http://www.piter-flanders.ru/result?l='+score)

  save = () ->
    $(".popup_finish-end").hide()
    if Player.data
      $.ajax 
        type: 'POST'
        url: '/api/results/'+Player.data.attempt_id
        data: {
          _method: 'put'
          user_id: Player.data.id
          token: Player.data.token
          score: score
        }
        success: (data) =>
          console.log('save success', data)
          
        error: (xhr, textStatus, error) =>
          console.log 'save error', xhr.responseJSON
          

  start = () ->
    $('.whengamestarted').show()
    $('.whengamenotstarted').hide()
    state = 'play'
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
          $wheel.hide()

        return
    )
    pauseIndicator = new WheelIndicator(
      elem: document.querySelector('.popup_finish')
      callback: (e) ->
        if e.direction is 'down'
          play()
        return
    )

    if Player.data
      $.ajax 
        type: 'POST'
        url: '/api/results'
        data: {
          user_id: Player.data.id
          token: Player.data.token
        }
        success: (data) =>
          Player.data.attempt_id = data.id
          console.log 'Player.data.attempt_id', Player.data.attempt_id

  gameController = (params, targetElement) =>
    console.log 'gameController', params
    start() if params.action is 'start'
    pause() if params.action is 'pause'
    timeout() if params.action is 'timeout'
    play() if params.action is 'play'
    save() if params.action is 'save'
    # if params.action is 'return'
    #   unless state is 'initial'
    #     Navigation.changeScreen('game')
    #     play() if state is 'play'
    #     timeout() if state is 'timeout'
    #     pause() if state is 'pause'
    #   else
    #     Navigation.changeScreen('main')
    # if params.action is 'changeScreen'
    #   if params.screen is 'game'
    #     gameScreenIsActive = true 
    #   else
    #     gameScreenIsActive = false 


  @init = () ->
    ee.addListener('ui_GameCtrl', gameController)
    $bg = $('.bg-container')
    $clouds = $('.game-clouds')
    $speed = $('#speed')
    $plane = $('.plane')
    $wheel = $('.game-scrollwheel')
    $score = $('#score span, .popup_finish-cloud-bottom span')
    $share = $('.popup_finish-share')
    windowWidth = $(window).width()
    $clouds.find('.cloud').each ->
      p = Math.floor(Math.random() * (80 - 5 + 1)) + 5
      $(@).css('top', p+'%')
    $(window).resize ->
      windowWidth = $(window).width()

  @start = () ->
    start()



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