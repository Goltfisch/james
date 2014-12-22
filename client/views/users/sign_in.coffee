Template.signIn.events
  'submit #sign-in-form': (event, template) ->
    event.preventDefault()

    email = template.find('#email').value
    password = template.find('#password').value

    Meteor.loginWithPassword email, password, (error) ->
      if error
        alert error.reason
      else
        Router.go '/'

Template.signIn.created = ->
  # if the user wants to verify his E-Mail Address
  if Accounts._verifyEmailToken
    Accounts.verifyEmail Accounts._verifyEmailToken, (error) ->
      if error?
        alert i18n('verifyEmailLinkExpired') if error.message = 'Verify email link expired [403]'
      else
        Accounts._verifyEmailToken = null
        alert i18n('emailAddressConfirmed')

  # if the user has requested a new password
  if Accounts._resetPasswordToken
    Router.go 'newPassword'
