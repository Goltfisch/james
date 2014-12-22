@setTitle = (title) ->
  base = 'James'
  if title then document.title = title + ' - ' + base else base
