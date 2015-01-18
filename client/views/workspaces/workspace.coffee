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

  'click a.archive-thing': (event, template) ->
    event.preventDefault()

    thing =
      _id: @._id

    Meteor.call 'archiveThing', thing, (error) ->
      if error
        alert error.reason

  'click a.unarchive-thing': (event, template) ->
    event.preventDefault()

    thing =
      _id: @._id

    Meteor.call 'unarchiveThing', thing, (error) ->
      if error
        alert error.reason

  'blur .thing .body': (event, template) ->
    event.preventDefault()

    oldBody = @.body.trim()
    newBody = event.currentTarget.innerText.trim()

    unless oldBody.localeCompare(newBody) is 0
      thing =
        _id: @._id
        body: event.currentTarget.innerText

      Meteor.call 'updateThing', thing, (error) ->
        if error
          alert error.reason

  'click #load-more-things': (event, template) ->
    event.preventDefault()

    @thingsSubscriptionHandle.loadNextPage()

  'click .tag': (event, template) ->
    selectedTags = template.findAll('input:checked')

    selectedTagsArray = []

    _.each selectedTags, (tag) ->
      selectedTagsArray.push tag.value

    Session.set('selectedTags', selectedTagsArray)

  'keyup #search-things-form': _.debounce((event, template) ->
    event.preventDefault()

    searchQuery = template.find('#search-query').value

    Session.set('searchQuery', searchQuery)
  , 300)

  'change #filter-type': (event, template) ->
    event.preventDefault()

    filterType = template.find('#filter-type').value

    Session.set('filterType', filterType)

  'click a.tags-toggle': (event, template) ->
    event.preventDefault()

    $('.tags').slideToggle()

Template.workspace.helpers
  updatedAt: (thing) ->
    differenceInDays = calculateDifferenceInDaysForTwoDates(new Date(), thing.updatedAt)

    if differenceInDays > 1
      moment(thing.updatedAt).format('LLLL')
    else
      moment(thing.updatedAt).fromNow()

  author: ->
    Meteor.users.findOne _id: @.authorId

  editableBody: (body) ->
    '<div class="body" contenteditable="true">' + simpleFormat(body) + '</div>'

  allThingsLoaded: ->
    not @thingsSubscriptionHandle.loading() and Things.find().count() < @thingsSubscriptionHandle.loaded()

  tagIdInSelectedTags: (tagId) ->
    _.contains Session.get('selectedTags'), tagId

  selectedIfFilterTypeIs: (filterType) ->
    'selected' if Session.get('filterType') is filterType

  workspaceName: ->
    Workspaces.findOne().name

  searchQuery: ->
    Session.get('searchQuery')

  availableTagsCount: ->
    Tags.find().count()

  selectedTags: ->
    if Session.get('selectedTags')
      Session.get('selectedTags').length

Template.workspace.rendered = ->
  Session.set('selectedTags', [])
  Session.set('searchQuery', '')
  Session.set('filterType', '')

  $('#add-thing-form #body').autosize()

  $('textarea#search-query').keydown (event) ->
    if (event.keyCode is 13 or event.which is 13) or ((event.shiftKey and event.keyCode is 13) or (event.shiftKey and event.which is 13))
      event.preventDefault()

  $('#add-thing-form #body, .thing .body, textarea#search-query').textcomplete [
    {
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
    }
    {
      match: /\B@([\+\w]*)$/
      search: (term, callback) ->
        collaborators = []
        Meteor.users.find().forEach (user) ->
          collaborators.push user.username
        collaborators = collaborators.sort()
        callback $.map(collaborators, (collaborator) ->
          (if collaborator.indexOf(term) is 0 then collaborator else null)
        )

      template: (value) ->
        '@' + value

      replace: (value) ->
        '@' + value + ' '

      index: 1
    }
  ],
    maxCount: 5

  Mousetrap.bind [
    'command+enter'
    'ctrl+enter'
  ], (event) ->
    $('#add-thing-form').submit()

  Mousetrap.bind [
    'escape'
  ], (event) ->
    Session.set('selectedTags', [])
    Session.set('searchQuery', '')
    Session.set('filterType', '')
