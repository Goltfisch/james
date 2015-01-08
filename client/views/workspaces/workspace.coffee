Template.workspace.events
  'submit #add-thing-form': (event, template) ->
    event.preventDefault()

    body = template.find('#body').value

    thing =
      body: body
      workspaceId: @.workspace._id

    Meteor.call 'addThing', thing, (error) ->
      if error
        alert error.reason
      else
        template.find('#body').value = ''
        $('#add-thing-form #body').css('height', '')

Template.workspace.rendered = ->
  $('#add-thing-form #body').autosize()

  Mousetrap.bind [
    'command+enter'
    'ctrl+enter'
  ], (event) ->
    $('#add-thing-form').submit()
