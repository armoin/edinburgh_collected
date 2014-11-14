var runMasonry = function(e) {
  $('#scrapbookImages').waitForImages(function () {
    doIt(this, false);
  });

  $('.masonry-grid').waitForImages(function () {
    doIt(this, true);
  });
};

var doIt = function (container, fitWidth) {
  var $container = $(container),
      $spinner   = $(".masonry-loading-spinner");
      gutter     = parseInt( $('.masonry').css('marginBottom') );

  $spinner.hide();
  $container.show();
  $container.masonry({
    gutter:       gutter,
    itemSelector: '.masonry',
    columnWidth:  '.masonry',
    isFitWidth:   fitWidth
  });
};

// Home Equal Heights

// $(function() {
//   $('.module').matchHeight();
// });

$(window).on('page:load', runMasonry);
$(window).on('load', runMasonry);

