function toggleForm(id, fieldid) {
    subtestField = $('subtest-'+id);
    descField = $('subtest-description-'+id);
    inputField = $('testable_subtests_attributes_'+fieldid+'_saveme');
    legendField = $('subtest-legend-'+id);
    
    subtestField.toggle();
    descField.update('');
    if (inputField.value == 'true') {
	inputField.value = 'false';
	descField.update("This form is " + 
	  "<span class='disabled'>disabled</span>. " + 
	  "<a href='#' onclick='toggleForm(" + id + ", " + fieldid + ");return false;'>" +
	  "Enable</a>");
	legendField.addClassName('disabled');
    }
    else {
	inputField.value = 'true';
	descField.update("This form is enabled. " + 
	  "<a href='#' onclick='toggleForm(" + id + ", " + fieldid + ");return false;'>" +
	  "Disable</a>");
	legendField.removeClassName('disabled');
    }
    return false;
}