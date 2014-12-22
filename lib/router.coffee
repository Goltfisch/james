Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'

# router mapping
Router.map ->
  @route 'workspaces',
    path: '/'
    onAfterAction: ->
      setTitle i18n('workspaces')
  @route 'resetPassword',
    path: '/reset_password'
    template: 'resetPassword'
    onAfterAction: ->
      setTitle i18n('resetPassword')
  @route 'newPassword',
    path: 'new_password'
    template: 'newPassword'
    onAfterAction: ->
      setTitle i18n('newPassword')
  @route 'signIn',
    path: '/sign_in'
    onAfterAction: ->
      setTitle i18n('signIn')
  @route 'signUp',
    path: '/sign_up'
    onAfterAction: ->
      setTitle i18n('signUp')
  @route 'signOut',
    template: 'signIn'
    path: '/sign_out'
    onBeforeAction: ->
      Meteor.logout ->
        Router.go 'signIn'
      @next()

# filters
isSigendIn = ->
  return unless @ready()
  unless Meteor.loggingIn() or Meteor.user()
    @redirect 'signIn'
  @next()

Router.onBeforeAction isSigendIn,
  except: [
    'signUp'
    'resetPassword'
    'newPassword'
  ]
