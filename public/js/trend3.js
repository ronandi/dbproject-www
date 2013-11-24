d3.json('trend3data', function(error, data) {
  vals = data.map(function(d) { return { x: d.favorite_abv, y: d.liked_abv_average };});
data = [
    {
      values: vals,
      key: 'Drinkers',
      color: '#ff7f0e'
    }
  ];

nv.addGraph(function() {
  var chart = nv.models.scatterChart();
  chart.margin({left: 80 });

  chart.xAxis
      .axisLabel('Favorite Beer ABV')
      .tickFormat(d3.format(',r'));

  chart.yAxis
      .axisLabel('Average Liked Beer ABV')
      .tickFormat(d3.format(',r'));

  d3.select('#graph1 svg')
      .datum(data)
    .transition().duration(500)
      .call(chart);

  nv.utils.windowResize(chart.update);

  return chart;
});
});
