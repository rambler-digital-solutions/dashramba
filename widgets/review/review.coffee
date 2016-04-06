class Dashing.Review extends Dashing.Widget

  onData: (data) ->
    widget = $(@node)

    html = ""
    for i in [1..5]
      if data.rating >= i
        html = html + "<div class=\"star yellow\">★</div>"
      else
        html = html + "<div class=\"star gray\">★</div>"

    widget.find('.review-rating').html(html)

    more_info = "by #{data.author_name} for #{data.version}"
    widget.find('.more-info').html(more_info)