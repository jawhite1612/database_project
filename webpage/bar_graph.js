function sort(x,y,r, sortBy) {
    console.log(r)
    var tempX = []
    var tempY = []
    var tempR = []
    var sort = []
    
    if (sortBy == 0) {
	return [x, y, r];
    } else if (sortBy == 1) {
	sort = y;
    } else if (sortBy == 2) {
	sort = r;
    }
    
    while (sort.length > 0) {
	var maxX = x[0];
	var maxY = y[0];
	var maxR = r[0];
	var maxIndex = 0;
	var sortMax = -1;
	for (var i = 0; i < sort.length; i++) {
	    if (parseFloat(sort[i]) > parseFloat(sortMax)) {
		maxX = x[i];
		maxY = y[i];
		maxR = r[i];
		maxIndex = i;
		sortMax = sort[i];
	    }
	}
	tempX.push(maxX);
	tempY.push(maxY);
	tempR.push(maxR);
	x.splice(maxIndex,1);
	y.splice(maxIndex,1);
	r.splice(maxIndex,1);
	if (sortBy == 1) {
	    sort = y;
	} else if (sortBy == 2) {
	    sort = r;
	}
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

function createGraph(x, y, r, sort) {
    if (sort >= 0) {
	var temp = sort(x, y, r, sort);
	x = temp[0];
	y = temp[1];
	r = temp[2];
    }
    var options = {
	animationEnabled: true,
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
	    options.data[0].dataPoints.push({label: x[i], y: parseInt(y[i]), color: getColor(r[i])})
	}
    }
    console.log(options);
    $("#chartContainer").CanvasJSChart(options);
}
