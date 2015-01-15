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

Meteor.publishComposite 'collaborators', (workspaceId) ->
  if @userId
    find: ->
      Workspaces.find _id: workspaceId
    children: [
      find: (workspace) ->
        Meteor.users.find _id: $in: workspace.collaboratorIds
        ,
          sort: username: 1
    ]
  else
    []

Meteor.publishComposite 'things', (workspaceId, searchQuery, selectedTags, filterType, limit) ->
  if @userId
    find: ->
      query = {}
      query.workspaceId = workspaceId
      if searchQuery
        query.body = new RegExp(searchQuery, 'i')
      if selectedTags and selectedTags.length
        query.tagIds = { $all: selectedTags }
      if filterType is 'archived'
        query.isArchived = true
      else if filterType is 'unarchived'
        query.isArchived = false
      Things.find query
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

Meteor.reactivePublish 'allCollaborators', (workspaceId) ->
  if @userId
    workspace = Workspaces.findOne
      _id: workspaceId
    ,
      reactive: true
    Meteor.users.find
      _id: $in: workspace.collaboratorIds
    ,
      reactive: true
  else
    []
