function updatePreview(){
	var settings = [];
	settings[0] = $('#showTweets').attr('checked') ? 1 : 0;
	settings[1] = $('#showFaces').attr('checked') ? 1 : 0;
	settings[2] = $('#numberRows').attr('value');
	settings[3] = $('#width').attr('value');
	settings[4] = $('#height').attr('value');
	settings[5] = $('#backgroundColor').attr('value').substr(1, 6);
	settings[6] = $('#backgroundTransparent').attr('value');
	settings[7] = $('#borderColor').attr('value').substr(1, 6);
	settings[8] = $('#foregroundColor').attr('value').substr(1, 6);
	var code = '<!-- BEGIN: Twitter Website Box (http://twitterforweb.com) -->'
					+'\n'+'<div style="width:'+settings[3]+'px;font-size:8px;text-align:right;"><script type="text/javascript">'
					+'//<![CDATA['
					+'\n'+'document.write(unescape("%3Cscript src=\'http://twitterforweb.com/twitterbox.js?username='+escape($('#username').attr('value'))+'&settings='+settings.join(',')+'\' type=\'text/javascript\'%3E%3C/script%3E"));'
					+'\n'+'//]]>'
					+'</script>Created by: <a href="http://twitterforweb.com">Twitter on web</a></div>'
					+'\n'+'<!-- END: Twitter Website Box (http://twitterforweb.com) -->';
	try {
		document.getElementById('code').value=code;
	} catch(e) {
		document.getElementById('code').innerHTML=code.replace(/\</g, '&lt;').replace(/\>/g, '&gt;');
	}
	
	$('#previewContent').html(' ').css('height', (parseInt($('#height').attr('value')) + 20)+'px').attr('class', 'loading');
	$.getScript('/twitterbox.js?_rnd='+(new Date()).getTime()+'&username='+escape($('#username').attr('value'))+'&settings='+settings.join(',')+'&from=twitterforweb');
	return false;
};

function updateHeight(){
	showTweets = $('#showTweets').attr('checked') ? 1 : 0;
	showFaces = $('#showFaces').attr('checked') ? 1 : 0;
	numberRows = parseInt($('#numberRows').attr('value'));
	width = parseInt($('#width').attr('value'));
	
	if (!showFaces && !showTweets) {
		$('#height').attr('value', 75 + (width < 190 ? 15 : 0));
	}
	else if (!showFaces) {
		$('#height').attr('value', 75 + 430);
	}
	else if (!showTweets) {
		$('#height').attr('value', 95 + 32 + numberRows*76 + (width < 190 ? 15 : 0));
	}
	else {
		$('#height').attr('value', 75 + 32 + numberRows*76 + 215);
	}
};

var $_memoryValue = '';

$(document).ready(function() {
	updateHeight();
	updatePreview();
	$('#backgroundColor').ColorPicker({
		onSubmit: function(hsb, hex, rgb, el) {
			$(el).val('#'+hex);
			$(el).ColorPickerHide();
			if ($('#backgroundColor').attr('value') != $_memoryValue) {
				$_memoryValue = $('#backgroundColor').attr('value');
				updatePreview();
			}
		},
		onChange: function(hsb, hex, rgb, el) {
			$('#backgroundColor').val('#'+hex);
		},
		onBeforeShow: function () {
			$_memoryValue = this.value;
			$(this).ColorPickerSetColor(this.value);
		},
		onHide: function (hsb) {
			if ($('#backgroundColor').attr('value') != $_memoryValue) {
				$_memoryValue = $('#backgroundColor').attr('value');
				updatePreview();
			}
		}
	});
	$('#borderColor').ColorPicker({
		onSubmit: function(hsb, hex, rgb, el) {
			$(el).val('#'+hex);
			$(el).ColorPickerHide();
			if ($('#borderColor').attr('value') != $_memoryValue) {
				$_memoryValue = $('#borderColor').attr('value');
				updatePreview();
			}
		},
		onChange: function(hsb, hex, rgb, el) {
			$('#borderColor').val('#'+hex);
		},
		onBeforeShow: function () {
			$_memoryValue = this.value;
			$(this).ColorPickerSetColor(this.value);
		},
		onHide: function (hsb) {
			if ($('#borderColor').attr('value') != $_memoryValue) {
				$_memoryValue = $('#borderColor').attr('value');
				updatePreview();
			}
		}
	});
	$('#foregroundColor').ColorPicker({
		onSubmit: function(hsb, hex, rgb, el) {
			$(el).val('#'+hex);
			$(el).ColorPickerHide();
			if ($('#foregroundColor').attr('value') != $_memoryValue) {
				$_memoryValue = $('#foregroundColor').attr('value');
				updatePreview();
			}
		},
		onChange: function(hsb, hex, rgb, el) {
			$('#foregroundColor').val('#'+hex);
		},
		onBeforeShow: function () {
			$_memoryValue = this.value;
			$(this).ColorPickerSetColor(this.value);
		},
		onHide: function (hsb) {
			if ($('#foregroundColor').attr('value') != $_memoryValue) {
				$_memoryValue = $('#foregroundColor').attr('value');
				updatePreview();
			}
		}
	});
	$('#backgroundTransparent').bind('change', function() {
		$('#backgroundColor').attr('disabled', this.value == 1);
		return updatePreview();
	});
	$('#showTweets').bind('change', function() {
		updateHeight();
		return updatePreview();
	});
	$('#showFaces').bind('change', function() {
		$('#numberRows').attr('disabled', !this.checked);
		updateHeight();
		return updatePreview();
	});
	$('#numberRows').bind('change', function() {
		updateHeight();
		return updatePreview();
	});
	$('#username, #width, #height').bind('focus', function() {
		$_memoryValue = this.value;
	}).bind('blur', function() {
		if (this.value != $_memoryValue) {
			return updatePreview();
		}
	});
	$('#code').bind('focus', function() {
		try {
			this.select();
		} catch (e){};
	});
	$('#twitterForm').bind('submit', function() {
		return updatePreview();
	});
	$('#resetButton').bind('click', function() {
		$('#showTweets').attr('checked', true);
		$('#showFaces').attr('checked', true);
		$('#numberRows').attr('value', 3).attr('disabled', false);
		$('#width').attr('value', 236);
		$('#backgroundColor').attr('value', '#f4f4f4').attr('disabled', false);
		$('#backgroundTransparent').attr('value', 0);
		$('#borderColor').attr(0, '#c4c4c4');
		$('#foregroundColor').attr('value', '#101010');
		updateHeight();
		return updatePreview();
	});
});
