class Dashing.PieChart extends Dashing.Chartjs

    onData: (data) ->
      @pieChart("PieChart",
        [{
          value: 13
          colorName: 'red'
          label: data.test
        }, {
          value: 32
          colorName: 'green'
          label: "Apple"
        }, {
          value: 40
          colorName: 'yellow'
          label: "Pizza"
        }, {
          value: 20
          colorName: 'gray'
          label: "Rhubarb"
        }])
