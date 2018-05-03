$(document).ready(function() {		
	$('[name="collection"]').on("input propertychange", function() {
		if ($('[name="collection"]').val().trim().length < 1) {
			$('[name="collectionButton"]').attr('disabled', true);
		} else {
			$('[name="collectionButton"]').attr('disabled', false);
		}
	}
	)
	$('[name="username"]').on("input propertychange", function() {
		if ($('[name="username"]').val().trim().length < 1) {
			$('[name="collectionButton"]').attr('disabled', true);
		} else {
			$('[name="collectionButton"]').attr('disabled', false);
		}
	}
	)
	$(window).keydown(function(event) {
		if (event.keyCode == 13 && $("input").filter(function () {
			return $.trim($(this).val()).length}) == 0) {
			event.preventDefault();
			return false;
		}
	});
});