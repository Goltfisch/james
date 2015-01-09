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

@calculateDifferenceInDaysForTwoDates = (date1, date2) ->
  utcDate1 = Date.UTC(date1.getFullYear(), date1.getMonth(), date1.getDate())
  utcDate2 = Date.UTC(date2.getFullYear(), date2.getMonth(), date2.getDate())
  Math.floor (utcDate1 - utcDate2) / (1000 * 60 * 60 * 24)
