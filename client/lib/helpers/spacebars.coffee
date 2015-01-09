UI.registerHelper 'simpleFormat', (text) ->
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
  new Spacebars.SafeString text
