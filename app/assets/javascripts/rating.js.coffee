class Rating
  @init = () ->
    $.ajax 
      type: 'GET'
      url: '/api/players/'
      success: (data) =>
        tmpl = _.template($('#tmpl_rating').html())
        $c1 = $('.rating-container ol.left')
        $c2 = $('.rating-container ol.right')
        i = 0
        l = 5
        l = data.players.length if data.players.length < 5
        while i < l
          $r = $(tmpl(data.players[i])).appendTo($c1)
          i++
        
        l = 10
        l = data.players.length if data.players.length < 10
        while i < l
          $r = $(tmpl(data.players[i])).appendTo($c2)
          i++


window.Rating = Rating