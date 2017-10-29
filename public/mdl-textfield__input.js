// This section is from https://github.com/google/material-design-lite/issues/1502 to that issue

(function() {
		componentHandler.registerUpgradedCallback('MaterialTextfield', function(textfield) {
			var input = $(textfield).find('.mdl-textfield__input');
			if (input.data('required') != null) input.attr('required', true);
		});
});
