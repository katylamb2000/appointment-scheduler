$ ->
  loadThumb ->

loadThumb = ->
  $(".load_thumb").each (index, el) ->
    user_id = $(el).data('id')
    url = '/user/' + user_id + '/profile_photo_processing'
    setTimeout (-> pollForArtworkThumb(url)), 1000
    
pollForArtworkThumb = (to) ->
  $.get(
    to
    (data, status) ->
      if data.loading
        setTimeout (-> pollForArtworkThumb(to)), 1000
      else
        $('#spinner-photo').hide()
        $('#profile-photo').append '<img alt="Thumb" id="user-photo" src="' + data.url + '" style="display: inline;">'
  )
