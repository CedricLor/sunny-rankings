function getLocationAndRedirect() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(geoSuccess, geoError, {enableHighAccuracy: false, timeout: 10000, maximumAge: 120000});
  }

  function geoSuccess(positionInfo) {
    document.getElementById("longitudeSearch").value = positionInfo.coords.longitude;
    document.getElementById("latitudeSearch").value = positionInfo.coords.latitude;
    $("#navbarGeoSearchButton").click();
  }

  function geoError(positionError) {
    if (errorInfo.code == 1)
      console.log("The user denied permission access");
    else if (errorInfo.code == 2)
      console.log("Unable to locate the user");
    else if (errorInfo.code == 3)
      console.log("Timed out getting location");
  }
}
