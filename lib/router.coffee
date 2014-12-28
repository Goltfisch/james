Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'

# controllers
WorkspacesController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'workspaces'
  data: ->
    workspaces: Workspaces.find()

UpdateWorkspaceController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'workspace', @params._id
  data: ->
    workspace: Workspaces.findOne _id: @params._id

# router mapping
Router.map ->
  @route 'workspaces',
    path: '/'
    controller: WorkspacesController
    onAfterAction: ->
      setTitle i18n('workspaces')
  @route 'addWorkspace',
    path: '/workspaces/add'
    onAfterAction: ->
      setTitle i18n('addWorkspace')
  @route 'updateWorkspace',
    path: '/workspaces/:_id/update'
    controller: UpdateWorkspaceController
    onAfterAction: ->
      setTitle i18n('updateWorkspace')
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

forbiddenRoutesWhenSignedIn = ->
  return unless @ready()
  if Meteor.loggingIn() or Meteor.user()
    @redirect '/'
  @next()

Router.onBeforeAction forbiddenRoutesWhenSignedIn,
  only: [
    'signUp'
    'signIn'
    'resetPassword'
    'newPassword'
  ]

Router.onBeforeAction isSigendIn,
  except: [
    'signUp'
    'resetPassword'
    'newPassword'
  ]
