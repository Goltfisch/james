Meteor.publish 'workspaces', ->
  if @userId
    Workspaces.find collaborators: @userId
  else
    []

Meteor.publish 'workspace', (id) ->
  if @userId
    Workspaces.find _id: id
  else
    []
