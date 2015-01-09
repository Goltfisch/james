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

Template.workspace.helpers
  createdAt: (thing) ->
    differenceInDays = calculateDifferenceInDaysForTwoDates(new Date(), thing.createdAt)

    if differenceInDays > 1
      moment(thing.createdAt).format('LLLL')
    else
      moment(thing.createdAt).fromNow()

  author: ->
    Meteor.users.findOne _id: @.authorId

Template.workspace.rendered = ->
  $('#add-thing-form #body').autosize()

  Mousetrap.bind [
    'command+enter'
    'ctrl+enter'
  ], (event) ->
    $('#add-thing-form').submit()
