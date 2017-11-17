// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require moment
//= require async
//= require ./application/vendor/toastr.min.js
//= require ./application/vendor/quill.min.js

$(document).ready(function(){
  var _$currentModal = null;

  $('body').on('click', '.close-modal', function (e) {
    if (_$currentModal) _$currentModal.remove();
    _$currentModal = null;
  });

  $('body').on('click', '.open-modal', function (e) {
    var $link = $(this);
    var modalURL = $link.attr('data-modal-url');

    e.preventDefault();

    if (!modalURL) return;

    // Add .modal extension to get only the modal html
    $.get(modalURL + ".modal").then(function (data) {
      var $modal = $(data);

      if (_$currentModal) _$currentModal.remove();
      $(document.body).append($modal);

      _$currentModal = $modal;
    });
  })
});

// Toaster options!
toastr.options = {
  "closeButton": true,
  "debug": false,
  "newestOnTop": false,
  "progressBar": false,
  "positionClass": "toast-bottom-right",
  "preventDuplicates": true,
  "onclick": null,
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "5000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
}
