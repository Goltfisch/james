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

Meteor.publishComposite 'things', (workspaceId, limit) ->
  if @userId
    find: ->
      Things.find
        workspaceId: workspaceId
      ,
        sort:
          updatedAt: -1
        limit: limit
    children: [
      find: (thing) ->
        Meteor.users.find _id: thing.authorId
    ]
  else
    []

Meteor.reactivePublish 'allTags', (workspaceId) ->
  if @userId
    things = Things.find
      workspaceId: workspaceId
    ,
      reactive: true
    tagIds = []
    things.forEach (thing) ->
      tagIds.push thing.tagIds
    Tags.find
      _id:
        $in: _.uniq(_.flatten (tagIds))
    ,
      reactive: true
  else
    []
