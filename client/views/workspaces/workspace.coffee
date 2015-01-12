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

  'click a.remove-thing': (event, template) ->
    event.preventDefault()

    thing =
      _id: @._id

    if (confirm(i18n 'removeThingConfirmation'))
      Meteor.call 'removeThing', thing, (error) ->
        if error
          alert error.reason

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

  $('#add-thing-form #body').textcomplete [
    match: /\B#([\+\w]*)$/
    search: (term, callback) ->
      tags = []
      Tags.find().forEach (tag) ->
        tags.push tag.name
      tags = tags.sort()
      callback $.map(tags, (tag) ->
        (if tag.indexOf(term) is 0 then tag else null)
      )

    template: (value) ->
      '#' + value

    replace: (value) ->
      '#' + value + ' '

    index: 1
  ],
    maxCount: 5

  Mousetrap.bind [
    'command+enter'
    'ctrl+enter'
  ], (event) ->
    $('#add-thing-form').submit()
