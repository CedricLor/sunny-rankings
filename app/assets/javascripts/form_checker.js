// This is the form checker
// On Document Fully Ready
$(window).load( function() {
  const fields_identifier = "#email"
  const checkbox_identifier = "#confirmed_t_and_c"
  const vote_button_identifier = ".vote-button"

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
        zip_code: function() { isNotName() },
        email: function() { isNotName() },
        mobile_phone: function() { isNotName() },
        first_name: function() { isName() },
        last_name: function() { isName() },
        city: function() { isName() },
        other: function() { regex = regexes['other'] }
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
      $(fields_identifier).each(function() {
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
    this.controlAll = function(allFields) {
      $(allFields).each(function() {
        myChecker.validityControl($(this).attr("id"), $(this).val());
      });
    };
  };

  function enable_button() {
    myChecker.controlAll(fields_identifier);
    if (($(checkbox_identifier).is(':checked')) && myChecker.are_all_valid) {
      $(vote_button_identifier).prop("disabled",false).removeClass('vote-btn-deactivated').addClass('main-call-to-action-btn');
      $(vote_button_identifier).focus();
    } else {
      $(vote_button_identifier).prop("disabled",true).addClass('vote-btn-deactivated').removeClass('main-call-to-action-btn');
      var from_field;
      if (arguments.length == 1) {
        from_field = arguments[0];
        $(from_field).focus( function(){this.value = this.value} ).focus();
      };
    };
  };

  // Applying deactivated class to vote button on load
  /* Disabling the vote button on load*/
  $(vote_button_identifier).addClass('vote-btn-deactivated').prop("disabled",true);
  myChecker.controlAll(fields_identifier);
  enable_button();

  // Attach a handler triggered when the check-box is clicked
  $(checkbox_identifier).click(function() {
    if (!($(checkbox_identifier).is(':checked'))) {
      alert("Please agree to the terms of services!");
    }
    enable_button();
  });
  // Attach a handler triggered when the focus goes out of a form field
  // This selector should select all the fields that need to be validated
  $(fields_identifier).focusout(function() {
    enable_button("#" + this.id);
  });

});
