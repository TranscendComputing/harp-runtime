String.prototype.toCamelCase = function(){
	return this.replace(/(\-[a-z])/g, function($1){return $1.toUpperCase().replace('-','');});
};

$(function() {
	$("a.invoke").click(function(evt) {
		var lifecycle = $("#lifecycle").text().toLowerCase();
		debugIt(lifecycle, editor.getValue());
	})
	$(".change_lifecycle").click(function(evt) {
		var lifecycle = $(evt.target).text();
		$("#lifecycle").text(lifecycle);
	})
});

function debugIt(lifecycle, data) {
	var index = 0, breakpoint, args = "";
	$("#script_output").html("");

	$.each(editor.session.getBreakpoints(), function(key, val) {
		if (val && (!breakpoint || key < breakpoint)) {
			breakpoint = key+1;
		} 
	});
	if (breakpoint) {
		args = "&break=" + breakpoint;
	}
    $.ajax({
        type: "POST",
        url: "/api/v1/harp-debug/"+lifecycle+"?access=1234&secret=5678&mock=y&auth=default_creds"+args,
        data: data,
        contentType: "application/x-harp; charset=utf-8",
        dataType: "json",
        success: function (data) { dumpIt(data); },
        failure: function (errMsg) {
            alert(errMsg);
        }
    });
}

function dumpIt(data) {
	$("#script_output").text(prettyResult(data));
}

function prettyResult(data) {
	var msg = "", verb;
	if ('invoked' in data) {
		$.each(data.results, function (index, val) { 
			console.debug("Got:", index, val);
			$.each(val, function (action, desc) { 
				console.debug("Got desc:", desc);
    			if (/create|update|destroy|break/.test(action)) {
    				verb = action.toCamelCase();
    				if (verb = "break") {
    					verb = "broken";
    				} else {
	    				verb += (verb.charAt(verb.length-1) == 'e')? "d":"ed";
    				}
	    			msg += verb + ": " + desc + ".\n" 
	    		}
	    		if (action === "break") {
	    			
	    		}
	    	});
        });
	}
	return msg;
	$("#script_output").html().append(msg);
}