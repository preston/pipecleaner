// Calculates the precentage of a give status code. E.g., for finding the percentage of stages in a pipeline that a work item has been marked "complete".
function percent_in_status(code, statuses, total) {
	var percent = 0;
	var count = 0;
	for(var i = 0; i < statuses.length; i++) {
		if(code == statuses[i]['code']) {
			count++;
		}
	}
	return 100.0 * count / total;
}

function mashup_progress_bars() {

	if($('.mashup').length) {
		var url = "/items/find.json";
		var token = $('#refresh_progress').data('token');
		var item_name = $('#refresh_progress').data('item-name');
		console.log(url);
		// Get detailed information about the item.
		$.ajax({url: url, method: 'GET', data: {name: item_name, auth_token: token}, success: function(data) {
			console.log(data);
			var e = $('#example');
			// The 'find' call returns 0..* work items.
			for(var i = 0; i < data.length; i++) {
				// Each work item is a "member" of 0..* pipelines.
				for(var m = 0; m < data[i]['members'].length; m++) {

					// Get the number of stages in the pipeline.
					var p_stage_count;
					var p_url = "/pipelines/" + data[i]['members'][m]['pipeline']['code'] + '.json';
					console.log("Getting pipeline stage count.");
					$.ajax(p_url, {async: false, success: function(p_data){
						p_stage_count = p_data['stages'].length;
						console.log("Pipeline has " + p_stage_count + ' stages.');
					}});

					// Insert a progress bar with only jQuery.
					var percent_complete = percent_in_status("complete", data[i]['members'][m]['statuses'], p_stage_count);
					e.append('<h2>' + data[i]['members'][m]['pipeline']['name'] + '</h2>');
					e.append('<div class="progress progress-success progress-striped active"><div class="bar" style="width: ' + percent_complete + '%;"></div></div>');
	
				}
				data[0];
			}
		}});

	}

}

$(function() {
	$('.mashup').on('click', '#refresh_progress', mashup_progress_bars);
});

