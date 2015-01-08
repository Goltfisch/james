@Tags = new Mongo.Collection 'tags'

Meteor.methods
  findOrCreateTag: (name) ->
    throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    throw new Meteor.Error(422, i18n 'nameIsBlank') unless name

    tag = Tags.findOne(name: name)
    if tag
      return tag._id
    else
      newTag =
        name: name
      return Tags.insert newTag

Tags.before.insert (userId, doc) ->
  doc.createdAt = new Date()
  doc.updatedAt = new Date()
