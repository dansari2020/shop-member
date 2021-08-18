//= require rails-ujs
//= require activestorage
//= require_tree .

$(function () {
  $(".data-explore").click(function () {
    var link = "/explore/" + $("#api").val();
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
