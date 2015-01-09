Meteor.publish 'workspaces', ->
  if @userId
    Workspaces.find collaboratorIds: @userId
  else
    []

Meteor.publish 'workspace', (id) ->
  if @userId
    Workspaces.find _id: id
  else
    []

Meteor.publishComposite 'things', (workspaceId) ->
  if @userId
    find: ->
      Things.find workspaceId: workspaceId
    children: [
      find: (thing) ->
        Meteor.users.find _id: thing.authorId
    ]
  else
    []
