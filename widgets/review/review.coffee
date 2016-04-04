class Dashing.Review extends Dashing.Widget

  onData: (data) ->
    if (data.rating > 4)
      $(@node).css('background-color', '#54cb0d')
    else
      $(@node).css('background-color', '#fd3636')