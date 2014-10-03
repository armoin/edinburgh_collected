// Load is used to ensure all images have been loaded, impossible with document

jQuery(window).load(function () {



	// Takes the gutter width from the bottom margin of .memory

	var gutter = parseInt(jQuery('.memory').css('marginBottom'));
	var container = jQuery('#memories');



	// Creates an instance of Masonry on #memories

	container.masonry({
		gutter: gutter,
		itemSelector: '.memory',
		columnWidth: '.memory'
	});



	// This code fires every time a user resizes the screen and only affects .memory elements
	// whose parent class isn't .container. Triggers resize first so nothing looks weird.

	jQuery(window).bind('resize', function () {
		if (!jQuery('#memories').parent().hasClass('container')) {



			// Resets all widths to 'auto' to sterilize calculations

			memory_width = jQuery('.memory').width() + gutter;
			jQuery('#memories, body > #grid').css('width', 'auto');



			// Calculates how many .memory elements will actually fit per row. Could this code be cleaner?

			memories_per_row = jQuery('#memories').innerWidth() / memory_width;
			floor_memories_width = (Math.floor(memories_per_row) * memory_width) - gutter;
			ceil_memories_width = (Math.ceil(memories_per_row) * memory_width) - gutter;
			memories_width = (ceil_memories_width > jQuery('#memories').innerWidth()) ? floor_memories_width : ceil_memories_width;
			if (memories_width == jQuery('.memory').width()) {
				memories_width = '100%';
			}



			// Ensures that all top-level elements have equal width and stay centered

			jQuery('#grid').css({'margin': '0 auto'});



		}
	}).trigger('resize');



});