$(function() {
	var t = $('#statistics')[0];
	if(t != null) {
		$('#statistics .tip').tooltip();

	  // new Highcharts.Chart({
	  //   chart: { renderTo: 'chart1' },
	  //   title: { text: 'Orders by Day' },
	  //   xAxis: { type: 'datetime' },
	  //   yAxis: {
	  //     title: { text: 'Dollars' }
	  //   },
	  //   series: [{
	  //     pointInterval: #{ 1.day * 1000 },
	  //     pointStart: #{3.weeks.ago.at_midnight.to_i * 1000 },
	  //     data: [1, 2, 5, 7, 3]
	  //   }]
	  // });

		// $('#chart2').highcharts({
		//     chart: {
		//         type: 'bar'
		//     },
		//     title: {
		//         text: 'Fruit Consumption'
		//     },
		//     xAxis: {
		//         categories: ['Apples', 'Bananas', 'Oranges']
		//     },
		//     yAxis: {
		//         title: {
		//             text: 'Fruit eaten'
		//         }
		//     },
		//     series: [{
		//         name: 'Jane',
		//         data: [1, 0, 4]
		//     }, {
		//         name: 'John',
		//         data: [5, 7, 3]
		//     }]
		// });


	}
});