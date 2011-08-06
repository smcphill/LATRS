function checkState(id, fieldid) {
    if ($F('testable_subtests_attributes_'+fieldid+'_saveme') == "true" &&
         !$('subtest-'+id).visible()) {
	 enableForm(id, fieldid, getFields(id, fieldid));
    }
}

function enableForm(id, fieldid, fields) {
    $(fields.get('input')).value = 'true';
    $(fields.get('desc')).update("This form is enabled. " +
        "<a href='#' onclick='toggleForm(" + id + ", " + fieldid + ");return false;'>" +
	"Disable</a>");
    if ($(fields.get('legend'))) {
      $(fields.get('legend')).removeClassName('disabled');
    }
    if ($(fields.get('subtest'))) {
      $(fields.get('subtest')).show();
    }
}

function disableForm(id, fieldid, fields) {
    $(fields.get('input')).value = 'false';
    $(fields.get('desc')).update("This form is " +
        "<span class='disabled'>disabled</span>. " +
	"<a href='#' onclick='toggleForm(" + id + ", " + fieldid + ");return false;'>" +
	"Enable</a>");
    if ($(fields.get('legend'))) {
      $(fields.get('legend')).addClassName('disabled');
    }
    if ($(fields.get('subtest'))) {
      $(fields.get('subtest')).hide();
    }
}

function getFields(id, fieldid) {
    return new Hash({'subtest':'subtest-'+id, 
                     'desc':'subtest-description-'+id, 
		     'input':'testable_subtests_attributes_'+fieldid+'_saveme', 
		     'legend':'subtest-legend-'+id});
}

function toggleForm(id, fieldid) {
    fields = getFields(id, fieldid)
    $(fields.get('desc')).update('');

    if ($(fields.get('input')).value == 'true') {
        disableForm(id, fieldid, fields);
    }
    else {
        enableForm(id, fieldid, fields);
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
	else if ($(max_id) || $(min_id)) {
	    can_display = false;
	}
	if (can_display && !$(item.id).up().visible()) {
	    new Effect.Appear($(item.id).up().previousSiblings().first());
	    new Effect.Appear($(item.id).up());
	    new Effect.Pulsate(item.id, {pulses: 3});
	    new Effect.Opacity(item.id);
	    $(item.id).enable();
	}
	else if (!can_display) {
	    new Effect.Shake(item.id);
	    new Effect.Fade($(item.id).up());
	    new Effect.Fade($(item.id).up().previousSiblings().first());
	    $(item.id).disable();
	}
    });
}

function between(x, min, max) {
    return x >= min && x <= max;
}

function patientInfo(rn) {
    new Ajax.Updater('patient-info',
		     '/entry/patients/rn/' + rn,
		     {
			 onCreate: function () { $('patient-loading').setStyle({visibility:'visible'}); },
			 onComplete: function () { $('patient-loading').setStyle({visibility:'hidden'}); $('patient-info').fire('latrs:patientloaded');}
		     });
}