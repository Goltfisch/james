# used to check if the user has already verified his E-Mail address
Accounts.validateLoginAttempt (attempt) ->
  if attempt.user and attempt.user.emails and not attempt.user.emails[0].verified
    return false
  true
