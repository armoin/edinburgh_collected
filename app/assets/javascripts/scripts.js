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
  $('.module').matchHeight();
  $container.parent().show();
  $container.masonry({
    gutter:       gutter,
    itemSelector: '.masonry',
    columnWidth:  '.masonry',
    isFitWidth:   fitWidth
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
var tabWidth = $('#scrapbook .actions a.memories').outerWidth();
$('#addMemoriesDrawer #tab').css("width", tabWidth);

$('#addMemoriesDrawer').hide();

$( "#scrapbook .actions a.memories" ).click(function() {
  $(this).toggleClass('active');
  $( "#addMemoriesDrawer" ).toggle();
});


// Add memories panel



//ALAN I CAN"T GET THIS TO WORK CAN YOU LOOK AT IT?

$('.navbar-header').on('show.bs.dropdown', function () {
 alert('this works');
})


});
