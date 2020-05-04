function sort(x,y,r) {
    var tempX = []
    var tempY = []
    var tempR = []
    while (y.length > 0) {
	var maxX = x[0];
	var maxY = y[0];
	var maxR = r[0];
	var maxIndex = 0;
	for (var i = 0; i < y.length; i++) {
	    if (y[i] > maxY) {
		maxX = x[i];
		maxY = y[i];
		maxR = r[i];
		maxIndex = i;
	    }
	}
	tempX.push(maxX);
	tempY.push(maxY);
	tempR.push(maxR);
	x.splice(maxIndex,1);
	y.splice(maxIndex,1);
	r.splice(maxIndex,1);
    }
    return [tempX, tempY, tempR];
}

function getColor(i) {
    if (i == 0) {
	return "red";
    } else if (i > 0 && i < .5) {
	return "#f57a7a";
    } else if (i == .5) {
	return "#f7ffcf";
    } else if (i > .5 && i < 1) {
	return "#7b7bed";
    } else if (i == 1) {
	return "blue";
    }
}

function createGraph(x, y, r, sorted) {
    if (sorted) {
	var temp = sort(x, y, r);
	x = temp[0];
	y = temp[1];
	r = temp[2];
    }
    console.log(y);
    var options = {
		title: {
			text: "Income"              
		},
	        dataPointWidth: 7,
		data: [              
		    {
			type: "column",
			dataPoints: []
		    }
		]
    }
    
    for (var i =0; i < x.length; i++) {
	if (parseInt(y[i]) > 0) {
	    options.data[0].dataPoints.push({label: x[i], x:i, y: parseInt(y[i]), color: getColor(r[i])})
	}
    }
    console.log(options);
    $("#chartContainer").CanvasJSChart(options);
}
