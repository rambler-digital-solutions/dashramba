class Dashing.Chartjs extends Dashing.Widget

  polarAreaChart: (id, datasets) ->
    data = datasets.map (d) => @merge(this.circleColor(d.colorName), label: d.label, value: d.value)
    new Chart(document.getElementById(id).getContext("2d")).PolarArea(data)

  pieChart: (id, datasets) ->
    data = datasets.map (d) => @merge(this.circleColor(d.colorName), label: d.label, value: d.value)
    new Chart(document.getElementById(id).getContext("2d")).Pie(data, {
      responsive: true,
      maintainAspectRatio: true,
    })

  doughnutChart: (id, datasets) ->
    data = datasets.map (d) => @merge(this.circleColor(d.colorName), label: d.label, value: d.value)
    new Chart(document.getElementById(id).getContext("2d")).Doughnut(data)

  lineChart: (id, labels, datasets) ->
    data = @merge labels: labels,
      datasets: datasets.map (d) => @merge(this.color(d.colorName), label: d.label, data: d.data)
    new Chart(document.getElementById(id).getContext("2d")).Line(data)

  barChart: (id, labels, datasets) ->
    data = @merge labels: labels,
      datasets: datasets.map (d) => @merge(this.color(d.colorName), label: d.label, data: d.data)
    new Chart(document.getElementById(id).getContext("2d")).Bar(data)

  radarChart: (id, labels, datasets) ->
    data = @merge labels: labels,
      datasets: datasets.map (d) => @merge(this.color(d.colorName), label: d.label, data: d.data)
    new Chart(document.getElementById(id).getContext("2d")).Radar(data)

  merge: (xs...) =>
    if xs?.length > 0
      @tap {}, (m) -> m[k] = v for k, v of x for x in xs

  tap: (o, fn) -> fn(o); o

  colorCode: ->
    blue: "151, 187, 205"
    cyan:  "0, 255, 255"
    darkgray: "77, 83, 96"
    gray: "148, 159, 177"
    green: "70, 191, 189"
    light_green: "250, 190, 140"
    lightgray: "220, 220, 220"
    magenta: "255, 0, 255"
    red: "255, 0, 60"
    yellow: "255, 138, 0"

  color: (colorName) ->
    fillColor: "rgba(#{ @colorCode()[colorName] }, 0.2)"
    strokeColor: "rgba(#{ @colorCode()[colorName] }, 1)"
    pointColor: "rgba(#{ @colorCode()[colorName] }, 1)"
    pointStrokeColor: "#fff"
    pointHighlightFill: "#fff"
    pointHighlightStroke: "rgba(#{ @colorCode()['blue'] },0.8)"

  circleColor: (colorName) ->
    color: "rgba(#{ @colorCode()[colorName] }, 1)"
    highlight: "rgba(#{ @colorCode()[colorName] }, 0.8)"