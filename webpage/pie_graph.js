function createPieGraph(x) {
	console.log(x);
	rawData = []
	rawData[0] = x[0][0].substring(0, x[0][0].indexOf('1'));
	for (var i = 1; i < x.length-1; i++) {
		rawData[i] = x[i].reduce(function(a,b) {
			return parseInt(a) + parseInt(b);
		}, 0);
	}

	var ratioAverage = 0;
	for (var i = 0; i < x.length; i++) {
		ratioAverage = x[x.length-1].reduce(function(a,b) {
			return parseFloat(a) + parseFloat(b);
		}, 0);
	}
	ratioAverage /= x[x.length-1].length;

	var options = {
	animationEnabled: true,
	title: {
		text: "Demographics"
	},
	data: [{
			type: "pie",
			startAngle: 45,
			showInLegend: "true",
			legendText: "{label}",
			indexLabel: "{label} ({y})",
			yValueFormatString:"#,##0.#"%"",
			dataPoints: []
		}]
	};
	
	options.data[0].dataPoints.push(
		{label: 'White', y: rawData[1]},
		{label: 'Black', y: rawData[2]}, 
		{label: 'Native American/Alaskan', y: rawData[3]}, 
		{label: 'Asian', y: rawData[4]}, 
		{label: "Pacific Islander", y: rawData[5]}, 
		{label: 'Other Race', y: rawData[6]},
		{label: 'Hispanic', y: rawData[7]}
	)

	$("#chartContainer").CanvasJSChart(options);

}