/* This displays the legal warning if rating is very low on wage discrimination
or harassment */
$(window).load( function() {
  /* hide the legal warning on load */
  $("#legalWarning").addClass( "hidden" );
  /* create a const to generate legal warning */
  const num_of_issues = {
          1: "a serious issue ",
          2: "serious issues "
        },
        type_of_issue = {
          3: "of wage discrimination. ",
          4: "of sexual harassment. ",
          7: "of wage discrimination and sexual harassment. "
        },
        second_sentence = {
          1: "this is a serious matter. ",
          2: "these are serious matters. "
        }
  /* this function parses the url to identify the language preferences of the user */
  function get_language_preference() {
    var url = window.location.href;
  }
  /* this function generates the legal warning depending on which item have been selected */
  function legal_warning_builder(i, x) {
    get_language_preference();
    legal_warning_sentence = "You are about to report " + num_of_issues[i] + type_of_issue[x] + "Please note that " + second_sentence[i] + "Please review our terms of use of service before doing so.";
  }
  /* set of variables to be used for generating the legal warning */
  var i = 0,
      x = 0;
  /* set of variables to set the handlers on the correct reporting case (i.e. harassment or pay discrim.) */
  const sexual_harassment = "7",
        pay_discrimination = "6";
  /* condition checker for the generation of the legal warning */
  $('#review_form .collection_radio_buttons').on( "click", function() {
    setTimeout(function(){
    serious_harassment = $("#review_answers_attributes_" + sexual_harassment + "_user_rating_1");
    serious_discrimination = $("#review_answers_attributes_" + pay_discrimination + "_user_rating_1");
    /* console.log(serious_harassment); */
    /* console.log(serious_discrimination); */

    if ( $(serious_harassment).prop("checked") &&
         $(serious_discrimination).prop("checked") ) {
      i = 2;
      x = 7;
      $( "#legalWarning" ).text(legal_warning_builder(i, x)).removeClass("hidden");
    } else if ( $(serious_harassment).prop("checked") ) {
      i = 1;
      x = 4;
      $( "#legalWarning" ).text(legal_warning_builder(i, x)).removeClass("hidden");
    } else if ( $(serious_discrimination).prop("checked") ) {
      i = 1;
      x = 3;
      $( "#legalWarning" ).text(legal_warning_builder(i, x)).removeClass("hidden");
    } else {
      $( "#legalWarning" ).text("").addClass("hidden");
    }
    }, 1);
  });
});
