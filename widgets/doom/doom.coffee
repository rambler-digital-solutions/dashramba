class Dashing.Doom extends Dashing.Widget

    onData: (data) ->
      widget = $(@node)
      face = widget.find('.face')
      if data.rating >= 10
        face.attr({src: "/assets/10.gif"})
      else if data.rating < 10 && data.rating >= 8
        face.attr({src: "/assets/8-10.gif"})
      else if data.rating < 8 && data.rating >= 7
        face.attr({src: "/assets/7-8.gif"})
      else if data.rating < 7 && data.rating >= 6
        face.attr({src: "/assets/6-7.gif"})
      else if data.rating < 6 && data.rating >= 4
        face.attr({src: "/assets/4-6.gif"})
      else if data.rating < 4 && data.rating >= 2
        face.attr({src: "/assets/2-4.gif"})
      else if data.rating < 2 && data.rating >= 0
        face.attr({src: "/assets/0-2.зтп"})