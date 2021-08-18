//= require rails-ujs
//= require activestorage
//= require_tree .
$(document).on("turbolinks: load", function () {
  console.log("turbo loaded");
});
$(function () {
  console.log("loaded");
  $(".data-explore").click(function () {
    console.log("clicked");
    var link = "/explore/" + $("#api").val();
    $("#display-json").text(
      "Please Wait - Fetching the /api/v1/" + $("#api").val() + " API ..."
    );
    $("#display-json").load(link, function (text, textStatus, req) {
      if (textStatus === "error") {
        $(this).text("Error: Please enter a valid API address");
      } else {
        $(this).text(JSON.stringify(JSON.parse(text), null, 2));
      }
    });
    return false;
  });
});
