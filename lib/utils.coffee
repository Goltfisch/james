@extractTags = (string) ->
  tagsArray = twttr.txt.extractHashtags(string)
  normalizedTagsArray = _.map tagsArray, (tag) -> tag.trim().toLowerCase()
  _.uniq normalizedTagsArray

@getTagIdsForTagsInTagsArray = (tagsArray) ->
  tagIds = []
  _.each tagsArray, (tag) ->
    Meteor.call 'findOrCreateTag', tag, (error, id) ->
      tagIds.push id
  return tagIds
