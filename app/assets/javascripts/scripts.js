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
        gutter     = 0;

    $spinner.hide();
    $container.parent().show();
    $container.packery({
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


$(document).ready(function () {

 if ($(window).width() > 480) {
  var windowHeight = $( window ).height();
  var everythingElseHeight = $('#main-header').outerHeight() + $('#contentHeader').outerHeight() + $('#details header').outerHeight()
  $('#image img').css( 'height', windowHeight - everythingElseHeight );
  $('#memoryImage').css( 'height', windowHeight - everythingElseHeight );

 } else {

  var windowHeight = $( window ).height();
  $('#image a').css( 'max-height', windowHeight * 0.8 );

  }
})