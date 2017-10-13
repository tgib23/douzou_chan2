$ ->
  $('#content').imagesLoaded ->
    $('#content').masonry
      itemSelector: '.box'
      columnWidth: 10
      isAnimated: true
      gutterWidth: 2

