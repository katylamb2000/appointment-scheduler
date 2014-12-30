checkSignupForm = ->
  $(".error-message").remove()
  $("#user_email").closest("div").after "<div class=\"error-message\">Please enter an email address.</div>"  if $("#user_email").val() is ""
  $("#user_password").closest("div").after "<div class=\"error-message\">Please enter a password.</div>"  if $("#user_password").val() is ""
  $("#user_password_confirmation").closest("div").after "<div class=\"error-message\">Please confirm your password.</div>"  if $("#user_password_confirmation").val() is ""
  $("#user_first_name").closest("div").after "<div class=\"error-message\">Please enter your first name.</div>"  if $("#user_first_name").val() is ""
  $("#user_age").closest("div").after "<div class=\"error-message\">Please enter your age.</div>"  if $("#user_age").val() is ""
  $("#user_city").closest("div").after "<div class=\"error-message\">Please enter your city.</div>"  if $("#user_city").val() is ""
  $("#user_country").closest("div").after "<div class=\"error-message\">Please select your country.</div>"  if $("#user_country").val() is ""
  $("#user_accepts_age_agreement").closest("div").after "<div class=\"error-message\">You must certify that you are over 18.</div>"  unless $("#user_accepts_age_agreement").prop("checked")
  $("#new_user").submit()  if $(".error-message").size() is 0
  return
$(document).on "ready page:load", ->
  $("#new_user").on "submit", (event) ->
    event.preventDefault()
    checkSignupForm()
    return

  errorMsg = undefined
  return