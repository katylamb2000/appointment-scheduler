$(document).on('ready page:load', function () {

    $('#new_user').on("submit", function(event) {
        event.preventDefault();
        checkSignupForm();
    });

    var errorMsg;
});

function checkSignupForm() {
    $('.error-message').remove();

    if ( $('#user_email').val() === '' ) {
        $('#user_email').closest('div').append('<div class="error-message">Please enter an email address.</div>');
    }

    if ( $('#user_password').val() === '' ) {
        $('#user_password').closest('div').append('<div class="error-message">Please enter a password.</div>');
    }

    if ( $('#user_password_confirmation').val() === '' ) {
        $('#user_password_confirmation').closest('div').append('<div class="error-message">Please confirm your password.</div>');
    }

    if ( $('#user_first_name').val() === '' ) {
        $('#user_first_name').closest('div').append('<div class="error-message">Please enter your first name.</div>');
    }

    if ( $('#user_age').val() === '' ) {
        $('#user_age').closest('div').append('<div class="error-message">Please enter your age.</div>');
    }

    if ( $('#user_city').val() === '' ) {
        $('#user_city').closest('div').append('<div class="error-message">Please enter your city.</div>');
    }

    if ( $('#user_country').val() === '' ) {
        $('#user_country').closest('div').append('<div class="error-message">Please select your country.</div>');
    }

    if ( !($('#user_accepts_age_agreement').prop('checked'))) {
        $('#user_accepts_age_agreement').closest('div').append('<div class="error-message">You must certify that you are over 18.</div>');
    }

    if ( $('.error-message').size() === 0 ) {
        $('#new_user').submit();
    }
}