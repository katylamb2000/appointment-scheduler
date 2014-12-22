$(document).on('page:update', function(){
  $('#modal-window.in').on('hidden.bs.modal', function () {
    location.reload(); // TODO perfect
  })
});