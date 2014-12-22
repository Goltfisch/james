Accounts.emailTemplates.siteName = 'James'
Accounts.emailTemplates.from = 'James <noreply@james.com>'

Accounts.emailTemplates.verifyEmail =
  subject: (user) ->
    i18n('emailTemplates.verifyEmail.subject')
  text: (user, url) ->
    i18n('emailTemplates.verifyEmail.text') + '\n\n' + url

Accounts.emailTemplates.resetPassword =
  subject: (user) ->
    i18n('emailTemplates.resetPassword.subject')
  text: (user, url) ->
    i18n('emailTemplates.resetPassword.text') + '\n\n' + url
