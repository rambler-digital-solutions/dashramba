class Dashing.PieChart extends Dashing.Chartjs

    onData: (data) ->
      chart = @pieChart("PieChart",
        [{
          value: data.priority1
          colorName: 'red'
          label: 'Критичный' + ' - ' + data.priority1
        }, {
          value: data.priority2
          colorName: 'yellow'
          label: 'Средний' + ' - ' + data.priority2
        }, {
          value: data.priority3
          colorName: 'light_green'
          label: 'Низкий' + ' - ' + data.priority3
        }])
      widget = $(@node)
      legend = chart.generateLegend()
      widget.find('.chart-legend').html(legend)

