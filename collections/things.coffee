@Things = new Mongo.Collection 'things'

Meteor.methods
  addThing: (thing) ->
    throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    throw new Meteor.Error(422, i18n 'bodyIsBlank') unless thing.body
    throw new Meteor.Error() unless thing.workspaceId

    tagsArray = extractTags(thing.body)

    throw new Meteor.Error(422, i18n 'noTagsInBody') unless tagsArray.length

    tagIds = getTagIdsForTagsInTagsArray tagsArray

    Things.insert
      body: thing.body
      tagIds: tagIds
      workspaceId: thing.workspaceId

  updateThing: (thing) ->
    throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    throw new Meteor.Error(422, i18n 'bodyIsBlank') unless thing.body
    throw new Meteor.Error() unless thing._id

    tagsArray = extractTags(thing.body)

    throw new Meteor.Error(422, i18n 'noTagsInBody') unless tagsArray.length

    tagIds = getTagIdsForTagsInTagsArray tagsArray

    Things.update
      _id: thing._id
    ,
      $set:
        body: thing.body
        tagIds: tagIds

  removeThing: (thing) ->
    throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    throw new Meteor.Error() unless thing._id

    Things.remove(thing._id)

  archiveThing: (thing) ->
    throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    throw new Meteor.Error() unless thing._id

    Things.update
      _id: thing._id
    ,
      $set:
        isArchived: true

  unarchiveThing: (thing) ->
    throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    throw new Meteor.Error() unless thing._id

    Things.update
      _id: thing._id
    ,
      $set:
        isArchived: false

Things.before.insert (userId, doc) ->
  doc.isArchived = false
  doc.authorId = userId
  doc.createdAt = new Date()
  doc.updatedAt = new Date()

Things.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = new Date()
