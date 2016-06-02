class Dashing.CodeReviewStatus extends Dashing.Widget
  ready: ->
    widget = $(@node)
    widget.css("background-color", "#29a334")
  onData: (data) ->
    widget = $(@node)

    text = ""
    detail_text = ""
    for i in [1..5]
      if data.days < 14
        text =  "На днях"
        detail_text = "Меньше 2 недель назад"
        widget.css("background-color", "#29a334")
      else if data.days >= 14
        text =  "Недавно"
        detail_text = "Около 2 недель назад"
        widget.css("background-color", "#f3bc39")
      else if data.days >= 21
        text =  "Давно"
        detail_text = "Больше 3 недель назад"
        widget.css("background-color", "#ef404a")
    widget.find('.text').html(text)
    widget.find('.detail-text').html(detail_text)
