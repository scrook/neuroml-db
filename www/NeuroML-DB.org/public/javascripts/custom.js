//Channel voltage clamp chart plots
function setupChart(id, title, data) {
	var ctx = document.getElementById(id).getContext("2d");

	window[id] = new Chart(ctx, {
		type: 'line',
		data: data,
		options: {
			animation: { duration: 0 },
			responsive: false,
			title: { display: false },
			elements: {
				point: { radius: 0, hitRadius:10, borderWidth: 0 },
                line: { fill: false, borderWidth:1.5, cubicInterpolationMode: 'default', tension: 0, borderJoinStyle:'round' },
			},
			hover: { mode: 'nearest', animationDuration: 0 },
			legend: { display: false, },
			scales: {
				xAxes: [{
					type: 'linear',
					position: 'bottom',
					scaleLabel: {
						display: true,
						labelString: "Time (ms)"
					},
                    ticks: { maxRotation: 0, stepSize:10, maxTicksLimit: 11  }
				}],
				yAxes: [{
					fontFamily: '"Lucida Console", Monaco, monospace',
                    afterTickToLabelConversion: function(e) {
                        //Ensure the tick labels are same length
						for(t in e.ticks) {
							label = e.ticks[t]

							if(label.indexOf(".") < 0){
                                label += "."
							}
                            label = label.padEnd(5,"0")

                            e.ticks[t] = label
						}
					},
					scaleLabel: {
						display: true,
						labelString: title,
						fontSize: 14
					}
				}]
			},
            pan: {
			    enabled: true,
                mode: "x"
            },
            zoom: {
                enabled: false,
                mode: "x"
            }
		}
	});
};

function updateChart(id, data, min_y, max_y, min_x, max_x, reset_zoom)
{
    var chart = window[id];

    chart.data.datasets.length = 0;

	for (d = 0; d < data.datasets.length; d++) {
		chart.data.datasets.push(data.datasets[d]);
	}

    var y_ticks = chart["options"]["scales"]["yAxes"][0]["ticks"];
	var x_ticks = chart["options"]["scales"]["xAxes"][0]["ticks"];

	y_ticks["suggestedMax"] = max_y
    y_ticks["suggestedMin"] = min_y

    x_ticks["data-max"] = max_x
    x_ticks["data-min"] = min_x

    if(reset_zoom){
        x_ticks["max"] = max_x;
        x_ticks["min"] = min_x;

        x_ticks["suggestedMax"] = max_x;
        x_ticks["suggestedMin"] = min_x;

        chart.update();
    }
    else {
        chart.update();
    }
}

function range(start, stop, step){
    var a=[start], b=start;
    while(b<stop){b+=step;a.push(b)}
    return a;
};

