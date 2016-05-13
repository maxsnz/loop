class Navigation
  currentScreen = undefined
  goScreen = (currentScreen, newScreen) ->
    $('.screen_'+currentScreen).addClass('hidden')
    $('.screen_'+newScreen).removeClass('hidden')
    $('.menu-item').removeClass('active disabled')
    $('.menu-item[data-screen="'+newScreen+'"]').addClass('active disabled')
    $('.popup').fadeOut()


  screenController = (params, targetElement) =>
    if currentScreen isnt params.screen
      goScreen(currentScreen, params.screen)
      currentScreen = params.screen
      Navigation.closePopup(params.close) if (params.close)
    else if (params.close)
        goScreen(currentScreen, params.screen)
        currentScreen = params.screen
        Navigation.closePopup(params.close)

  @changeScreen = (newScreen) ->
    goScreen(currentScreen, newScreen)
    currentScreen = newScreen


  @openPopup = (popup, callback) ->
    $('.popup_'+popup).fadeIn()
    callback() if typeof callback is "function"

  @closePopup = (popup, callback) ->
    $('.popup_'+popup).fadeOut()
    callback() if typeof callback is "function"

  popupContoller = (params, targetElement) =>
    console.log params
    @openPopup(params.popup) if params.action is 'open'
    @closePopup(params.popup) if params.action is 'close'

  # shareController = (params, targetElement) ->
  #   url = 'http://specials.lookatme.ru/theartistisyou'
  #   url = params.url if params.url
  #   if params.provider is 'fb'
  #     newWin = window.open("https://www.facebook.com/sharer/sharer.php?u="+url,"share","width=555,height=420,resizable=yes,scrollbars=yes,status=yes")
  #   if params.provider is 'vk'
  #     newWin = window.open("http://vk.com/share.php?url="+url,"share","width=650,height=420,resizable=yes,scrollbars=yes,status=yes")
  #   if params.provider is 'tw'
  #     text = 'Создай свой дизайн флакона из Instagram-фотографий '
  #     text = params.text if params.text
  #     newWin = window.open("https://twitter.com/intent/tweet?text="+text+url,"share","width=650,height=420,resizable=yes,scrollbars=yes,status=yes")
  #   newWin.focus()


  @init = (config) ->
    # $('.screen').hide()
    currentScreen = config.currentScreen
    ee.addListener('ui_NavScreenCtrl', screenController)
    ee.addListener('app_NavScreenCtrl', screenController)
    ee.addListener('ui_NavPopupCtrl', popupContoller)
    ee.addListener('app_NavPopupCtrl', popupContoller)
    # ee.addListener('ui_NavShareCtrl', shareController)

    goScreen(undefined, currentScreen)

window.Navigation = Navigation

