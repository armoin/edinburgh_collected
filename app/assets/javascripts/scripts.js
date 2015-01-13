var runMasonry = function(e) {
  $('#contentModules').waitForImages(function () {
    $('.module').matchHeight();
  });

  $('#scrapbookImages').waitForImages(function () {
    var $container = $(this),
        $spinner   = $(".masonry-loading-spinner");
        gutter     = parseInt( $('.masonry').css('marginBottom') );

    $spinner.hide();
    $container.parent().show();
    $container.packery({
      itemSelector: '.item',
      gutter: 10,
      isOriginLeft: false
    });
  });

  $('.masonry-grid').waitForImages(function () {
    var $container = $(this),
        $spinner   = $(".masonry-loading-spinner");
        gutter     = parseInt( $('.masonry').css('marginBottom') );

    $spinner.hide();
    $container.parent().show();
    $container.masonry({
      itemSelector: '.masonry',
      columnWidth:  '.masonry',
      gutter: gutter,
      fitWidth: true,
    });
  });
};

$(window).on('page:load', runMasonry);
$(window).on('load', runMasonry);


$(document).ready(function () {
  var setHeightBoxes = $("#profileHeader .wrapper").outerHeight();
  $('.stats a').height(setHeightBoxes -45)
});


$(document).ready(function() {



// Add memories panel



//ALAN I CAN"T GET THIS TO WORK CAN YOU LOOK AT IT?

$('.navbar-header').on('show.bs.dropdown', function () {
 alert('this works');
})


});
