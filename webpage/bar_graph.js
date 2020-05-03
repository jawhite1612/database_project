function createGraph () {

    var x = <?php echo json_encode($x); ?>;
    var y = <?php echo json_encode($y); ?>; 

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
