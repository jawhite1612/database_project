window.onload = function () {

	var options = {
		title: {
			text: "Column Chart in jQuery CanvasJS"              
		},
		data: [              
		{
			type: "column",
			dataPoints: [
				{ label: "apple",  y: 10  },
				{ label: "orange", y: 15  },
				{ label: "banana", y: 25  },
				{ label: "mango",  y: 30  },
				{ label: "grape",  y: 28  }
			]
		}
		]
	};

	$("#chartContainer").CanvasJSChart(options);
}