$(document).ready(function() {		
		$('input:file').change(function() {
		if ($(this).val()) {
			$('#fileSub').attr('disabled', false);
			// or, as has been pointed out elsewhere:
			// $('input:submit').removeAttr('disabled'); 
		}
	});
	$("#txtArea").on("input propertychange", function() {
		if ($("#txtArea").val().trim().length < 1) {
			$('#txtSub').attr('disabled', true);
		} else {
			$('#txtSub').attr('disabled', false);
		}
	}

	)
	$('#txtArea').each(function () {
		  this.setAttribute('style', 'height:' + (this.scrollHeight) + 
				  'px;overflow-y:hidden;margin:auto;');
		}).on('input', function () {
		  this.style.height = 'auto';
		  this.style.height = (this.scrollHeight) + 'px';
		});
});