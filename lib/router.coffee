Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'

# controllers
WorkspaceController = RouteController.extend
  thingsSubscriptionHandle: ->
    Meteor.subscribeWithPagination 'things', @params._id, Session.get('searchQuery'), Session.get('selectedTags'), 20
  waitOn: ->
    Meteor.subscribe 'workspace', @params._id
    @thingsSubscriptionHandle()
    Meteor.subscribe 'allTags', @params._id
  data: ->
    workspace: Workspaces.findOne _id: @params._id
    tags: Tags.find {}
    ,
      sort:
        name: 1
    things: Things.find {}
    ,
      sort:
        updatedAt: -1
    thingsSubscriptionHandle: @thingsSubscriptionHandle()

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

CollaboratorsController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'collaborators', @params._id
  data: ->
    workspace: Workspaces.findOne _id: @params._id
    collaborators: Meteor.users.find {}
    ,
      sort:
        username: 1

# router mapping
Router.map ->
  @route 'workspace',
    path: '/workspace/:_id'
    controller: WorkspaceController
    onAfterAction: ->
      setTitle Workspaces.findOne().name if Workspaces.findOne()
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
  @route 'collaborators',
    path: '/workspaces/:_id/collaborators'
    controller: CollaboratorsController
    onAfterAction: ->
      setTitle i18n('collaborators')
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
