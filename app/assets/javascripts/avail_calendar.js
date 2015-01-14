$(document).ready(function() {

    $('#avail-calendar').fullCalendar({
      events: {
        url: 'api/v1/availabilities.json',
        type: 'GET',
        data: {
          user_id: $('#avail-calendar').attr('data-user'),
        }
      }
    })

});