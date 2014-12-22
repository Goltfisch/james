Template.signUp.events
  'submit #sign-up-form': (event, template) ->
    event.preventDefault()

    username = template.find('#username').value
    email = template.find('#email').value
    password = template.find('#password').value
    passwordConfirmation = template.find('#password-confirmation').value

    user =
      username: username
      email: email
      password: password
      passwordConfirmation: passwordConfirmation

    Meteor.call 'signUp', user, (error) ->
      if error
        alert error.reason
      else
        Router.go '/'
