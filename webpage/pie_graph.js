function getStatePartyColor(i, min, max) {
    if (i == 0) {
		return "red";
    } else if (i > 0 && i < .5) {
		return "#f57a7a";
    } else if (i == .5) {
		return "yellow";
    } else if (i > .5 && i < 1) {
		return "#7b7bed";
    } else if (i == 1) {
		return "blue";
    }
}

function setStatePartyColors(x, r) {
 	var stateValues = {}
    var minVal  = Number.MAX_VALUE;
    var maxVal = Number.MIN_VALUE;
    for (var i = 0; i < x.length; i++) {
        stateValues[x[i]] = r[i];
        minVal = minVal > r[i] ? r[i] : minVal;
        maxVal = maxVal < r[i] ? r[i] : maxVal;
    }

    var stateColors = {}
    for (var key in states) {
        if (!key.includes('NA')) {
            stateColors[key] = {fill: getStatePartyColor(stateValues[states[key]], minVal, maxVal)};
        }
    }

    $('#map').usmap({
      stateSpecificStyles:stateColors,
      click: function(event, data) {
        var option = $('#state').val(states[data.name].toLowerCase().replace(" ", "_"));
        $("#stateAbrev").val(data.name);
        $('#form').submit()
      },
    });    
}

function createPieGraph(x) {
	
	rawData = []
	if (x[0].length > 300) {
		rawData[0] = 'national';
	} else {
		rawData[0] = x[0][0].substring(0, x[0][0].indexOf('1'));
	}
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
		text: "Demographics (" + rawData[0] + ")"
	},
	legend:{
		horizontalAlign: "right",
		verticalAlign: "center"
	},
	data: [{
			type: "pie",
			startAngle: 45,
			showInLegend: "true",
			legendText: "{label} (#percent%)",
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
		{label: 'Other', y: rawData[6]},
		{label: 'Hispanic', y: rawData[7]}
	)

	options.data[0].dataPoints.sort(function (a, b) {
		return a.y < b.y ? 1 : -1;
	})


	$("#chartContainer").CanvasJSChart(options);
	$("<div></div>", {
		text: ratioAverage
	}).appendTo("body");
}