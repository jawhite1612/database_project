
function createGraph(x, y) {
    console.log(x);
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
		options.data[0].dataPoints.push({lable: x[i], y: y[i]})
	}

	$("#chartContainer").CanvasJSChart(options);
}
