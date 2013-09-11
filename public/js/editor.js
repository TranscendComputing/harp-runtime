$(function() {
	$("#go_debug").click(function() {
		debugIt(editor.getValue());
	})
});

function debugIt(data) {
    $.ajax({
        type: "POST",
        url: "/api/v1/harp-debug/create?access=1234&secret=5678",
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
	msg = "";
	if ('invoked' in data) {
		$.each(data.results, function (key, val) { 
    		$.each(val.result, function (key, val) { 
    			if (/create|update|delete|nav/.test(key)) {
	    			msg += val + "\n" 
    			}
    		});
        });
	}
	$("#script_output").html(msg);
}

function addIt(data) {
	msg = "";
	if ('invoked' in data) {
		$.each(data.results, function (key, val) { 
    		$.each(val.result, function (key, val) { 
    			msg += val + "\n" 
    		});
        });
	}
	$("#script_output").html().append(msg);
}