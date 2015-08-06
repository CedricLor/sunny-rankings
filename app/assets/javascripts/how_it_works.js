function setBoxHeight(cssRowSelector) {
  var maxHeight = 0;
  $('#' + cssRowSelector + ' .card-block').each(function () {
    if ($(this).height() > maxHeight) {
      maxHeight = $(this).height()
    }
  });
  $('#' + cssRowSelector + ' .card-block').height(maxHeight);
}