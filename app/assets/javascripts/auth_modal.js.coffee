$.fn.authModal = (isRegister = true) ->
  $(@).each ->
    if isRegister
      $(@).find(".sign-in").hide()
    else
      $(@).find(".register").hide()

    $(@).find("a.toggle").click (e) =>
      e.preventDefault()
      $(@).find(".auth").toggle()

    $(@).find("form").submit =>
      $(@).find(".auth:hidden").remove()