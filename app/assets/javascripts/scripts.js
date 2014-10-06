// Load is used to ensure all images have been loaded, impossible with document

var masonryIt = function () {

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

			post_width = jQuery('.memory').width() + gutter;
			jQuery('#memories, body > #grid').css('width', 'auto');



			// Calculates how many .memory elements will actually fit per row. Could this code be cleaner?

			posts_per_row = jQuery('#memories').innerWidth() / post_width;
			floor_posts_width = (Math.floor(posts_per_row) * post_width) - gutter;
			ceil_posts_width = (Math.ceil(posts_per_row) * post_width) - gutter;
			posts_width = (ceil_posts_width > jQuery('#memories').innerWidth()) ? floor_posts_width : ceil_posts_width;
			if (posts_width == jQuery('.memory').width()) {
				posts_width = '100%';
			}



			// Ensures that all top-level elements have equal width and stay centered

			jQuery('#memories, #grid').css('width', posts_width);
			jQuery('#grid').css({'margin': '0 auto'});



		}
	}).trigger('resize');



};

jQuery(window).on('load', masonryIt);
jQuery(window).on('page:load', masonryIt);
