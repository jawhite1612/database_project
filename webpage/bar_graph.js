function createGraph(x, y) {
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
	if (parseInt(y[i]) > 0) {

	    options.data[0].dataPoints.push({label: x[i], y: parseInt(y[i])})
	}
	}

	$("#chartContainer").CanvasJSChart(options);
    console.log(options);
}
