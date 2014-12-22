$ ->
  
  $(document).on "click", ".check-out-button", (e) ->
    e.preventDefault()
    
    StripeCheckout.open
      key: $(@).data("key")
      amount: $(@).data("amount")
      currency: "usd"
      name: "SBGuitar"
      description: $(@).data("description")
      email: $(@).data("email")
      zipCode: true
      token: (res) ->
        input = $('<input type=hidden name=stripeToken />').val(res.id)
        $(".check-out-form").append(input).submit()
        false
