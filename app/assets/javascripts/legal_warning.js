/* This displays the legal warning if rating is very low on wage discrimination
or harassment */
$(window).load( function() {
  /* hide the legal warning on load */
  $("#legalWarning").addClass( "hidden" );
  /* create a const to generate legal warning */
  const num_of_issues = {
          1: {
            "en": "a serious issue of ",
            "fr": "un problème sérieux sur la politique de lutte contre "
          },
          2: {
            "en": "serious issues of ",
            "fr": "des problèmes sérieux sur les politiques de lutte contre "
          }
        },
        type_of_issue = {
          3: {
            "en": "wage discrimination. ",
            "fr": "les discriminations de rémunération. "
          },
          4: {
            "en": "sexual harassment. ",
            "fr": "le harcélement sexuel. "
          },
          7: {
            "en": "wage discrimination and sexual harassment. ",
            "fr": "les discriminations de rémunération et contre le harcélement sexuel. "
          }
        },
        end_of_second_sentence = {
          1: {
            "en": "this is a serious matter. ",
            "fr": "il s'agit d'affirmations graves. "
          },
          2: {
            "en": "these are serious matters. ",
            "fr": "il s'agit d'affirmations graves. "
          }
        },
        beginning_of_warning = {
          "en": "You are about to report ",
          "fr": "Vous êtes sur le point de rapporter "
        },
        beginning_of_second_sentence = {
          "en": "Please note that ",
          "fr": "Veuillez noter qu'"
        },
        last_sentence = {
          "en": "Please review our terms of use of service before doing so.",
          "fr": "Merci de lire attentivement les termes et conditions avant de voter."
        }
  /* this function parses the url to identify the language preferences of the user */
  function get_language_preference() {
    var language = "";
    (/\/fr\//.test(window.location.href)) ? language = "fr" : language = "en";
    return language;
  }
  /* this function generates the legal warning depending on which item have been selected */
  function legal_warning_builder(i, x) {
    language = get_language_preference();
    legal_warning_sentence = beginning_of_warning[language] + num_of_issues[i][language] + type_of_issue[x][language] + beginning_of_second_sentence[language] + end_of_second_sentence[i][language] + last_sentence[language];
    return legal_warning_sentence
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
