Template.newPassword.events
  'submit #new-password-form': (event, template) ->
    event.preventDefault()

    password = template.find('#password').value

    Accounts.resetPassword Accounts._resetPasswordToken, password, (error) ->
      if error
        if error.message is 'Token expired [403]'
          alert i18n('tokenAlreadyUsed')
        else
          alert i18n('somethingWentWrong')
      else
        Accounts._resetPasswordToken = null
        Router.go('/')

  'click #cancel': (event, template) ->
    event.preventDefault()

    Accounts._resetPasswordToken = null

    Router.go('/')

Template.newPassword.created = ->
  unless Accounts._resetPasswordToken
    Router.go '/'
