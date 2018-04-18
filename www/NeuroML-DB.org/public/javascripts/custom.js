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
                enabled: true,
                mode: "x"
            }
		}
	});
};
function createCharts(){
	getProtocolData(function(){
		setupChart("canvasG", "Conductance (pS)", conductances);
		setupChart("canvasI", "Current (pA)", currents);
		setupChart("canvasV", "Voltage (mV)", voltages);
	});
}
function updateCharts() {
	updateChart("canvasG", conductances);
	updateChart("canvasI", currents);
	updateChart("canvasV", voltages);
}
function clearCharts() {
    if(window["canvasG"].clear != null) {
        window["canvasG"].clear();
        window["canvasI"].clear();
        window["canvasV"].clear();
    }
}
function resetChartZooms() {
    window["canvasG"].resetZoom();
    window["canvasI"].resetZoom();
    window["canvasV"].resetZoom();
}
function getProtocolData(doneCallback) {

    url = "/GetModelProtocolData?"+
	"modelID="+jQuery("#modelID").val()+
	"&caConc="+jQuery("#caConc").val()+
	"&subProtocol="+jQuery("#subProtocol").val();

    if(window.mostRecentChartUrl != url) {
        window.mostRecentChartUrl = url;
    }
    else {
        return;
    }


    $("#loadingImage").show();
    $("#plotError").hide();

    //Show loading indicator after a delay
    var loadingTimer = setTimeout(function() { $("#plotsLoading").show(); }, 500);

	jQuery.ajax(url, {
		success: function (data) {
			eval.call(window,data);

			//For voltage plots, add a "series"  that,
			//when drawn, will result in a dashed ROI box
			//vxmin, vxmax vars will have the ROI tmin/tmax values

			//Find the y min/max values from the data
			firstY = voltages.datasets[0].data[0].y;
			var vymax = firstY;
			var vymin = firstY;

			for (var d in voltages.datasets) {
				ds = voltages.datasets[d]
				for (var p in ds.data) {
					y = ds.data[p].y

					if (y > vymax)
						vymax = y

					if (y < vymin)
						vymin = y
				}
			}

			//Add some vertical padding
			var padding = 0.1 * (vymax - vymin);
			vymin = vymin - padding;
			vymax = vymax + padding;

			//Add a "series" that, when drawn, will result in the dashed ROI box
			voltages.datasets.push({
				borderColor: "black",
				borderDash: [5],
				label: "Region of Interest shown in the Current and Conductance plots below",
				data: [
					{x: vxmin, y: vymin},
					{x: vxmin, y: vymax},
					{x: vxmax, y: vymax},
					{x: vxmax, y: vymin},
					{x: vxmin, y: vymin},
				]
			});

            //Hide any ongoing indicators
            clearTimeout(loadingTimer);
            $("#plotsLoading").hide();

			doneCallback();
		},
        error: function (jqXHR, status, error) {
            //Hide any ongoing indicators
            clearTimeout(loadingTimer);
            $("#plotsLoading").show();
            $("#loadingImage").hide();
            $("#plotError").show();
        }
	});
}
function updateChart(id, data, min_y, max_y, reset_zoom)
{
    window[id].data.datasets.length = 0;

	for (d = 0; d < data.datasets.length; d++) {
		window[id].data.datasets.push(data.datasets[d]);
	}

    window[id]["options"]["scales"]["yAxes"][0]["ticks"]["suggestedMax"] = max_y
    window[id]["options"]["scales"]["yAxes"][0]["ticks"]["suggestedMin"] = min_y

    if(reset_zoom){
        window[id].resetZoom();
    }
    else {
        window[id].update();
    }
}
function changeCaConc(element, name) {
	jQuery("#caConc").val(name);
	jQuery("#caConcLevels .selected").removeClass("selected");
	jQuery(element).addClass("selected");

	getProtocolData(updateCharts);
}
function changeSubProtocol(element, subProt) {
	jQuery("#subProtocol").val(subProt);
	jQuery("#protocols .selected").removeClass("selected");
	jQuery(element).addClass("selected");
	getProtocolData(updateCharts);
}

function range(start, stop, step){
    var a=[start], b=start;
    while(b<stop){b+=step;a.push(b)}
    return a;
};

