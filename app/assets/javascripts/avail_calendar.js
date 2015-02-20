$(document).on('page:update', function(){

  $('#avail-calendar').fullCalendar({
    events: {
      url: 'api/v1/availabilities.json',
      type: 'GET',
      data: {
        user_id: $('#avail-calendar').attr('data-user')
      }
    },
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    dayClick: function(date, jsEvent, view) {
      $.ajax({
        url: '/availabilities/new.js',
        type: 'GET',
        data: { start_date: date.format() }
      });
    },
    eventClick: function(calEvent, jsEvent, view) {
      $.ajax({
        url: '/availabilities/' + calEvent.id + '/edit',
        type: 'GET',
        data: {
          start_date: calEvent.start.format(),
          end_date: calEvent.end.format()
        }
      });
    }
  })

});