@Workspaces = new Mongo.Collection 'workspaces'

Meteor.methods
  addWorkspace: (workspace) ->
    throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    throw new Meteor.Error(422, i18n 'nameIsBlank') unless workspace.name
    throw new Meteor.Error(422, i18n 'descriptionIsBlank') unless workspace.description

    Workspaces.insert
      name: workspace.name
      description: workspace.description
      collaboratorIds: [Meteor.userId()]

  updateWorkspace: (workspace) ->
    throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    throw new Meteor.Error(422, i18n 'nameIsBlank') unless workspace.name
    throw new Meteor.Error(422, i18n 'descriptionIsBlank') unless workspace.description

    Workspaces.update
      _id: workspace._id
    ,
      $set:
        name: workspace.name
        description: workspace.description

  deleteWorkspace: (workspace) ->
    throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()

    Workspaces.remove workspace._id

  addCollaborator: (collaborator) ->
    throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()

    user = Meteor.users.findOne emails: $elemMatch: address: collaborator.email

    if user
      Workspaces.update
        _id: collaborator.workspaceId
      ,
        $addToSet:
          collaboratorIds: user._id
    else
      throw new Meteor.Error(422, i18n 'userNotFound')

  removeCollaborator: (collaborator) ->
    throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    throw new Meteor.Error(422, i18n 'cannotRemoveYourself') if Meteor.userId() is collaborator._id

    Workspaces.update
      _id: collaborator.workspaceId
    ,
      $pull:
        collaboratorIds: collaborator._id

Workspaces.before.insert (userId, doc) ->
  doc.createdAt = new Date()
  doc.updatedAt = new Date()

Workspaces.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = new Date()

Workspaces.before.remove (userId, doc) ->
  Things.remove workspaceId: doc._id
