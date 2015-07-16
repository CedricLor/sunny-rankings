// This is the form checker
// On Document Fully Ready
$(window).load( function() {
  /* Start by disabling the vote button on load*/
  $('#voteButton').prop("disabled",true);

  const regexes = {
    "zip_code": /^(F-)?((2[A|B])|[0-9]{2})[0-9]{3}$/,
    "email": /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i,
    "mobile_phone": /^06[0-9]{8}$/,
    "person_or_city_name": /^[A-Z][a-zA-Z\-]+$/,
    "other": /\w+/
  };

  function myField(DOMSelectedObject) {
    this.textValue = DOMSelectedObject.val();
    this.attrId = DOMSelectedObject.attr("id");
    this.validity = false;
    this.updateCSS = function() {
      ( this.validity == false ) ?
      DOMSelectedObject.closest('.form-group').addClass("has-error") :
      DOMSelectedObject.closest('.form-group').removeClass("has-error");
    };
    this.regexSelector = function(id) {
      var regex;
      const ids = {
        'zip_code': isNotName(),
        'email': isNotName(),
        'mobile_phone': isNotName(),
        'first_name': isName(),
        'last_name': isName(),
        'city': isName(),
        'other': function() { regex = regexes['other'] }
      };
      function isNotName() { regex = regexes[id] };
      function isName() { regex = regexes.person_or_city_name };
      (ids[id] || ids['other'] )();
      return regex;
    };
    this.regex = this.regexSelector(this.attrId);
  };

  myField.prototype.updateValidity = function() {
    ( this.textValue.match(this.regex) ) ? this.validity = true : this.validity = false;
  };

  myChecker = new function() {
    function myFieldsLoader() {
      var myFields = {};
      /* Quick fix to avoid that the form control controls other form fields than the field of
      the review form (such as the search form, for instance) */
      // This selector should select all the fields that need to be validated
      $('#email').each(function() {
        myFields[$(this).attr("id")] = new myField($(this));
      });
      return myFields;
    };
    this.myFields = myFieldsLoader();
    this.are_all_valid = false;
    this.switch_are_all_valid = function() {
      var none_are_invalid = true;
      $.each(this.myFields, function( key, value ) {
        if (value.validity == false) { none_are_invalid = false };
      });
      this.are_all_valid = none_are_invalid;
    };
    this.validityControl = function(id, newValue) {
      this.myFields[id].textValue = newValue;
      this.myFields[id].updateValidity();
      this.myFields[id].updateCSS();
      this.switch_are_all_valid();
    };
  };

  function enable_button() {
    (($('#confirmed_t_and_c').is(':checked')) && myChecker.are_all_valid) ?
      $('#voteButton').prop("disabled",false).removeClass('vote-btn-deactivated').addClass('main-call-to-action-btn') :
      $('#voteButton').prop("disabled",true).addClass('vote-btn-deactivated').removeClass('main-call-to-action-btn');
  };

  // Applying deactivated class to vote button on load
  $('#voteButton').addClass('vote-btn-deactivated');

  // Attach a handler triggered when the check-box is clicked
  $('.cgu').click(function() {
    if ($('#confirmed_t_and_c').is(':checked')) {
      alert("Please agree to the terms of services!");
    }
    enable_button();
  });
  // Attach a handler triggered when the focus goes out of a form field
  // This selector should select all the fields that need to be validated
  $('#email').focusout(function() {
    myChecker.validityControl($(this).attr("id"), $(this).val());
    enable_button();
  });

});
