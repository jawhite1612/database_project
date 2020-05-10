function createList(state,x, y, r) {
	var district = 0;

	for (var i = 0; i < x.length; i++) {
		var districtIndex = i;
		if (state != 'national') {
			for (var j = 0; j < x.length; j++) {
				var index = parseInt(x[j].substring(state.length)) - 1;
				if (index == i) {
					districtIndex = j;
					break;
				}
			}
		}
		
		$("<tr></tr>", {
			id: "row-" + i.toString()
		}).appendTo("#table");

		$("<td></td>", {
			text: x[districtIndex]
		}).appendTo("#row-"+i.toString());
		$("<td></td>", {
			text: parseFloat(y[districtIndex]).toFixed(2)
		}).appendTo("#row-"+i.toString());
		$("<td></td>", {
			text: parseFloat(r[districtIndex]).toFixed(2)
		}).appendTo("#row-"+i.toString());
	}
}

function sortGraph(x,y,r, sortBy, districts) {
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

function createGraph(title, state, x, y, r, s) {
    var width;
    if (x.length < 5) {
        width = 55;
    } else if (x.length < 10) {
	width = 45;
    } else if (x.length < 20) {
        width = 35;
    } else if (x.length < 30) {
	width = 25;
    } else if (x.length < 40) {
        width = 15;
    } else {
        width = 1;
    }
    if (state == 'national_(all)') {
    	width = 1;
    	s = s == 0 ? 1 : s;
    }
    if (s >= 0) {
		var temp = sortGraph(x, y, r, s);
		x = temp[0];
		y = temp[1];
		r = temp[2];
    }
   
    var options = {
	animationEnabled: true,
		title: {
			text: title              
		},
	        dataPointWidth: width,
		data: [              
		    {
			type: "column",
			dataPoints: []
		    }
		]
    }
    for (var i =0; i < x.length; i++) {
		if (parseInt(y[i]) > 0) {
		    options.data[0].dataPoints.push({label: x[i], x: (state != 'national_(all)' && state != 'national_(average)' && state && s == 0) ? parseInt(x[i].substring(state.length)) - 1 : i, y: parseFloat(y[i]), color: getColor(r[i])})
		}
    }
    $("#chartContainer").CanvasJSChart(options);
}
