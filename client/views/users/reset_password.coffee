Template.resetPassword.events
  'submit #reset-password-form': (event, template) ->
    event.preventDefault()

    email = template.find('#email').value

    unless email
      alert i18n('emailIsBlank')
    else
      Accounts.forgotPassword
        email: email
      , (error) ->
        if error
          if error.message is 'User not found [403]'
            alert i18n('userNotFound')
          else
            alert i18n('somethingWentWrong')
        else
          Router.go '/'
