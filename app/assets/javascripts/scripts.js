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


  $("#toggleMenu").on("click", mobileMenu );

  var menuAction = 1;

  function mobileMenu() {
    if ( menuAction == 1 ) {
      $('#toggleMenu').addClass( "active" );
      $('ul.menu').show();
          menuAction = 2;
      } else {
          $('#toggleMenu').removeClass( "active" );
          $('ul.menu').hide();
          menuAction = 1;
      }
  };


  $(function(){
    if ($(window).width() < 768) {
      var menuHeight = $(window).height() - $('#toggleMenu').outerHeight()
      $("ul.menu").height(menuHeight)
    };
   });

});


