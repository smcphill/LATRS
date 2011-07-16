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

function displayChildren (event, obj, caller) {
    hash_vals = eval(caller.id + "s");
    $(caller.id).up().select("dl dd input[type!='hidden'], dl dd select").each(function(item) {
	max_id = item.id.gsub(/_value/,"_max");
	min_id = item.id.gsub(/_value/,"_min");
	curr_selection = caller.value;
	curr_val = new Number(hash_vals.get(curr_selection));
	can_display = true;
	max_val = false;
	min_val = false;
	if (!isNaN(curr_val)) {
	    if ($(max_id)) {
		max_val = new Number(hash_vals.get($(max_id).value));
	    }
	    if ($(min_id)) {
		min_val = new Number(hash_vals.get($(min_id).value));
	    }
	    if ($(min_id) || $(max_id)) {
		can_display = between(curr_val, min_val, max_val);
	    }
	}
	if (can_display && !$(item.id).up().visible()) {
	    new Effect.Appear($(item.id).up().previousSiblings().first());
	    new Effect.Appear($(item.id).up());
	    new Effect.Pulsate(item.id, {pulses: 3});
	    new Effect.Opacity(item.id);
	}
	else if (!can_display) {
	    new Effect.Shake(item.id);
	    new Effect.Fade($(item.id).up());
	    new Effect.Fade($(item.id).up().previousSiblings().first());
	    item.value = '';
	}
    });
}

function between(x, min, max) {
    return x >= min && x <= max;
}