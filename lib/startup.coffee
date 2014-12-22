Meteor.startup ->
  i18n.setDefaultLanguage 'de'

  Accounts.config
    sendVerificationEmail: true
    forbidClientAccountCreation: true
