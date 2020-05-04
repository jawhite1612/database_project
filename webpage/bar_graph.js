function getColor(i) {
    if (i == 0) {
	return 0;
    } else if (i > 0 && i < .5) {
	return 1;
    } else if (i == .5) {
	return 2;
    } else if (i > .5 && i < 1) {
	return 3;
    } else if (i == 1) {
	return 4;
    }
}

function createGraph(x, y, r) {
    console.log(r);
    var options = {
		title: {
			text: "Income"              
		},
	        dataPointWidth: 20,
		data: [              
		    {
			type: "column",
			color: "red",
			dataPoints: []
		    },
		    {
			type: "column",
			color: "#f57a7a",
			dataPoints:[]
		    },
		     {
			type: "column",
			color: "#ede9be",
			dataPoints:[]
		     },
		     {
			type: "column",
			color: "#ababff",
			dataPoints:[]
		     },
		     {
			type: "column",
			color: "blue",
			dataPoints:[]
		    },
		]
    }
    
    for (var i =0; i < x.length; i++) {
	if (parseInt(y[i]) > 0) {
	    options.data[getColor(r[i])].dataPoints.push({label: x[i], x:i, y: parseInt(y[i])})
	}
    }
    console.log(options);
    $("#chartContainer").CanvasJSChart(options);
}
