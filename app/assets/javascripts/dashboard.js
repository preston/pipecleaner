// Dashboard only!

function reloadSelectedPipeline() {
	var button = $('#refresh-button');
	button.addClass('hidden');
	var id = $('#dashboard #pipeline_selector select').val();
	console.log("Changing dashboard selection to pipeline ID: " + id);
	var p = $('#pipeline');
	$.ajax({method : 'PUT', url : '/pipelines/' + id + '/active'});
	$.get('/pipelines/' + id + '/status',		function(data) { $('#status').html(data); rebindHovers(); reapplyFilters();});
	$.get('/pipelines/' + id + '/overview',		function(data) { $('#overview').html(data); });
	// $.get('/pipelines/' + id + '/recent',		function(data) { $('#recent').html(data); });
	// $.get('/pipelines/' + id + '/statistics',	function(data) { $('#statistics').html(data); rebindHovers();});
	button.removeClass('hidden');
	rebindHovers();
}

function rebindHovers() {
	console.log("Rebinding tooltips.");
	// $('pop').popover();
	$('#status .tip').tooltip();
	// $('#statistics dt .tip').tooltip({ position: { my: "right+15 center", at: "right center" } });
	// $('#statistics .tip').tooltip();

	$('#statusTabs > li > a').click(function (e) {
		e.preventDefault();
		$(this).tab('show');
	})

	// $('.status-tooltip').popover({ 
	// 	html : true, 
	// 	content: function() {
	// 		return $('.status-tooltip-content').html();
	// 	}
	// });

}

// To avoid glitching effects, we need to figure out which rows will be shown/hidden and *then* apply them en mass as opposed to making multiple passes.
function reapplyFilters() {

	// Start by figuring out if the user wants to see archived items.
	var show_archived = $('#show-archived').is(':checked');

	var all = $('.item-row');
	var hide = new Array();
	if(!show_archived) {
		console.log('Hiding archived items.');
		hide = all.filter('.item-row.archived');
	}

	// If a text filter is present, also filter out anything that doesn't match the text query.
	var q = $('#text-filter').val().toLowerCase();
	console.log("Filtering work items for: " + q);
	if(q == null || q == '') {
		console.log('Skipping text filter.');
	} else {
		var m, name, tags;
		all.each(function(){
			m = $(this);
			name = m.data('item-name').toString();
			tags = m.data('project-tags').toString();
			if(name.toLowerCase().indexOf(q) < 0 && tags.toLowerCase().indexOf(q) < 0) {
				hide.push(m[0]);
			}
		});
	}

	// Remove duplicates.
	// hidden = hidden.filter(function(elem, pos) {return hidden.indexOf(elem) == pos; });
	var me;
	all.each(function(){
		me = $(this);
		if($.inArray(me[0], hide) >= 0) {
			me.hide();
		} else {
			me.show();
		}
	});
}

t = $('.dashboard');

if($('.dashboard').length) {
	console.log("Initializing dashboard.");
	rebindHovers();
	reapplyFilters();

	// Bind pipeline selection.
	$('#dashboard #pipeline_selector select').change(function() {
		reloadSelectedPipeline();
	});


	// Show archived checkbox.
	$('#show-archived').change(function() {
		reapplyFilters();
	});

	// Text filter.
	$('#text-filter').keyup(function(){
		reapplyFilters();
	});

	// Bind refresh button
	$('#refresh-button').click(function(){
		console.log('Refresh button clicked.');
		reloadSelectedPipeline();
	});


	// Create worker to refresh the page, if the user has it enabled.
	setInterval(function(){
		var reload = $('#refresh').prop('checked');
		if(reload) {
			reloadSelectedPipeline();			
		} else {
			console.log("User has disabled automatic refreshes. Will check later!");
		}
	}, 1000 * 60);


	// Bind favoriting actions.
	$('#dashboard').on('click', '.favorite-icon', function() {
		var me = $(this);
		var currentFavorite = me.hasClass('icon-star');
		var active = me.hasClass('active');
		var member_id = me.data('member-id');
		var pid = $('#dashboard #pipeline_selector select').val();
		if(currentFavorite) {
			console.log("Unfavorite'ing member_id: " + member_id);
			$.ajax({url : '/pipelines/' + pid + '/unfavorite/',
					method : 'DELETE',
					data : { member_id : member_id }})
			.success(function(data, textStatus, jqXHR) {
				console.log("Deleted favorite for pipeline member ID: " + member_id);
				me.removeClass('icon-star');
				me.addClass('icon-star-empty');
				$('#member_' + member_id).prependTo('#other-members');
			});
		} else {
			console.log("Favorite'ing member_id:" + member_id);
			$.ajax({url : '/pipelines/' + pid + '/favorite', method : 'POST', data : { member_id : member_id }})
			.success(function(data, textStatus, jqXHR) {
				console.log("Created favorite for pipeline member ID: " + member_id);
				me.removeClass('icon-star-empty');
				me.addClass('icon-star');
				$('#member_' + member_id).prependTo('#favorite-members');
			});

		}
	});

	// Bind archiving actions.
	$('#dashboard').on('click', '.archive-icon', function() {
		var me = $(this);
		var member_id = me.data('member-id');
		var member = $('#member_' + member_id);
		var active = member.hasClass('active');
		var pid = $('#dashboard #pipeline_selector select').val();
		if(active) {
			console.log("Archiving member_id: " + member_id);
			$.ajax({url : '/pipelines/' + pid + '/members/' + member_id + '/archive',
					method : 'PUT'})
			.success(function(data, textStatus, jqXHR) {
				console.log("Deleted favorite for pipeline member ID: " + member_id);
				me.removeClass('icon-folder-open');
				me.addClass('icon-folder-close');
				member.removeClass('active');
				member.addClass('archived');
				member.fadeOut();
			});
		} else {
			console.log("Unarchiving member_id:" + member_id);
			$.ajax({url : '/pipelines/' + pid + '/members/' +  member_id + '/unarchive', method : 'PUT'})
			.success(function(data, textStatus, jqXHR) {
				console.log("Created favorite for pipeline member ID: " + member_id);
				me.removeClass('icon-folder-close');
				me.addClass('icon-folder-open');
				member.removeClass('archived');
				member.addClass('active');
			});

		}
	});


	// Show item data events.
	$('#dashboard').on('click', '.tint-icon', function() {
		var iid = $(this).data('item-id');
		// var cid = $(this).data('id');
		$.get('/items/' + iid + '/data.html')
			.success(function(data){
				console.log('Loaded data dialog data.');
				$('#dashboard #show_data_dialog .modal-body').html(data);
				$('#dashboard #show_data_dialog').modal('show');
			})
			.fail(function(jqXHR, textStatus, errorThrown){
				console.log('Error loading dialog data.');
			});
		// });
		return false;
	});


	// Bind status edit click events.
	$('#dashboard').on('click', '.stage a', function() {
		var a = $(this);
		var member = a.closest('li').data('member-id');
		var stage = a.closest('li').data('stage-id');
		var code = a.closest('li').data('code');
		var notes = a.closest('li').data('notes');
		console.log('Opening status form. Member: ' + member + ', Stage: ' + stage + '.');
		$('#status-member-id').val(member);
		$('#status-stage-id').val(stage);
		$('#status-form #status_notes').val(notes);
		$('#status-form input[name="status[code]"][value="' + code + '"]').prop('checked', true)
		$('#edit_status_dialog').modal('show');
		return false;
	});

	// Edit status form submission.
	$('#dashboard').on('click', '#edit_status_dialog .btn-primary', function() {
		console.log('Handling status form submission.');
		var f = $('#status-form');
		var member = $('#status-member-id').val();
		var stage = $('#status-stage-id').val();

		$.ajax({method : 'POST', data: f.serialize(), url : '/statuses/advance'})
			.success(function(data, textStatus, jqXHR) {
				console.log("Successfully changed status!");
				console.log(data);
				var li = $('li[data-stage-id=' + stage + '][data-member-id=' + member + ']');
				var a = $('li[data-stage-id=' + stage + '][data-member-id=' + member + '] a');
				a.removeClass('complete warning danger pending skipped default');
				a.addClass(data['code']);
				li.data('code', data['code']);
				li.data('notes', data['notes']);
				$('#edit_status_dialog').modal('hide');
			}).error(function(data, textStatus, jqXHR) {
				if(data['status'] == 500) {
					alert("Hey! Sorry, but you don't have permission to change statuses.");
				}
				console.log("Server did not allow status to be changed.");
			});
		return false;
	});

	// Show notifications dialog events.
	$('#dashboard').on('click', '.notification-button', function() {
		console.log('Notification dialog click.');
		// var iid = $(this).data('item-id');
		// var cid = $(this).data('id');
		$.get('/notifications/user')
			.success(function(data){
				console.log('Loaded data dialog data.');
				$('#dashboard #edit_notifications_dialog .modal-body').html(data);
				$('#dashboard #edit_notifications_dialog').modal('show');
			})
			.fail(function(jqXHR, textStatus, errorThrown){
				console.log('Error loading dialog data.');
			});
		// });
		return false;
	});

	// Edit notifications form submission.
	$('#dashboard').on('click', '#edit_notifications_dialog .btn-primary', function() {
		console.log('Handling notifications form submission.');
		var f = $('#notifications-form');
		var pid = f.data('pipeline-id;')
		// var stage = $('#status-stage-id').val();

		$.ajax({method : 'POST', data: f.serialize(), url : '/notifications/user_update'})
			.success(function(data, textStatus, jqXHR) {
				console.log("Notifications changed successfully!");
				console.log(data);
				// var li = $('li[data-stage-id=' + stage + '][data-member-id=' + member + ']');
				// var a = $('li[data-stage-id=' + stage + '][data-member-id=' + member + '] a');
				// a.removeClass('complete warning danger pending skipped default');
				// a.addClass(data['code']);
				// li.data('code', data['code']);
				// li.data('notes', data['notes']);
				$('#dashboard #edit_notifications_dialog .modal-body').html('');
				$('#edit_notifications_dialog').modal('hide');
			}).error(function(data, textStatus, jqXHR) {
				if(data['status'] == 500) {
					alert("Hey! Sorry, but you don't have permission to change statuses.");
				}
				console.log("Server did not allow status to be changed.");
			});
		return false;
	});


}
