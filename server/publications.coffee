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
