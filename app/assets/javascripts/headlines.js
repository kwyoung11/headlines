// $(document).ready(function() {
// agencies = ["cnn", "reuters", "bbc", "chinadaily", "aljazeera"]

// for (i = 0; i < 6; i++) {
//   requestNewsStories(agencies[i]);  
// }

// requestNewsStories(agencies[5]);  
// function requestNewsStories(agency) {
//   	agency = $("#Agency_select").val();
//     limit = $("#Limit").val();
//     $.ajax({
//       url: "/",
//       data: { agency: agency, limit: limit },
//       success: function(response) {
//         $("#" + agency).html("<%= escape_javascript render("index") %>");
//       },
//       error: function (xhr, textStatus) {
//         alert('Server error: ' + textStatus);
//       }
//     }); // End ajax
// }
// }); // End document ready
