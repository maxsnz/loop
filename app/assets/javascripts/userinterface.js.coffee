$ ->
  $(document).on 'touchend click', '.ui-clickable', (e) ->

    unless $(@).hasClass 'disabled'
      dataObj = $(@).data()
      e.preventDefault() unless dataObj.prevent is 'false'
      controller = dataObj.controller
      # console.log controller
      ee.emitEvent('ui_'+controller, [ dataObj, e.target ])
      # ee.emitEvent('ui_EventTracker', [ dataObj, e.target ])
      
  # $(document).on 'change', '.ui-changeable', (e) ->
  #   dataObj = $(@).data()
  #   e.preventDefault() unless dataObj.prevent is 'false'
  #   controller = dataObj.controller
  #   ee.emitEvent('ui_'+controller, [dataObj, e.target] )

  # $(document).on 'mouseover click hover', '.ui-hoverable', (e) ->
  #   dataObj = $(@).data()
  #   e.preventDefault() unless dataObj.prevent is 'false'
  #   controller = dataObj.controller
  #   ee.emitEvent('ui_'+controller, [ dataObj, e.target ])
  #   $(@).remove()