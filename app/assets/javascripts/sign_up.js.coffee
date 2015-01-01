checkSignupForm = ->
  removeErrors()

  $(".error-message").remove()

  $("#user_email").closest("div").addClass("has-error")  if $("#user_email").val() is ""

  $("#user_password").closest("div").addClass("has-error")  if $("#user_password").val() is ""

  $("#user_password_confirmation").closest("div").addClass("has-error")  if $("#user_password_confirmation").val() is ""

  $("#user_first_name").closest("div").addClass("has-error")  if $("#user_first_name").val() is ""

  $("#user_age").closest("div").addClass("has-error")  if $("#user_age").val() is ""

  $("#user_city").closest("div").addClass("has-error")  if $("#user_city").val() is ""

  $("#user_country").closest("div").addClass("has-error")  if $("#user_country").val() is ""

  $("#user_accepts_age_agreement").closest("div").addClass("has-error")  unless $("#user_accepts_age_agreement").prop("checked")

  if $(".has-error").size() is 0
    $("#new_user").submit()
  else
    addErrorMessage()

  return

addErrorMessage = ->
  $(".sign-up").closest("div").append "<div class=\"error-message\">* Required fields are in red.</div>"
  return

removeErrors = ->
  errorDivs = $("div.has-error")
  $.each errorDivs, (index, div) ->
    $(div).removeClass "has-error"
    return

  return

$(document).on "ready page:load", ->
  
  $(".sign-up").on "click", (event) ->
    event.preventDefault()
    checkSignupForm()
    return
  
  errorMsg = undefined
  return