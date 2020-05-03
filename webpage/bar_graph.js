function createGraph (x, y) {

	var options = {
		title: {
			text: "Income"              
		},
		data: [              
		{
			type: "column",
			dataPoints: []
		}
		]
	};

	for (var i =0; i < x.length; i++) {
		options.data.dataPoints.push({lable: x[i], y: y[i]})
	}

	$("#chartContainer").CanvasJSChart(options);
}