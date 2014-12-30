Meteor.methods
  signUp: (user) ->
    throw new Meteor.Error(422, i18n 'usernameIsBlank') unless user.username
    throw new Meteor.Error(422, i18n 'emailIsBlank') unless user.email
    throw new Meteor.Error(422, i18n 'passwordIsBlank') unless user.password
    throw new Meteor.Error(422, i18n 'passwordConfirmationIsBlank') unless user.passwordConfirmation
    throw new Meteor.Error(422, i18n 'passwordsDontMatch') if user.password isnt user.passwordConfirmation

    newUserId = Accounts.createUser(
      username: user.username.toLowerCase().trim()
      email: user.email
      password: user.password
    )

    Meteor.defer ->
      Accounts.sendVerificationEmail(newUserId)
