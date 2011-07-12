function toggleForm(id, fieldid) {
    $('subtest-'+id).toggle();
    if ($('testable_subtests_attributes_'+fieldid+'_saveme').value == 'true') {
	$('testable_subtests_attributes_'+fieldid+'_saveme').value = 'false';
    }
    else {
	$('testable_subtests_attributes_'+fieldid+'_saveme').value = 'true';
    }
}