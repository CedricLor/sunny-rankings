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
    /* Quick fix to make it work when the email field is not tagged with id="email" */
    if ( this.attrId == "review_temporary_email" ) { this.attrId = "email" }
    this.validity = false;
    this.updateCSS = function() {
      ( this.validity == false ) ?
      DOMSelectedObject.closest('.form-group').addClass("has-error") :
      DOMSelectedObject.closest('.form-group').removeClass("has-error");
    };
    this.regexSelector = function(id) {
      var regex;
      const ids = {
        zip_code() { isNotName() },
        email() { isNotName()  },
        mobile_phone() { isNotName() },
        first_name() { isName() },
        last_name() { isName() },
        city() { isName() },
        other() { regex = regexes['other'] }
      };
      function isNotName() { regex = regexes[id] };
      function isName() { regex = regexes.person_or_city_name };
      (ids[id] || ids['other'] )()
      return regex;
    };
    this.regex = this.regexSelector(this.attrId);
  };

});
