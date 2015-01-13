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

@simpleFormat = (text) ->
  linkify = (string) ->
    regex = [
      "\\b((?:https?|ftp)://[^\\s\"'<>]+)\\b"
      "\\b(www\\.[^\\s\"'<>]+)\\b"
      "\\b(\\w[\\w.+-]*@[\\w.-]+\\.[a-z]{2,6})\\b"
    ]
    regex = new RegExp(regex.join('|'), 'gi')
    string.replace regex, (match, url, www, mail) ->
      return '<a href="' + url + '" target="_blank">' + url + '</a>' if url
      return '<a href="http://' + www + '" target="_blank">' + www + '</a>' if www
      return '<a href="mailto:' + mail + '">' + mail + '</a>' if mail
      match
  text = linkify(text)
  carriage_returns = /\r\n?/g
  paragraphs = /\n\n+/g
  newline = /([^\n]\n)(?=[^\n])/g
  text = text.replace(carriage_returns, '\n')
  text = text.replace(paragraphs, '</p>\n\n<p>')
  text = text.replace(newline, '$1<br/>')
  text = '<p>' + text + '</p>';
  text
