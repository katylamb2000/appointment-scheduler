$(document).on('page:update', function(){
  $('#modal-window.in').on('hidden.bs.modal', function () {
    if ($(".modal.in").length === 0) {
      location.reload();
    }
  })
});