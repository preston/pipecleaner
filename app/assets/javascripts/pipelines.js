// For the pipeline edit page only!

// Case-insensitive icontains selector.
$.expr[':'].icontains = function(a, i, m) {
  return jQuery(a).text().toUpperCase()
      .indexOf(m[3].toUpperCase()) >= 0;
};

function filterWorkItems(q) {
	console.log("Searching work items for: " + q);
	if(q == null) {
		$('.work-item-list > li').show();
	} else {
		$('.work-item-list.associated		> li:not(:icontains(' + q + '))').hide(); 
		$('.work-item-list.associated		> li:icontains(' + q + ')').show();
		$('.work-item-list.disassociated	> li:not(:icontains(' + q + '))').hide(); 
		$('.work-item-list.disassociated	> li:icontains(' + q + ')').show();
	}
}

$(function() {
	var mom = $('#pipeline-order');

	// Tooltips
	$('#pipeline-edit .tip').tooltip();

	// Stage ordering
	mom.sortable({update : function(event, ui){
		console.log('Stages reordered! Updating server.');
		var order = [];
		$('#pipeline-order li').each(function(){
			var me = $(this);
			order.push(me.data('stage-id'));
		});
		var pid = $('#pipeline-order').data('pipeline-id');
		var url = '/pipelines/' + pid + '/reorder';
		$.ajax({
			method : 'PUT',
			url : url,
			data : {order : order},
			success : function() {
				console.log('Server updated with new stage ordering.');
			}
		});
	}});
	// mom.disableSelection();

	// Stage edit buttons
	$('.stage .icon-edit').click(function() {
		var me = $(this);
		var pid = $('#pipeline-order').data('pipeline-id');
		window.location = '/pipelines/' + pid + '/stages/' + me.data('stage-id') + '/edit';
	});

	// Stage delete buttons
	$('.stage .icon-trash').click(function() {
		var me = $(this);
		var sid = me.data('stage-id');
		console.log("Deleting stage ID: " + sid);
		var pid = $('#pipeline-order').data('pipeline-id');
		var url = '/pipelines/' + pid + '/stages/' + me.data('stage-id');
		$.ajax({method : 'DELETE', url : url, success : function(data, textStatus, jqXHR) {
			console.log("Remove stage from screen.");
			$('#stage_' + sid).remove();
		}});
	});

	// Work item members
	$('#pipeline-edit .associated').sortable({connectWith : '.work-item-list', receive : function(event, ui){
		console.log("Associating item with pipeline.");
		var pid = $('#pipeline-order').data('pipeline-id');
		var iid = ui.item.data('item-id');
		var url = '/items/' + iid + '/associate';
		$.ajax({
			method : 'PUT',
			url : url,
			data : {pipeline_id : pid},
			success : function() {
				console.log('Server associated work item with pipeline.');
			}
		});
	}}).disableSelection();

	// Work item non-members
	$('#pipeline-edit .disassociated').sortable({connectWith : '.work-item-list', receive : function(event, ui){
		console.log("Disassociating item with pipeline.");
		var pid = $('#pipeline-order').data('pipeline-id');
		var iid = ui.item.data('item-id');
		var url = '/items/' + iid + '/disassociate';
		$.ajax({
			method : 'PUT',
			url : url,
			data : {pipeline_id : pid},
			success : function() {
				console.log('Server disassociated work item with pipeline.');
			}
		});
	}}).disableSelection();

	// Work item search feature
	$('#work-item-search').keyup(function(){
		var q = $(this).val();
		filterWorkItems(q);
	});
});
