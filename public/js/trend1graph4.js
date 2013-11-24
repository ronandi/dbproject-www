d3.json('trend1graph4', function(error, data) {
males = data.filter(function(d) { return d.gender == "male"; });
females = data.filter(function(d) { return d.gender == "female"; });
males = males.map(function(d) { return { x: d.age, y: d.ibu };});
females = females.map(function(d) { return { x: d.age, y: d.ibu };});
data = [
    {
      values: males,
      key: 'Males',
      color: '#ff7f0e'
    },
    {
      values: females,
      key: 'Females',
      color: '#2ca02c'
    }
  ];

nv.addGraph(function() {
  var chart = nv.models.lineChart();
  chart.margin({left: 80 });

  chart.xAxis
      .axisLabel('Age')
      .tickFormat(d3.format(',r'));

  chart.yAxis
      .axisLabel('Ibus')
      .tickFormat(d3.format(',r'));

  d3.select('#graph4 svg')
      .datum(data)
    .transition().duration(500)
      .call(chart);

  nv.utils.windowResize(chart.update);

  return chart;
});
});
